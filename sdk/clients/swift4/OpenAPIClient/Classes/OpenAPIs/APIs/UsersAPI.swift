//
// UsersAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import Alamofire



open class UsersAPI {
    /**
     Read User Me
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func readUserMeImageImageUncolorizationUsersMeGet(completion: @escaping ((_ data: Any?,_ error: Error?) -> Void)) {
        readUserMeImageImageUncolorizationUsersMeGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     Read User Me
     - GET /image/image/uncolorization/users/me
     - returns: RequestBuilder<Any> 
     */
    open class func readUserMeImageImageUncolorizationUsersMeGetWithRequestBuilder() -> RequestBuilder<Any> {
        let path = "/image/image/uncolorization/users/me"
        let URLString = OpenAPIClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Any>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
