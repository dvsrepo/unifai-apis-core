ARG UNIFAI_DOCKER_BASE=docker.io/unifai/unifai-base:latest

FROM $UNIFAI_DOCKER_BASE

ADD clean-layer.sh  /tmp/clean-layer.sh

COPY requirements.txt /tmp/unifai-requirements.txt

RUN for package in $(cat /tmp/unifai-requirements.txt); do echo "================="; echo "installing ${package}"; echo "================="; pip3 install $package; done

#RUN pip3 install mmcv-full -f https://download.openmmlab.com/mmcv/dist/1.3.5/torch1.7.0/cu110/mmcv_full-latest%2Btorch1.7.0%2Bcu110-cp37-cp37m-manylinux1_x86_64.whl
RUN pip3 uninstall -y botocore transformers
RUN pip3 install botocore transformers

RUN rm /tmp/clean-layer.sh

ENV PIPENV_VENV_IN_PROJECT="enabled"
COPY . /app
WORKDIR /app

RUN python3 setup_custom_envs.py
EXPOSE 80

CMD ["sh", "-c", "echo $PWD && sh run_server_prod.sh"]
