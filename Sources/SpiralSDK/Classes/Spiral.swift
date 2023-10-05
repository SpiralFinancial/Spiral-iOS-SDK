//
//  Spiral.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/29/22.
//

import Foundation
import UIKit

public class Spiral {
    
    public static let shared = Spiral()
    
    fileprivate static let sdkVersion = "1.0.0"
    
    static let apiVersion = "v2"
    
    private var _config: SpiralConfig?
    
    private var _apiHeaders: [String: String] {
        var headers =  ["X-SPIRAL-SDK-VERSION": "ios-" + Spiral.sdkVersion]
        
        // TODO: DEBUG!!
        headers.add(["X-SPIRAL-CUSTOMER-ID": "1133413950162432",
                     "X-SPIRAL-CLIENT-ID": "f6529d98-9457-4973-b530-f6d6d8c32166"])
        
        if let proxyAuth = _config?.proxyAuth {
            headers.add(["X-AUTH-TOKEN": proxyAuth.authToken])
        }
        
        if let clientSecretAuth = _config?.clientSecretAuth {
            headers.add(["X-SPIRAL-CUSTOMER-ID": clientSecretAuth.customerId,
                         "X-SPIRAL-CLIENT-ID": clientSecretAuth.clientId,
                         "X-SPIRAL-CLIENT-SECRET": clientSecretAuth.secret])
        }
        
        return headers
    }
    
    private var _sessionId: String = UUID().uuidString
    public func sessionId() -> String {
        return _sessionId
    }
    
    public func config() -> SpiralConfig? {
        return _config
    }
    
    /**
         Starts the Spiral charities search flow. See the startFlow method for details.

         - Parameters:
            - delegate: The delegate object responsible for the view controller lifecycle of this flow.
                        Use the onReady event to present the view controller.
                        Use the onSuccess, onExit, etc. events to respond to changes in the flow's lifecycle and refresh the UI when needed.
    */
    public func startSearchCharitiesFlow(delegate: SpiralDelegate) {
        startFlow(flow: .searchCharities, delegate: delegate)
    }
    
    /**
         Starts the Spiral customer settings flow where the user can also opt in to Spiral's services.
         See the startFlow method for details.

         - Parameters:
            - delegate: The delegate object responsible for the view controller lifecycle of this flow.
                        Use the onReady event to present the view controller.
                        Use the onSuccess, onExit, etc. events to respond to changes in the flow's lifecycle and refresh the UI when needed.
    */
    public func startCustomerSettingsFlow(delegate: SpiralDelegate) {
        startFlow(flow: .customerSettings, delegate: delegate)
    }
    
    /**
         Starts the Spiral giving center flow. See the startFlow method for details.

         - Parameters:
            - delegate: The delegate object responsible for the view controller lifecycle of this flow.
                        Use the onReady event to present the view controller.
                        Use the onSuccess, onExit, etc. events to respond to changes in the flow's lifecycle and refresh the UI when needed.
    */
    public func startGivingCenterFlow(delegate: SpiralDelegate) {
        startFlow(flow: .givingCenter, delegate: delegate)
    }
    
    private var _currentFlowController: SpiralViewController?
    
