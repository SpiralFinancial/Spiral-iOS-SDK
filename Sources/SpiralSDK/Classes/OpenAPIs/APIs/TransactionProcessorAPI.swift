//
// TransactionProcessorAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class TransactionProcessorAPI {

    /**
     Delete processed transaction
     
     - parameter transactionId: (path) Permanent, unique transaction id of transaction to be deleted. 
     - parameter X_SPIRAL_SDK_VERSION: (header) Unique version of the SDK that makes the call (ie. ios-1.2.3 or web-1.2.3) (optional)
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer Id. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request Id used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func deleteTransaction(transactionId: String, X_SPIRAL_SDK_VERSION: String? = nil, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: Void?, _ error: Error?) -> Void)) -> RequestTask {
        return deleteTransactionWithRequestBuilder(transactionId: transactionId, X_SPIRAL_SDK_VERSION: X_SPIRAL_SDK_VERSION, X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Delete processed transaction
     - DELETE /transaction/{transactionId}
     - Delete processed transaction with specified id
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID (HEADER)
       - name: ClientID
     - parameter transactionId: (path) Permanent, unique transaction id of transaction to be deleted. 
     - parameter X_SPIRAL_SDK_VERSION: (header) Unique version of the SDK that makes the call (ie. ios-1.2.3 or web-1.2.3) (optional)
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer Id. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request Id used for troubleshooting. (optional)
     - returns: RequestBuilder<Void> 
     */
    open class func deleteTransactionWithRequestBuilder(transactionId: String, X_SPIRAL_SDK_VERSION: String? = nil, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<Void> {
        var localVariablePath = "/transaction/{transactionId}"
        let transactionIdPreEscape = "\(APIHelper.mapValueToPathItem(transactionId))"
        let transactionIdPostEscape = transactionIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{transactionId}", with: transactionIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-SDK-VERSION": X_SPIRAL_SDK_VERSION?.encodeToJSON(),
            "X-SPIRAL-CUSTOMER-ID": X_SPIRAL_CUSTOMER_ID?.encodeToJSON(),
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = OpenAPIClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "DELETE", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Categorize a given financial transaction
     
     - parameter transactionProcessRequest: (body) Transaction to process 
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer Id. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request Id used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func processTransaction(transactionProcessRequest: TransactionProcessRequest, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: TransactionProcessResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return processTransactionWithRequestBuilder(transactionProcessRequest: transactionProcessRequest, X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Categorize a given financial transaction
     - POST /transaction/process
     - Request a financial transaction to be categorized on behalf of a customer.
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID (HEADER)
       - name: ClientID
     - parameter transactionProcessRequest: (body) Transaction to process 
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer Id. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request Id used for troubleshooting. (optional)
     - returns: RequestBuilder<TransactionProcessResponse?> 
     */
    open class func processTransactionWithRequestBuilder(transactionProcessRequest: TransactionProcessRequest, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<TransactionProcessResponse?> {
        let localVariablePath = "/transaction/process"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: transactionProcessRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-CUSTOMER-ID": X_SPIRAL_CUSTOMER_ID?.encodeToJSON(),
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<TransactionProcessResponse?>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}
