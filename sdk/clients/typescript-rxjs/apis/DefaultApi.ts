// tslint:disable
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

import { Observable } from 'rxjs';
import { BaseAPI, RequiredError, HttpHeaders, HttpQuery, COLLECTION_FORMATS } from '../runtime';

/**
 * no description
 */
export class DefaultApi extends BaseAPI {

    /**
     * Read Users
     */
    readUsersImageImageUncolorizationUsersGet(): Observable<object> {
        const queryParameters: HttpQuery = {};

        const headerParameters: HttpHeaders = {};

        return this.request<object>({
            path: `/image/image/uncolorization/users/`,
            method: 'GET',
            headers: headerParameters,
            query: queryParameters,
        });
    }

    /**
     * Root
     */
    rootGet(): Observable<object> {
        const queryParameters: HttpQuery = {};

        const headerParameters: HttpHeaders = {};

        return this.request<object>({
            path: `/`,
            method: 'GET',
            headers: headerParameters,
            query: queryParameters,
        });
    }

}