    /**
         Starts a Spiral flow (giving center, customer settings, opt in, etc.) from a new modal view controller.
         The delegate object is responsible for presenting the modal on the onReady event.

         - Parameters:
            - flow: The type of flow to start, which is an enum. Can use the .custom case to present a flow not predefined in this version of the SDK
            - delegate: The delegate object responsible for the view controller lifecycle of this flow.
                        Use the onReady event to present the view controller.
                        Use the onSuccess, onExit, etc. events to respond to changes in the flow's lifecycle and refresh the UI when needed.
    */
    func startFlow(flow: SpiralFlow, delegate: SpiralDelegate) {
        guard _config != nil else {
            print("Spiral: missing config. Please call Spiral.shared.setup() before starting this flow.")
            return
        }
        
        delegate.onBeginLoadingContent()
        
        _currentFlowController = SpiralViewController(flow: flow, delegate: delegate, onExit: { [weak self] in
            self?._currentFlowController = nil
        })
        
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .startFlow,
                                                                             properties: ["type" : AnyCodable(flow)]))
    }
    
    /**
         Initializes the Spiral SDK with a config object representing your organization's authentication mechanism.

         - Parameters:
            - config: A config object containing the authentication details (proxy vs. client / secret), environment, etc.
    */
    public func setup(config: SpiralConfig) {
        _config = config
        _sessionId = UUID().uuidString
        
        SpiralCustomFonts.registerFontsIfNeeded()
        
        SpiralAnalyticsManager.shared.uploadEvents()
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .sdkStart,
                                                                             properties: [:]))
    }
    
    /**
         Retrieves the signed in customer's Spiral settings.
         Useful to know whether the customer opted in to Spiral's functionality, and which limits were selected.

         - Parameters:
            - success: A callback for successfully retrieving the customer's settings with a response object returned
            - failure: A callback closure for error handling in the event we are unable to retrieve the customer settings

         - Returns: A CustomerSettings object representing the signed in customer's selections
    */
    public func getCustomerSettings(success: ((CustomerSettings) -> Void)?,
                                    failure: ((ErrorResponse?) -> Void)?) {
        
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadCustomerSettings,
                                                                             properties: [:]))
        
        let requestBuilder = ManagementAPI.getCustomerSettingsWithRequestBuilder()
        requestBuilder.addHeaders(_apiHeaders)
        proxyRequestForBuilder(requestBuilder: requestBuilder).execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    success?(response.body)
                    
                    SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadCustomerSettingsSuccess,
                                                                                         properties: [:]))
                case let .failure(error):
                    failure?(error)
                    
                    SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadCustomerSettingsError,
                                                                                         properties: ["error": AnyCodable(error.message)]))
                }
            }
        }
    }
    
    /**
         Loads the everyday impact summary card into a container view and provides callbacks for view lifecycle

         - Parameters:
            - view: Container view where the card will be added as a subview.
                    The card will stretch to all edges and take up maximum space within the container.
            - delegate: The card view could potentially start a Spiral flow if the user interacts with it.
                        This delegate object is used to handle the lifecycle of this flow.
                        See the startFlow documentation for more details.
            - success: A success callback when the card is loaded into the container view. Can be used to hide a loading indicator.
                       This closure contains a reference to the card view which was added.
            - failure: A success callback when the card was unable to load. Can be used to hide the entire container view, show an error message, etc.
            - updateLayout: This closure is called when the card renders and establishes it's required height.
                            At this point it may be necessary to reload those cells in a UITableView for example to accomade the needed space.
    */
    public func loadEverydayImpactCard(into view: UIView,
                                      delegate: SpiralDelegate?,
                                      success: ((SpiralGenericCardView) -> Void)?,
                                      failure: ((ErrorResponse?) -> Void)?,
                                      updateLayout: EmptyOptionalClosure) {
        loadContentCard(type: GenericTemplateType.srSummary.rawValue,
                        into: view,
                        delegate: delegate,
                        success: success,
                        failure: failure,
                        updateLayout: updateLayout)
    }
    
    /**
         Loads the opt-in card into a container view and provides callbacks for view lifecycle

         - Parameters:
            - view: Container view where the card will be added as a subview.
                    The card will stretch to all edges and take up maximum space within the container.
            - delegate: The card view could potentially start a Spiral flow if the user interacts with it.
                        This delegate object is used to handle the lifecycle of this flow.
                        See the startFlow documentation for more details.
            - success: A success callback when the card is loaded into the container view. Can be used to hide a loading indicator.
                       This closure contains a reference to the card view which was added.
            - failure: A success callback when the card was unable to load. Can be used to hide the entire container view, show an error message, etc.
            - updateLayout: This closure is called when the card renders and establishes it's required height.
                            At this point it may be necessary to reload those cells in a UITableView for example to accomodate the needed space.
    */
    public func loadOptInCard(into view: UIView,
                                      delegate: SpiralDelegate?,
                                      success: ((SpiralGenericCardView) -> Void)?,
                                      failure: ((ErrorResponse?) -> Void)?,
                                      updateLayout: EmptyOptionalClosure) {
        loadContentCard(type: GenericTemplateType.srSummary.rawValue,
                        into: view,
                        delegate: delegate,
                        success: success,
                        failure: failure,
                        updateLayout: updateLayout)
    }
    
    /**
         Loads a custom content card by string ID which is not known ahead of time to the SDK.
         Said content can potentially be configured server side for your organization's needs.

         - Parameters:
            - type: The string ID for the content which has been configured for display.
            - view: Container view where the card will be added as a subview.
                    The card will stretch to all edges and take up maximum space within the container.
            - delegate: The card view could potentially start a Spiral flow if the user interacts with it.
                        This delegate object is used to handle the lifecycle of this flow.
                        See the startFlow documentation for more details.
            - success: A success callback when the card is loaded into the container view. Can be used to hide a loading indicator.
                       This closure contains a reference to the card view which was added.
            - failure: A failure callback when the card was unable to load. Can be used to hide the entire container view, show an error message, etc.
            - updateLayout: This closure is called when the card renders and establishes it's required height.
                            At this point it may be necessary to reload those cells in a UITableView for example to accomade the needed space.
    */
    public func loadContentCard(type: String,
                                into view: UIView,
                                delegate: SpiralDelegate?,
                                success: ((SpiralGenericCardView) -> Void)?,
                                failure: ((ErrorResponse?) -> Void)?,
                                updateLayout: EmptyOptionalClosure) {
        
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadGenericContent,
                                                                             properties: ["type": AnyCodable(type)]))
        
        let requestBuilder = CmsAPI.getGenericCardWithRequestBuilder(type: type)
        requestBuilder.addHeaders(_apiHeaders)
        proxyRequestForBuilder(requestBuilder: requestBuilder).execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let cardData = response.body.template.value as? GenericCardModel {
                        
                        let payload = SpiralGenericCardPayloadModel(identifier: 0, type: type, data: cardData, isNew: false)
                        let genericCardView = SpiralGenericCardView()
                        genericCardView.isHidden = true
                        
                        genericCardView.analyticsIdentifier = "generic-\(type)"
                        
                        genericCardView.embed(in: view)
                        genericCardView.configureWith(GenericCardDisplayModel(cardData: payload,
                                                                              delegate: delegate,
                                                                              layoutUpdateHandler: { handler in
                            DispatchQueue.main.async {
                                updateLayout?()
                            }
                            handler()
                        }))
                        
                        genericCardView.isHidden = false
                        
                        success?(genericCardView)
                        
                        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadGenericContentSuccess,
                                                                                             properties: ["type": AnyCodable(type)]))
                    } else {
                        failure?(nil)
                    }
                case let .failure(error):
                    failure?(error)
                    
                    SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadGenericContentError,
                                                                                         properties: ["type": AnyCodable(type),
                                                                                                      "error": AnyCodable(error.message)]))
                }
            }
        }
        
    }
    
    /**
         Shows a custom content modal by string ID which is not known ahead of time to the SDK.
         Said content can potentially be configured server side for your organization's needs.

         - Parameters:
            - type: - type: The string ID for the content which has been configured for display.
            - success: A success callback when the content modal has been displayed. Can be used to hide a loading indicator.
            - failure: A failure callback when the card was unable to load. Can be used to show an error message, etc.
            - delegate: The content modal could potentially start a Spiral flow if the user interacts with it.
                        This delegate object is used to handle the lifecycle of this flow.
                        See the startFlow documentation for more details.
    */
    public func showModalContent(type: String,
                                 success: EmptyOptionalClosure,
                                 failure: ((ErrorResponse?) -> Void)?,
                                 delegate: SpiralDelegate) {
        
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadModalContent,
                                                                             properties: ["type": AnyCodable(type)]))
        
        let requestBuilder = CmsAPI.getGenericCardWithRequestBuilder(type: type)
        requestBuilder.addHeaders(_apiHeaders)
        proxyRequestForBuilder(requestBuilder: requestBuilder).execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let cardData = response.body.template.value as? GenericCardModel {
                        
                        let payload = SpiralGenericCardPayloadModel(identifier: 0, type: GenericTemplateType.srSummary.rawValue, data: cardData, isNew: false)
                        let vc = SpiralGenericCardModalViewController.create(with: payload, delegate: delegate)
                        UIApplication.topViewController()?.present(vc, animated: true)
                        
                        success?()
                        
                        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadModalContentSuccess,
                                                                                             properties: ["type": AnyCodable(type)]))
                    } else {
                        failure?(nil)
                    }
                case let .failure(error):
                    failure?(error)
                    
                    SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadModalContentError,
                                                                                         properties: ["type": AnyCodable(type),
                                                                                                      "error": AnyCodable(error.message)]))
                }
            }
        }
    }
    
    /**
         Retrieves the impact details for a given transaction (category, reward units earned, rounded up amount, etc.)

         - Parameters:
            - transactionId: The string ID for this transaction
            - completion: A callback closure containing the response object and error if we were unable to retrieve the impact

         - Returns: A SocialResponsibilityTransactionInstantImpactResponse object representing the customer's impact for this transaction
    */
    public func getTransactionImpact(transactionId: String, completion: @escaping (TransactionImpactResponse?, ErrorResponse?) -> Void) {
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadTransactionImpact,
                                                                             properties: [:]))
        
        let requestBuilder = ReportingAPI.getCustomerImpactByTransactionIdWithRequestBuilder(transactionId: transactionId)
        requestBuilder.addHeaders(_apiHeaders)
        proxyRequestForBuilder(requestBuilder: requestBuilder).execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    let impactResponse = response.body
                    completion(impactResponse, nil)
                    
                    SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadTransactionImpactSuccess,
                                                                                         properties: [:]))
                case let .failure(error):
                    completion(nil, error)
                    
                    SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadTransactionImpactError,
                                                                                         properties: ["error": AnyCodable(error.message)]))
                }
            }
        }
    }
    
    /**
         Retrieves the impact details for a list of transactions (category, reward units earned, rounded up amount, etc.)

         - Parameters:
            - transactionIds: An array of string IDs for the transactions we'd like impact details for
            - completion: A callback closure containing the response object and error if we were unable to retrieve the impact

         - Returns: A SocialResponsibilityTransactionListResponse object representing the customer's impact for the given transaction IDs
    */
    public func getTransactionImpactList(transactionIds: [String], completion: @escaping (TransactionsImpactResponse?, ErrorResponse?) -> Void) {
        
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadTransactionsImpactList,
                                                                             properties: [:]))
        
        let requestBuilder = ReportingAPI.getCustomerTransactionsImpactWithRequestBuilder(ids: transactionIds)
        requestBuilder.addHeaders(_apiHeaders)
        proxyRequestForBuilder(requestBuilder: requestBuilder).execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    let impactResponse = response.body
                    completion(impactResponse, nil)
                    
                    SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadTransactionsImpactListSuccess,
                                                                                         properties: [:]))
                case let .failure(error):
                    completion(nil, error)
                    
                    SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(sdkEvent: .loadTransactionsImpactListError,
                                                                                         properties: ["error": AnyCodable(error.message)]))
                }
            }
        }
    }
    
    public func trackAnalyticsEvents(events: [SpiralAnalyticsEvent], completion: @escaping (Bool, ErrorResponse?) -> Void) {
        let apiEvents = events.map { CreateAnalyticsEventRequest(id: $0.id,
                                                                 sessionId: _sessionId,
                                                                 type: $0.event,
                                                                 context: $0.properties,
                                                                 eventDate: $0.time) }
        let batchRequest = CreateAnalyticsEventBatchRequest(events: apiEvents)
        
        let requestBuilder = SpiralAnalyticsAPI.createAnalyticsEventsWithRequestBuilder(createAnalyticsEventBatchRequest: batchRequest)
        requestBuilder.addHeaders(_apiHeaders)
        requestBuilder.execute { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    completion(true, nil)
                case let .failure(error):
                    completion(false, error)
                }
            }
        }
    }

    private func proxyRequestForBuilder<T: Decodable>(requestBuilder: RequestBuilder<T>) -> RequestBuilder<T> {
        
        guard let proxyAuth = _config?.proxyAuth else { return requestBuilder }
        
        let localVariableURLString = proxyAuth.proxyUrl
        
        let endpoint = String(requestBuilder.URLString.suffix(requestBuilder.URLString.count - OpenAPIClientAPI.basePath.count))
        
        var paramsData: Data? = nil
        if let parameters = requestBuilder.parameters {
            paramsData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        var bodyStr: String? = nil
        if let paramsData = paramsData {
            bodyStr = String(data: paramsData, encoding: .utf8)
        }
        
        let localNillableVariableParameters: [String: Encodable?] = [
            "method": requestBuilder.method,
            "endpoint": "/" + Spiral.apiVersion + endpoint,
            "body": bodyStr,
            "version": "ios-" + Spiral.sdkVersion
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: localNillableVariableParameters, options: .prettyPrinted)
        
        let localVariableParameters: [String: Any] = ["jsonData": jsonData ?? [String: Any]()]
        let localVariableUrlComponents = URLComponents(string: localVariableURLString)
        let localVariableNillableHeaders: [String: Any?] = requestBuilder.headers
        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<T>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}

/// SpiralDelegate provides ways to respond to the lifecycle of Spiral Flows (Giving center, opt in, donation, etc.)
public protocol SpiralDelegate: SpiralDeepLinkHandler {
    /// Called for every meaningful event which occurs within the flow.
    /// Can be used for logging and custom implementation purposes.
    /// - Parameter name: Name of the referenced event
    /// - Parameter event: Payload object for the specific event which contains additional information
    func onEvent(name: SpiralEventType, event: SpiralEventPayload?)
    
    /// Called when loading the flow before it is ready for display. Can be used to show a loading indicator.
    func onBeginLoadingContent()
    
    /// Called when the flow is finished loading, in both success and failure scenarios.
    /// Can be used to hide a loading indicator.
    func onFinishLoadingContent()
    
    /// After the flow loads content in the background,
    /// onReady is called allowing you to present the view controller from your view heirarchy.
    /// - Parameter controller: The Spiral flow view controller to be presented.
    func onReady(controller: SpiralViewController)
    
    /// In the event a flow attempts to load and fails to start for whatever reason,
    /// onFailedToStart is called so that an error message can be displayed.
    /// - Parameter error: The error responsible for the flow failing to start.
    func onFailedToStart(_ error: SpiralError)
    
    /// Called when the flow exits and the controller is dismissed.
    /// - Parameter error: If the flow exited in the event of an error, it will be passed here.
    func onExit(_ error: SpiralError?)
    
    /// Called when the user successfully completes an action in the flow (donation processed, opted in, etc.)
    /// This allows you to respond to the success event appropriately (updating the underlying UI for example.)
    /// - Parameter result: A payload object with additional details related to the user's actions.
    func onSuccess(_ result: SpiralSuccessPayload)
    
    /// If an error is encountered during the flow's lifecycle, this will be called
    /// - Parameter error: The error encountered during the flow.
    func onError(_ error: SpiralError)
}

// These empty implementations are to make them optional to implement
public extension SpiralDelegate {
    func onEvent(name: SpiralEventType, event: SpiralEventPayload?) {}
    func onBeginLoadingContent() {}
    func onFinishLoadingContent() {}
    func onReady(controller: SpiralViewController) {}
    func onFailedToStart(_ error: SpiralError) {}
    func onExit(_ error: SpiralError?) {}
    func onSuccess(_ result: SpiralSuccessPayload) {}
    func onError(_ error: SpiralError) {}
}

public enum SpiralMode: String, CaseIterable {
    case development
    case sandbox
    case production
}

public enum SpiralEnvironment: Equatable {
    case local(url: String)
    case integration
    case staging
    case uat
    case production
}

public enum SpiralFlow: Codable {
    /// Donation initiation flow for a specific charity.
    case donateToCharityById(charityId: String)
    
    /// Flow begins with showing a specific charity's summary page, allowing the customer to initiate a donation.
    case charityByIdSummary(charityId: String)
    
    /// Allows the customer to search through available non-profits, optionally initiating a donation.
    case searchCharities
    
    /// This flow is used for both customer opt in to Spiral's services, as well as updating their settings.
    case customerSettings
    
    /// The giving center flow allows the customer to view their configured monthly donations,
    /// search charities to set up new donations, and update settings for existing donations.
    case givingCenter
    
    /// Flow which allows the customer to view a list of receipts for past donations.
    case receipts
    
    /// In the event you'd like to initiate a custom flow not recognized by this version of the SDK,
    /// you can pass through required information here.
    case custom(type: String, params: String, url: String?)
    
    static let defaultUrlStr = "v1/apps/web-sdk/index.html"
    
    var url: String {
        let baseUrl = Spiral.shared.config()?.webBaseUrl ?? .empty
        switch self {
        case .custom(_, _, let urlStr):
            guard let urlStr = urlStr else { return baseUrl + SpiralFlow.defaultUrlStr }
            if urlStr.hasPrefix(baseUrl) {
                return baseUrl + urlStr
            } else {
                return urlStr
            }
        default:
            return baseUrl + SpiralFlow.defaultUrlStr
        }
    }
    
    var params: String {
        switch self {
        case .donateToCharityById(let id):
            return "{\"id\": '\(id)'}"
        case .charityByIdSummary(let id):
            return "{\"id\": '\(id)'}"
        case .custom(_, let params, _):
            return params
        default:
            return "{}"
        }
    }
    
    var stringVal: String {
        switch self {
            
        case .donateToCharityById(_):
            return "donateToCharityById"
        case .charityByIdSummary(_):
            return "charityByIdSummary"
        case .searchCharities:
            return "searchCharities"
        case .customerSettings:
            return "customerSettings"
        case .givingCenter:
            return "givingCenter"
        case .receipts:
            return "receipts"
        case .custom(let type, _, _):
            return type
        }
    }
    
    init(typeStr: String, params: String?, url: String? = nil) {
        if url != nil && url != SpiralFlow.defaultUrlStr {
            self = .custom(type: typeStr, params: params ?? .empty, url: url)
            return
        }
        
        switch typeStr {
        case "customerSettings": self = .customerSettings
        case "givingCenter": self = .givingCenter
        case "donateToCharityById": self = .donateToCharityById(charityId: params ?? .empty)
        case "charityByIdSummary": self = .charityByIdSummary(charityId: params ?? .empty)
        case "searchCharities": self = .searchCharities
        case "receipts": self = .receipts
        default: self = .custom(type: typeStr, params: params ?? .empty, url: url)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case params
        case url
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stringVal, forKey: .type)
        try container.encodeIfPresent(params, forKey: .params)
        try container.encodeIfPresent(url, forKey: .url)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let type = try values.decode(String.self, forKey: .type)
        let params = try values.decodeIfPresent(String.self, forKey: .params)
        let url = try values.decodeIfPresent(String.self, forKey: .url)
                
        self.init(typeStr: type, params: params, url: url)
    }
}

extension SpiralEnvironment {
    public init(value: String) {
        if value == "local" {
            self = .local(url: "")
        } else if value == "integration" {
            self = .integration
        } else if value == "staging" {
            self = .staging
        } else if value == "uat" {
            self = .uat
        } else if value == "production" {
            self = .production
        } else {
            self = .integration
        }
    }
    
    public init(value: String, url: String?) {
        if value == "local" {
            self = .local(url: url ?? "")
        } else if value == "staging" {
            self = .staging
        } else if value == "uat" {
            self = .uat
        } else if value == "production" {
            self = .production
        } else {
            self = .integration
        }
    }
    
    public var rawValue: String {
        switch self {
        case .local(let url):
            return "local@\(url)"
        case .integration:
            return "integration"
        case .staging:
            return "staging"
        case .uat:
            return "uat"
        case .production:
            return "production"
        }
    }
    
    public static func isTestEnvironment() -> Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    public static func isPreviewEnvironment() -> Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

public struct SpiralConfig {
    public let mode: SpiralMode
    public let environment: SpiralEnvironment
    
    public let proxyAuth: SpiralProxyAuth?
    public let clientSecretAuth: SpiralClientSecretAuth?
    
    public var webBaseUrl: String {
        get {
            switch environment {
            case .local(let _url):
                return _url
            case .staging:
                return "https://staging-sdk.spiral.us/"
            case .integration:
                return "https://integration-sdk.spiral.us/"
            case .uat:
                return "https://uat-sdk.spiral.us/"
            case .production:
                return "https://sdk.spiral.us/"
            }
        }
    }
    public init(mode: SpiralMode,
                environment: SpiralEnvironment,
                proxyAuth: SpiralProxyAuth? = nil,
                clientSecrethAuth: SpiralClientSecretAuth? = nil) {
        self.mode = mode
        self.environment = environment
        self.proxyAuth = proxyAuth
        self.clientSecretAuth = clientSecrethAuth
    }
}

public struct SpiralProxyAuth {
    public let proxyUrl: String
    public let authToken: String
    
    public init(proxyUrl: String, authToken: String) {
        self.proxyUrl = proxyUrl
        self.authToken = authToken
    }
}

public struct SpiralClientSecretAuth {
    public let customerId: String
    public let clientId: String
    public let secret: String
    
    public init(customerId: String, clientId: String, secret: String) {
        self.customerId = customerId
        self.clientId = clientId
        self.secret = secret
    }
}
