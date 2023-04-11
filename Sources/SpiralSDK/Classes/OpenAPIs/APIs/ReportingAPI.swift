//
// ReportingAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class ReportingAPI {

    /**
     Load a client-level Impact
     
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter from: (query) The search start timestamp. (optional)
     - parameter to: (query) The search end timestamp. (optional)
     - parameter search: (query) Search query; filters transaction descriptions in a case-insensitive way. (optional)
     - parameter rewardUnit: (query) A list of reward units to include in the search. Defaults to all units if not provided. (optional)
     - parameter status: (query) Transaction statuses to include. Defaults to all statuses if not provided. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getClientImpactSummary(X_SPIRAL_REQUEST_ID: String? = nil, from: Double? = nil, to: Double? = nil, search: String? = nil, rewardUnit: [String]? = nil, status: [OperationalStatus]? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: TransactionImpactSummaryResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getClientImpactSummaryWithRequestBuilder(X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID, from: from, to: to, search: search, rewardUnit: rewardUnit, status: status).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Load a client-level Impact
     - GET /everyday-impact/client
     - Load total client-level Impact
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID 
       - name: ClientID
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter from: (query) The search start timestamp. (optional)
     - parameter to: (query) The search end timestamp. (optional)
     - parameter search: (query) Search query; filters transaction descriptions in a case-insensitive way. (optional)
     - parameter rewardUnit: (query) A list of reward units to include in the search. Defaults to all units if not provided. (optional)
     - parameter status: (query) Transaction statuses to include. Defaults to all statuses if not provided. (optional)
     - returns: RequestBuilder<TransactionImpactSummaryResponse> 
     */
    open class func getClientImpactSummaryWithRequestBuilder(X_SPIRAL_REQUEST_ID: String? = nil, from: Double? = nil, to: Double? = nil, search: String? = nil, rewardUnit: [String]? = nil, status: [OperationalStatus]? = nil) -> RequestBuilder<TransactionImpactSummaryResponse> {
        let localVariablePath = "/everyday-impact/client"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "from": (wrappedValue: from?.encodeToJSON(), isExplode: true),
            "to": (wrappedValue: to?.encodeToJSON(), isExplode: true),
            "search": (wrappedValue: search?.encodeToJSON(), isExplode: true),
            "rewardUnit": (wrappedValue: rewardUnit?.encodeToJSON(), isExplode: true),
            "status": (wrappedValue: status?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<TransactionImpactSummaryResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Load a client-level detailed Impact transactions list based on provided filters
     
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter search: (query) Search query; filters transaction descriptions in a case-insensitive way. (optional)
     - parameter rewardUnit: (query) A list of reward units to include in the search. Defaults to all units if not provided. (optional)
     - parameter from: (query) The search start timestamp. (optional)
     - parameter to: (query) The search end timestamp. (optional)
     - parameter pageSize: (query) The size of the page to return. Defaults to 50 if not provided. (optional)
     - parameter pageNum: (query) The 0-indexed concurrent number of the page to return. Defaults to 0 if not provided. (optional)
     - parameter sort: (query) Fields to sort by. Supports all fields returned in the response with an optional &#39;.ASC&#39;/&#39;.DESC&#39; direction marker. (optional)
     - parameter status: (query) Transaction statuses to include. Defaults to all statuses if not provided. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getClientTransactionsImpact(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, search: String? = nil, rewardUnit: [String]? = nil, from: Double? = nil, to: Double? = nil, pageSize: Double? = nil, pageNum: Double? = nil, sort: String? = nil, status: [OperationalStatus]? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: TransactionListResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getClientTransactionsImpactWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID, search: search, rewardUnit: rewardUnit, from: from, to: to, pageSize: pageSize, pageNum: pageNum, sort: sort, status: status).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Load a client-level detailed Impact transactions list based on provided filters
     - GET /everyday-impact/client/transaction
     - Load a client-level detailed Impact transactions list based on provided filters
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
     - parameter status: (query) Transaction statuses to include. Defaults to all statuses if not provided. (optional)
     - returns: RequestBuilder<TransactionListResponse> 
     */
    open class func getClientTransactionsImpactWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, search: String? = nil, rewardUnit: [String]? = nil, from: Double? = nil, to: Double? = nil, pageSize: Double? = nil, pageNum: Double? = nil, sort: String? = nil, status: [OperationalStatus]? = nil) -> RequestBuilder<TransactionListResponse> {
        let localVariablePath = "/everyday-impact/client/transaction"
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
            "status": (wrappedValue: status?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-CUSTOMER-ID": X_SPIRAL_CUSTOMER_ID?.encodeToJSON(),
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<TransactionListResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Load a customer's Impact details for a single transaction
     
     - parameter transactionId: (path) Permanent, unique transaction id to retrieve the Impact details for. Must survive changes to pending status or amount. 
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getCustomerImpactByTransactionId(transactionId: String, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: TransactionImpactResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getCustomerImpactByTransactionIdWithRequestBuilder(transactionId: transactionId, X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Load a customer's Impact details for a single transaction
     - GET /everyday-impact/{transactionId}
     - Load that customer's Impact details for a single transaction
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID 
       - name: ClientID
     - parameter transactionId: (path) Permanent, unique transaction id to retrieve the Impact details for. Must survive changes to pending status or amount. 
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - returns: RequestBuilder<TransactionImpactResponse> 
     */
    open class func getCustomerImpactByTransactionIdWithRequestBuilder(transactionId: String, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<TransactionImpactResponse> {
        var localVariablePath = "/everyday-impact/{transactionId}"
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

        let localVariableRequestBuilder: RequestBuilder<TransactionImpactResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Load a customer's detailed Impact transactions list based on provided filters
     
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter rewardUnitId: (query) Reward unit to get transactions by. Defaults to all units if not provided. (optional)
     - parameter pageable: (query)  (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getCustomerImpactCenterTransactions(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, rewardUnitId: String? = nil, pageable: Pageable? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: EverydayImpactCenterTransactionsResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getCustomerImpactCenterTransactionsWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID, rewardUnitId: rewardUnitId, pageable: pageable).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Load a customer's detailed Impact transactions list based on provided filters
     - GET /everyday-impact/center/transaction
     - Load a customer's detailed Impact transactions list based on provided filters for Impact Center
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID 
       - name: ClientID
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter rewardUnitId: (query) Reward unit to get transactions by. Defaults to all units if not provided. (optional)
     - parameter pageable: (query)  (optional)
     - returns: RequestBuilder<EverydayImpactCenterTransactionsResponse> 
     */
    open class func getCustomerImpactCenterTransactionsWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, rewardUnitId: String? = nil, pageable: Pageable? = nil) -> RequestBuilder<EverydayImpactCenterTransactionsResponse> {
        let localVariablePath = "/everyday-impact/center/transaction"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "rewardUnitId": (wrappedValue: rewardUnitId?.encodeToJSON(), isExplode: true),
            "pageable": (wrappedValue: pageable?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-CUSTOMER-ID": X_SPIRAL_CUSTOMER_ID?.encodeToJSON(),
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<EverydayImpactCenterTransactionsResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Load a customer's Impact
     
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter period: (query) The period of transactions to include in the search. Defaults to ALL-TIME. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getCustomerImpactSummary(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, period: SummaryTimePeriod? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: TransactionImpactSummaryResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getCustomerImpactSummaryWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID, period: period).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Load a customer's Impact
     - GET /everyday-impact/customer
     - Load total customer's Impact
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID 
       - name: ClientID
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter period: (query) The period of transactions to include in the search. Defaults to ALL-TIME. (optional)
     - returns: RequestBuilder<TransactionImpactSummaryResponse> 
     */
    open class func getCustomerImpactSummaryWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, period: SummaryTimePeriod? = nil) -> RequestBuilder<TransactionImpactSummaryResponse> {
        let localVariablePath = "/everyday-impact/customer"
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

        let localVariableRequestBuilder: RequestBuilder<TransactionImpactSummaryResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Load a customer's detailed Impact transactions list based on provided filters
     
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
    open class func getCustomerTransactionsImpact(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, ids: [String]? = nil, search: String? = nil, rewardUnit: [String]? = nil, period: SummaryTimePeriod? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: TransactionListResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getCustomerTransactionsImpactWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: X_SPIRAL_CUSTOMER_ID, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID, ids: ids, search: search, rewardUnit: rewardUnit, period: period).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Load a customer's detailed Impact transactions list based on provided filters
     - GET /everyday-impact/transaction
     - Load a customer's detailed Impact transactions list based on provided filters
     - API Key:
       - type: apiKey X-SPIRAL-CLIENT-ID 
       - name: ClientID
     - parameter X_SPIRAL_CUSTOMER_ID: (header) Unique end user bank customer ID. (optional)
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter ids: (query) Optional transaction ids; if provided, will be used instead of search parameters. (optional)
     - parameter search: (query) Search query; filters transaction descriptions in a case-insensitive way. (optional)
     - parameter rewardUnit: (query) A list of reward units to include in the search. Defaults to all units if not provided. (optional)
     - parameter period: (query) The period of transactions to include in the search. Defaults to ALL-TIME. (optional)
     - returns: RequestBuilder<TransactionListResponse> 
     */
    open class func getCustomerTransactionsImpactWithRequestBuilder(X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil, ids: [String]? = nil, search: String? = nil, rewardUnit: [String]? = nil, period: SummaryTimePeriod? = nil) -> RequestBuilder<TransactionListResponse> {
        let localVariablePath = "/everyday-impact/transaction"
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

        let localVariableRequestBuilder: RequestBuilder<TransactionListResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}