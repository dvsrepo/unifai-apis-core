#import <Foundation/Foundation.h>
#import "OAIApi.h"

/**
* FastAPI
* No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
*
* The version of the OpenAPI document: 0.1.0
* 
*
* NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
* https://openapi-generator.tech
* Do not edit the class manually.
*/



@interface OAIUsersApi: NSObject <OAIApi>

extern NSString* kOAIUsersApiErrorDomain;
extern NSInteger kOAIUsersApiMissingParamErrorCode;

-(instancetype) initWithApiClient:(OAIApiClient *)apiClient NS_DESIGNATED_INITIALIZER;

/// Read User Me
/// 
///
/// 
///  code:200 message:"Successful Response"
///
/// @return NSObject*
-(NSURLSessionTask*) readUserMeImageImageUncolorizationUsersMeGetWithCompletionHandler: 
    (void (^)(NSObject* output, NSError* error)) handler;



@end
