ARG BASE_TAG=staging

FROM nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04 AS nvidia
FROM gcr.io/kaggle-images/python:${BASE_TAG} AS dev

ADD clean-layer.sh  /tmp/clean-layer.sh

# Cuda support
COPY --from=nvidia /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/
COPY --from=nvidia /etc/apt/sources.list.d/nvidia-ml.list /etc/apt/sources.list.d/
COPY --from=nvidia /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/cuda.gpg

ENV CUDA_MAJOR_VERSION=11
ENV CUDA_MINOR_VERSION=0
ENV CUDA_VERSION=$CUDA_MAJOR_VERSION.$CUDA_MINOR_VERSION
LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/opt/bin:${PATH}
# The stub is useful to us both for built-time linking and run-time linking, on CPU-only systems.
# When intended to be used with actual GPUs, make sure to (besides providing access to the host
# CUDA user libraries, either manually or through the use of nvidia-docker) exclude them. One
# convenient way to do so is to obscure its contents by a bind mount:
#   docker run .... -v /non-existing-directory:/usr/local/cuda/lib64/stubs:ro ...
# b/197989446#comment7 libgnutls version at /opt/conda/lib causes apt to fail to fetch packages using https URLs.
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
RUN apt-get update && apt-get install -y --no-install-recommends \
      cuda-cupti-$CUDA_VERSION \
      cuda-cudart-$CUDA_VERSION \
      cuda-cudart-dev-$CUDA_VERSION \
      cuda-libraries-$CUDA_VERSION \
      cuda-libraries-dev-$CUDA_VERSION \
      cuda-nvml-dev-$CUDA_VERSION \
      cuda-minimal-build-$CUDA_VERSION \
      cuda-command-line-tools-$CUDA_VERSION \
      libcudnn8=8.0.4.30-1+cuda$CUDA_VERSION \
      libcudnn8-dev=8.0.4.30-1+cuda$CUDA_VERSION \
      libnccl2=2.7.8-1+cuda$CUDA_VERSION \
      libnccl-dev=2.7.8-1+cuda$CUDA_VERSION && \
    ln -s /usr/local/cuda-$CUDA_VERSION /usr/local/cuda && \
    ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
    /tmp/clean-layer.sh

ENV LD_LIBRARY_PATH_NO_STUBS="/usr/local/nvidia/lib64:/usr/local/cuda/lib64:/opt/conda/lib"
ENV LD_LIBRARY_PATH="/usr/local/nvidia/lib64:/usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs:/opt/conda/lib"
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_REQUIRE_CUDA="cuda>=$CUDA_MAJOR_VERSION.$CUDA_MINOR_VERSION"

# Install OpenCL & libboost (required by LightGBM GPU version)
RUN apt-get install -y \
    ocl-icd-libopencl1 \
    clinfo \
    libboost-all-dev && \
    mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd && \
    /tmp/clean-layer.sh

# When using pip in a conda environment, conda commands should be ran first and then
# the remaining pip commands: https://www.anaconda.com/using-pip-in-a-conda-environment/
# However, because this image is based on the CPU image, this isn't possible but better
# to put them at the top of this file to minize conflicts.
RUN conda install --yes --freeze-installed \
    nomkl \
    cudf=21.08 \
    cuml=21.08 \
    cudatoolkit=$CUDA_VERSION && \
    /tmp/clean-layer.sh

# Install Pytorch and torchvision with GPU support.
# Note: torchtext and torchaudio do not require a separate GPU package.
RUN pip install torch==1.7.1+cu$CUDA_MAJOR_VERSION$CUDA_MINOR_VERSION torchvision==0.8.2+cu$CUDA_MAJOR_VERSION$CUDA_MINOR_VERSION -f https://download.pytorch.org/whl/torch_stable.html && \
    /tmp/clean-layer.sh

# Install LightGBM with GPU
RUN pip uninstall -y lightgbm && \
    cd /usr/local/src && \
    git clone --recursive https://github.com/microsoft/LightGBM && \
    cd LightGBM && \
    git checkout tags/v3.2.1 && \
    mkdir build && cd build && \
    cmake -DUSE_GPU=1 -DOpenCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so -DOpenCL_INCLUDE_DIR=/usr/local/cuda/include/ .. && \
    make -j$(nproc) && \
    cd /usr/local/src/LightGBM/python-package && \
    python setup.py install --precompile && \
    mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd && \
    /tmp/clean-layer.sh

# Install JAX (Keep JAX version in sync with CPU image)
RUN pip install jax[cuda$CUDA_MAJOR_VERSION$CUDA_MINOR_VERSION]==0.2.19 -f https://storage.googleapis.com/jax-releases/jax_releases.html && \
    /tmp/clean-layer.sh

# Reinstall packages with a separate version for GPU support.
RUN pip uninstall -y mxnet && \
    pip install mxnet-cu$CUDA_MAJOR_VERSION$CUDA_MINOR_VERSION && \
    /tmp/clean-layer.sh

# Install GPU-only packages
RUN pip install pycuda && \
    pip install pynvrtc && \
    # b/190622765 latest version is causing issue. nnabla fixed it in https://github.com/sony/nnabla/issues/892, waiting for new release before we can remove this pin.
    pip install pynvml==8.0.4 && \
    pip install nnabla-ext-cuda$CUDA_MAJOR_VERSION$CUDA_MINOR_VERSION && \
    /tmp/clean-layer.sh

# Re-add TensorBoard Jupyter extension patch
# b/139212522 re-enable TensorBoard once solution for slowdown is implemented.
# ADD patches/tensorboard/notebook.py /opt/conda/lib/python3.7/site-packages/tensorboard/notebook.py

# Remove the CUDA stubs.
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH_NO_STUBS"


RUN apt-get install -y libcurl4-openssl-dev
# unifAI additional packages
COPY requirements.txt /tmp/unifai-requirements.txt


RUN for l in $(cat /tmp/unifai-requirements.txt); do echo "================="; echo $l; echo "==============";pip3 install $l; done
#pip install -r /tmp/unifai-requirements.txt

RUN pip3 uninstall -y botocore transformers
RUN pip3 install botocore transformers

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash & \ 
    apt-get install git-lfs

EXPOSE 80
WORKDIR /app


RUN rm /tmp/clean-layer.sh /tmp/kaggle.log

CMD ["sh", "-c", "echo $PWD && sh run_server_prod.sh"]


FROM scratch AS prod
COPY --from=dev / /
COPY . /app
CMD ["sh", "-c", "echo $PWD && sh run_server_prod.sh"]