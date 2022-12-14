//
// SocialResponsibilityAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class SocialResponsibilityAPI {

    /**
     Load a client-level detailed Social Impact transactions list based on provided filters
     
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter search: (query) Search query; filters transaction descriptions in a case-insensitive way. (optional)
     - parameter rewardUnit: (query) A list of reward units to include in the search. Defaults to all units if not provided. (optional)
     - parameter from: (query) The search start timestamp. (optional)
     - parameter to: (query) The search end timestamp. (optional)
     - parameter pageSize: (query) The size of the page to return. Defaults to 50 if not provided. (optional)
     - parameter pageNum: (query) The 0-indexed concurrent number of the page to return. Defaults to 0 if not provided. (optional)
     - parameter sort: (query) Fields to sort by. Supports all fields returned in the response with an optional &#39;.ASC&#39;/&#39;.DESC&#39; direction marker. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getClientInstantImpactTransactions(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, search: String? = nil, rewardUnit: [String]? = nil, from: Double? = nil, to: Double? = nil, pageSize: Double? = nil, pageNum: Double? = nil, sort: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: SocialResponsibilityTransactionListResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getClientInstantImpactTransactionsWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID, search: search, rewardUnit: rewardUnit, from: from, to: to, pageSize: pageSize, pageNum: pageNum, sort: sort).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Load a client-level detailed Social Impact transactions list based on provided filters
     - GET /social/instant/impact/client/transaction
     - Load a client-level detailed Social Impact transactions list based on provided filters
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID 
       - name: ClientID
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter search: (query) Search query; filters transaction descriptions in a case-insensitive way. (optional)
     - parameter rewardUnit: (query) A list of reward units to include in the search. Defaults to all units if not provided. (optional)
     - parameter from: (query) The search start timestamp. (optional)
     - parameter to: (query) The search end timestamp. (optional)
     - parameter pageSize: (query) The size of the page to return. Defaults to 50 if not provided. (optional)
     - parameter pageNum: (query) The 0-indexed concurrent number of the page to return. Defaults to 0 if not provided. (optional)
     - parameter sort: (query) Fields to sort by. Supports all fields returned in the response with an optional &#39;.ASC&#39;/&#39;.DESC&#39; direction marker. (optional)
     - returns: RequestBuilder<SocialResponsibilityTransactionListResponse> 
     */
    open class func getClientInstantImpactTransactionsWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, search: String? = nil, rewardUnit: [String]? = nil, from: Double? = nil, to: Double? = nil, pageSize: Double? = nil, pageNum: Double? = nil, sort: String? = nil) -> RequestBuilder<SocialResponsibilityTransactionListResponse> {
        let localVariablePath = "/social/instant/impact/client/transaction"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "search": (wrappedValue: search?.encodeToJSON(), isExplode: true),
            "rewardUnit": (wrappedValue: rewardUnit?.encodeToJSON(), isExplode: true),
            "from": (wrappedValue: from?.encodeToJSON(), isExplode: true),
            "to": (wrappedValue: to?.encodeToJSON(), isExplode: true),
            "pageSize": (wrappedValue: pageSize?.encodeToJSON(), isExplode: true),
            "pageNum": (wrappedValue: pageNum?.encodeToJSON(), isExplode: true),
            "sort": (wrappedValue: sort?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-CUSTOMER-ID": X_SPIRAL_CUSTOMER_ID?.encodeToJSON(),
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<SocialResponsibilityTransactionListResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Load a customer's Social Impact details for a single transaction
     
     - parameter transactionId: (path) Permanent, unique transaction id to retrieve the Social Responsibility Impact details for. Must survive changes to pending status or amount. 
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getInstantImpactByTransactionId(transactionId: String, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: SocialResponsibilityTransactionInstantImpactResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getInstantImpactByTransactionIdWithRequestBuilder(transactionId: transactionId, X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Load a customer's Social Impact details for a single transaction
     - GET /social/instant/impact/{transactionId}
     - Load that customer's Social Responsibility Impact details for a single transaction
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID 
       - name: ClientID
     - parameter transactionId: (path) Permanent, unique transaction id to retrieve the Social Responsibility Impact details for. Must survive changes to pending status or amount. 
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - returns: RequestBuilder<SocialResponsibilityTransactionInstantImpactResponse> 
     */
    open class func getInstantImpactByTransactionIdWithRequestBuilder(transactionId: String, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<SocialResponsibilityTransactionInstantImpactResponse> {
        var localVariablePath = "/social/instant/impact/{transactionId}"
        let transactionIdPreEscape = "\(APIHelper.mapValueToPathItem(transactionId))"
        let transactionIdPostEscape = transactionIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{transactionId}", with: transactionIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-CUSTOMER-ID": X_SPIRAL_CUSTOMER_ID?.encodeToJSON(),
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<SocialResponsibilityTransactionInstantImpactResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Load a customer's detailed Social Impact transactions list based on provided filters
     
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter ids: (query) Optional transaction ids; if provided, will be used instead of search parameters. (optional)
     - parameter search: (query) Search query; filters transaction descriptions in a case-insensitive way. (optional)
     - parameter rewardUnit: (query) A list of reward units to include in the search. Defaults to all units if not provided. (optional)
     - parameter period: (query) The period of transactions to include in the search. Defaults to ALL-TIME. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getInstantImpactTransactions(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, ids: [String]? = nil, search: String? = nil, rewardUnit: [String]? = nil, period: SummaryTimePeriod? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: SocialResponsibilityTransactionListResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getInstantImpactTransactionsWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID, ids: ids, search: search, rewardUnit: rewardUnit, period: period).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Load a customer's detailed Social Impact transactions list based on provided filters
     - GET /social/instant/impact/transaction
     - Load a customer's detailed Social Impact transactions list based on provided filters
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID 
       - name: ClientID
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter ids: (query) Optional transaction ids; if provided, will be used instead of search parameters. (optional)
     - parameter search: (query) Search query; filters transaction descriptions in a case-insensitive way. (optional)
     - parameter rewardUnit: (query) A list of reward units to include in the search. Defaults to all units if not provided. (optional)
     - parameter period: (query) The period of transactions to include in the search. Defaults to ALL-TIME. (optional)
     - returns: RequestBuilder<SocialResponsibilityTransactionListResponse> 
     */
    open class func getInstantImpactTransactionsWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, ids: [String]? = nil, search: String? = nil, rewardUnit: [String]? = nil, period: SummaryTimePeriod? = nil) -> RequestBuilder<SocialResponsibilityTransactionListResponse> {
        let localVariablePath = "/social/instant/impact/transaction"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "ids": (wrappedValue: ids?.encodeToJSON(), isExplode: true),
            "search": (wrappedValue: search?.encodeToJSON(), isExplode: true),
            "rewardUnit": (wrappedValue: rewardUnit?.encodeToJSON(), isExplode: true),
            "period": (wrappedValue: period?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-CUSTOMER-ID": X_SPIRAL_CUSTOMER_ID?.encodeToJSON(),
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<SocialResponsibilityTransactionListResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Load a customer's Social Impact
     
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter period: (query) The period of transactions to include in the search. Defaults to ALL-TIME. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getSocialResponsibilityImpactSummary(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, period: SummaryTimePeriod? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: SocialResponsibilityInstantImpactSummaryResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getSocialResponsibilityImpactSummaryWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID, period: period).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Load a customer's Social Impact
     - GET /social/instant/impact
     - Load total customer's Social Responsibility Impact
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID 
       - name: ClientID
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter period: (query) The period of transactions to include in the search. Defaults to ALL-TIME. (optional)
     - returns: RequestBuilder<SocialResponsibilityInstantImpactSummaryResponse> 
     */
    open class func getSocialResponsibilityImpactSummaryWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, period: SummaryTimePeriod? = nil) -> RequestBuilder<SocialResponsibilityInstantImpactSummaryResponse> {
        let localVariablePath = "/social/instant/impact"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "period": (wrappedValue: period?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-CUSTOMER-ID": X_SPIRAL_CUSTOMER_ID?.encodeToJSON(),
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<SocialResponsibilityInstantImpactSummaryResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}
