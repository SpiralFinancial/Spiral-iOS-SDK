//
// LoggingAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class LoggingAPI {

    /**
     Push immutable log entry into Spiral
     
     - parameter createLogEntryRequest: (body) Log to push into Spiral 
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer Id. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request Id used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func createLogEntry(createLogEntryRequest: CreateLogEntryRequest, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: Void?, _ error: Error?) -> Void)) -> RequestTask {
        return createLogEntryWithRequestBuilder(createLogEntryRequest: createLogEntryRequest, X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Push immutable log entry into Spiral
     - POST /log
     - Push immutable log entry into Spiral
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID (HEADER)
       - name: ClientID
     - parameter createLogEntryRequest: (body) Log to push into Spiral 
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer Id. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request Id used for troubleshooting. (optional)
     - returns: RequestBuilder<Void> 
     */
    open class func createLogEntryWithRequestBuilder(createLogEntryRequest: CreateLogEntryRequest, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<Void> {
        let localVariablePath = "/log"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: createLogEntryRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-CUSTOMER-ID": X_SPIRAL_CUSTOMER_ID?.encodeToJSON(),
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = OpenAPIClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}
