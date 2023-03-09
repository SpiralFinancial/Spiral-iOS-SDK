//
// CstAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class CstAPI {

    /**
     Create a new client
     
     - parameter clientCreationRequest: (body) Create client and default settings request 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func createClient(clientCreationRequest: ClientCreationRequest, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: ClientCreationResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return createClientWithRequestBuilder(clientCreationRequest: clientCreationRequest, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Create a new client
     - POST /cst/client
     - Creates a new client
     - parameter clientCreationRequest: (body) Create client and default settings request 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - returns: RequestBuilder<ClientCreationResponse> 
     */
    open class func createClientWithRequestBuilder(clientCreationRequest: ClientCreationRequest, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<ClientCreationResponse> {
        let localVariablePath = "/cst/client"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: clientCreationRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<ClientCreationResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)
    }

    /**
     Deletes a client
     
     - parameter clientId: (path) ID of client to delete 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func deleteClient(clientId: String, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: Void?, _ error: Error?) -> Void)) -> RequestTask {
        return deleteClientWithRequestBuilder(clientId: clientId, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Deletes a client
     - DELETE /cst/client/{clientId}
     - Deletes a client and their settings
     - parameter clientId: (path) ID of client to delete 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - returns: RequestBuilder<Void> 
     */
    open class func deleteClientWithRequestBuilder(clientId: String, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<Void> {
        var localVariablePath = "/cst/client/{clientId}"
        let clientIdPreEscape = "\(APIHelper.mapValueToPathItem(clientId))"
        let clientIdPostEscape = clientIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{clientId}", with: clientIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = OpenAPIClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "DELETE", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)
    }

    /**
     Get selected product operations
     
     - parameter clientIds: (query) Client IDs to process 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter from: (query) The search start timestamp. (optional)
     - parameter to: (query) The search end timestamp. (optional)
     - parameter query: (query) Search query; filters client names. (optional)
     - parameter product: (query) The product to fetch operation summary for - defaults to all products if not provided. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getAggregatedClientOperations(clientIds: [String], X_SPIRAL_REQUEST_ID: String? = nil, from: Double? = nil, to: Double? = nil, query: String? = nil, product: [Product]? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: FileResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getAggregatedClientOperationsWithRequestBuilder(clientIds: clientIds, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID, from: from, to: to, query: query, product: product).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Get selected product operations
     - GET /cst/operation
     - Get selected product operations in a CSV format
     - parameter clientIds: (query) Client IDs to process 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter from: (query) The search start timestamp. (optional)
     - parameter to: (query) The search end timestamp. (optional)
     - parameter query: (query) Search query; filters client names. (optional)
     - parameter product: (query) The product to fetch operation summary for - defaults to all products if not provided. (optional)
     - returns: RequestBuilder<FileResponse> 
     */
    open class func getAggregatedClientOperationsWithRequestBuilder(clientIds: [String], X_SPIRAL_REQUEST_ID: String? = nil, from: Double? = nil, to: Double? = nil, query: String? = nil, product: [Product]? = nil) -> RequestBuilder<FileResponse> {
        let localVariablePath = "/cst/operation"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "from": (wrappedValue: from?.encodeToJSON(), isExplode: true),
            "to": (wrappedValue: to?.encodeToJSON(), isExplode: true),
            "query": (wrappedValue: query?.encodeToJSON(), isExplode: true),
            "product": (wrappedValue: product?.encodeToJSON(), isExplode: true),
            "clientIds": (wrappedValue: clientIds.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<FileResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)
    }

    /**
     Get combined list of operations, aggregated at the client level
     
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter from: (query) The search start timestamp. (optional)
     - parameter to: (query) The search end timestamp. (optional)
     - parameter query: (query) Search query; filters client names. (optional)
     - parameter product: (query) The product to fetch operation summary for - defaults to all products if not provided. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getAggregatedOperationSummary(X_SPIRAL_REQUEST_ID: String? = nil, from: Double? = nil, to: Double? = nil, query: String? = nil, product: [Product]? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: CstOperationSummaryResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getAggregatedOperationSummaryWithRequestBuilder(X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID, from: from, to: to, query: query, product: product).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Get combined list of operations, aggregated at the client level
     - GET /cst/operation/summary
     - Get combined list of operations
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter from: (query) The search start timestamp. (optional)
     - parameter to: (query) The search end timestamp. (optional)
     - parameter query: (query) Search query; filters client names. (optional)
     - parameter product: (query) The product to fetch operation summary for - defaults to all products if not provided. (optional)
     - returns: RequestBuilder<CstOperationSummaryResponse> 
     */
    open class func getAggregatedOperationSummaryWithRequestBuilder(X_SPIRAL_REQUEST_ID: String? = nil, from: Double? = nil, to: Double? = nil, query: String? = nil, product: [Product]? = nil) -> RequestBuilder<CstOperationSummaryResponse> {
        let localVariablePath = "/cst/operation/summary"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "from": (wrappedValue: from?.encodeToJSON(), isExplode: true),
            "to": (wrappedValue: to?.encodeToJSON(), isExplode: true),
            "query": (wrappedValue: query?.encodeToJSON(), isExplode: true),
            "product": (wrappedValue: product?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<CstOperationSummaryResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)
    }

    /**
     Get an existing client and their settings by ID
     
     - parameter clientId: (path) ID of client to delete 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getClientById(clientId: String, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: ClientResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getClientByIdWithRequestBuilder(clientId: clientId, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Get an existing client and their settings by ID
     - GET /cst/client/{clientId}
     - Load a client and their default settings by ID
     - parameter clientId: (path) ID of client to delete 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - returns: RequestBuilder<ClientResponse> 
     */
    open class func getClientByIdWithRequestBuilder(clientId: String, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<ClientResponse> {
        var localVariablePath = "/cst/client/{clientId}"
        let clientIdPreEscape = "\(APIHelper.mapValueToPathItem(clientId))"
        let clientIdPostEscape = clientIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{clientId}", with: clientIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<ClientResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)
    }

    /**
     List existing clients
     
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getClients(X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: ClientsResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return getClientsWithRequestBuilder(X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     List existing clients
     - GET /cst/client
     - List existing clients and their default settings
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - returns: RequestBuilder<ClientsResponse> 
     */
    open class func getClientsWithRequestBuilder(X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<ClientsResponse> {
        let localVariablePath = "/cst/client"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<ClientsResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)
    }

    /**
     Partial update of a client
     
     - parameter clientPatchRequest: (body) Update client settings request 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func patchClient(clientPatchRequest: ClientPatchRequest, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: ClientCreationResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return patchClientWithRequestBuilder(clientPatchRequest: clientPatchRequest, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Partial update of a client
     - PATCH /cst/client
     - Updates main client information
     - parameter clientPatchRequest: (body) Update client settings request 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - returns: RequestBuilder<ClientCreationResponse> 
     */
    open class func patchClientWithRequestBuilder(clientPatchRequest: ClientPatchRequest, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<ClientCreationResponse> {
        let localVariablePath = "/cst/client"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: clientPatchRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<ClientCreationResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "PATCH", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)
    }

    /**
     Process selected product operations
     
     - parameter cstOperationProcessRequest: (body)  
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func processAggregatedClientOperations(cstOperationProcessRequest: CstOperationProcessRequest, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: CstOperationsResponseList?, _ error: Error?) -> Void)) -> RequestTask {
        return processAggregatedClientOperationsWithRequestBuilder(cstOperationProcessRequest: cstOperationProcessRequest, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Process selected product operations
     - PUT /cst/operation
     - Process selected product operations
     - parameter cstOperationProcessRequest: (body)  
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - returns: RequestBuilder<CstOperationsResponseList> 
     */
    open class func processAggregatedClientOperationsWithRequestBuilder(cstOperationProcessRequest: CstOperationProcessRequest, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<CstOperationsResponseList> {
        let localVariablePath = "/cst/operation"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: cstOperationProcessRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<CstOperationsResponseList>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "PUT", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)
    }

    /**
     Mass process client instant impact
     
     - parameter clientId: (path) ID of client to process II for 
     - parameter clientInstantImpactProcessRequest: (body)  
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func processClientInstantImpact(clientId: String, clientInstantImpactProcessRequest: ClientInstantImpactProcessRequest, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: CstOperationsResponseList?, _ error: Error?) -> Void)) -> RequestTask {
        return processClientInstantImpactWithRequestBuilder(clientId: clientId, clientInstantImpactProcessRequest: clientInstantImpactProcessRequest, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Mass process client instant impact
     - PUT /cst/client/{clientId}/instant/impact
     - Mass process client instant impact
     - parameter clientId: (path) ID of client to process II for 
     - parameter clientInstantImpactProcessRequest: (body)  
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - returns: RequestBuilder<CstOperationsResponseList> 
     */
    open class func processClientInstantImpactWithRequestBuilder(clientId: String, clientInstantImpactProcessRequest: ClientInstantImpactProcessRequest, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<CstOperationsResponseList> {
        var localVariablePath = "/cst/client/{clientId}/instant/impact"
        let clientIdPreEscape = "\(APIHelper.mapValueToPathItem(clientId))"
        let clientIdPostEscape = clientIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{clientId}", with: clientIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: clientInstantImpactProcessRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<CstOperationsResponseList>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "PUT", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)
    }

    /**
     Updates a client and their settings
     
     - parameter clientUpdateRequest: (body) Update client settings request 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func updateClient(clientUpdateRequest: ClientUpdateRequest, X_SPIRAL_REQUEST_ID: String? = nil, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: ClientCreationResponse?, _ error: Error?) -> Void)) -> RequestTask {
        return updateClientWithRequestBuilder(clientUpdateRequest: clientUpdateRequest, X_SPIRAL_REQUEST_ID: X_SPIRAL_REQUEST_ID).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Updates a client and their settings
     - PUT /cst/client
     - Updates client settings by key
     - parameter clientUpdateRequest: (body) Update client settings request 
     - parameter X_SPIRAL_REQUEST_ID: (header) Unique request ID used for troubleshooting. (optional)
     - returns: RequestBuilder<ClientCreationResponse> 
     */
    open class func updateClientWithRequestBuilder(clientUpdateRequest: ClientUpdateRequest, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<ClientCreationResponse> {
        let localVariablePath = "/cst/client"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: clientUpdateRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<ClientCreationResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "PUT", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)
    }
}
