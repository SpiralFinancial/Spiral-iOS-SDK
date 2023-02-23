//
//  Spiral.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/29/22.
//

import Foundation

public class Spiral {
    
    public static let shared = Spiral()
    
    fileprivate static let sdkVersion = "1.0.0"
    
    private var _config: SpiralConfig?
    
    private var _apiHeaders: [String: String] {
        var headers =  ["X-SPIRAL-SDK-VERSION": "ios-" + Spiral.sdkVersion]
        
        if let proxyAuth = _config?.proxyAuth {
            headers.add(["X-AUTH-TOKEN": proxyAuth.authToken])
        }
        
        if let clientSecretAuth = _config?.clientSecretAuth {
            headers.add(["X-SPIRAL-CUSTOMER-ID": clientSecretAuth.customerId,
                         "X-SPIRAL-CLIENT-ID": clientSecretAuth.clientId])
        }
        
        return headers
    }
    
    public func config() -> SpiralConfig? {
        return _config
    }
    
    public func startDonationFlow(delegate: SpiralDelegate) {
        startFlow(flow: .searchCharities, delegate: delegate)
    }
    
    public func startCustomerSettingsFlow(delegate: SpiralDelegate) {
        startFlow(flow: .customerSettings, delegate: delegate)
    }
    
    public func startGivingCenterFlow(delegate: SpiralDelegate) {
        startFlow(flow: .givingCenter, delegate: delegate)
    }
    
    private var _currentFlowController: SpiralViewController?
    
    func startFlow(flow: SpiralFlow, delegate: SpiralDelegate) {
        guard _config != nil else {
            print("Spiral: missing config. Please call Spiral.shared.setup() before starting this flow.")
            return
        }
        
        delegate.onBeginLoadingContent()
        
        _currentFlowController = SpiralViewController(flow: flow, delegate: delegate, onExit: { [weak self] in
            self?._currentFlowController = nil
        })
    }
    
    public func setup(config: SpiralConfig) {
        _config = config
    }
    
    public func getCustomerSettings(success: ((CustomerSettings) -> Void)?,
                                    failure: ((ErrorResponse?) -> Void)?) {
        let requestBuilder = ManagementAPI.getCustomerSettingsWithRequestBuilder()
        requestBuilder.addHeaders(_apiHeaders)
        proxyRequestForBuilder(requestBuilder: requestBuilder).execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    success?(response.body)
                case let .failure(error):
                    failure?(error)
                }
            }
        }
    }
    
    public func loadInstantImpactCard(into view: UIView,
                                      delegate: SpiralDelegate?,
                                      success: ((SpiralGenericCardView) -> Void)?,
                                      failure: ((ErrorResponse?) -> Void)?,
                                      updateLayout: EmptyOptionalClosure) {
        loadContentCard(type: GenericCardType.srSummary.rawValue,
                        into: view,
                        delegate: delegate,
                        success: success,
                        failure: failure,
                        updateLayout: updateLayout)
    }
    
    public func loadContentCard(type: String,
                                into view: UIView,
                                delegate: SpiralDelegate?,
                                success: ((SpiralGenericCardView) -> Void)?,
                                failure: ((ErrorResponse?) -> Void)?,
                                updateLayout: EmptyOptionalClosure) {
        
        let requestBuilder = CmsAPI.getGenericCardWithRequestBuilder(type: type)
        requestBuilder.addHeaders(_apiHeaders)
        proxyRequestForBuilder(requestBuilder: requestBuilder).execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let cardData = response.body.card.value as? GenericCardModel {
                        
                        let payload = SpiralGenericCardPayloadModel(identifier: 0, type: GenericCardType.srSummary.rawValue, data: cardData, isNew: false)
                        let genericCardView = SpiralGenericCardView()
                        genericCardView.isHidden = true
                        
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
                    } else {
                        failure?(nil)
                    }
                case let .failure(error):
                    failure?(error)
                }
            }
        }
        
    }
    
    public func showModalContent(type: String,
                                 success: EmptyOptionalClosure,
                                 failure: ((ErrorResponse?) -> Void)?,
                                 delegate: SpiralDelegate) {
        
        let requestBuilder = CmsAPI.getGenericCardWithRequestBuilder(type: type)
        requestBuilder.addHeaders(_apiHeaders)
        proxyRequestForBuilder(requestBuilder: requestBuilder).execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let cardData = response.body.card.value as? GenericCardModel {
                        
                        let payload = SpiralGenericCardPayloadModel(identifier: 0, type: GenericCardType.srSummary.rawValue, data: cardData, isNew: false)
                        let vc = SpiralGenericCardModalViewController.create(with: payload, delegate: delegate)
                        UIApplication.topViewController()?.present(vc, animated: true)
                        
                        success?()
                    } else {
                        failure?(nil)
                    }
                case let .failure(error):
                    failure?(error)
                }
            }
        }
    }
    
    public func getTransactionImpact(transactionId: String, completion: @escaping (SocialResponsibilityTransactionInstantImpactResponse?, ErrorResponse?) -> Void) {
        let requestBuilder = SocialResponsibilityAPI.getInstantImpactByTransactionIdWithRequestBuilder(transactionId: transactionId)
        requestBuilder.addHeaders(_apiHeaders)
        proxyRequestForBuilder(requestBuilder: requestBuilder).execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    let impactResponse = response.body
                    completion(impactResponse, nil)
                case let .failure(error):
                    completion(nil, error)
                }
            }
        }
    }
    
    public func getTransactionImpactList(transactionIds: [String], completion: @escaping (SocialResponsibilityTransactionListResponse?, ErrorResponse?) -> Void) {
        let requestBuilder = SocialResponsibilityAPI.getInstantImpactTransactionsWithRequestBuilder(ids: transactionIds)
        requestBuilder.addHeaders(_apiHeaders)
        proxyRequestForBuilder(requestBuilder: requestBuilder).execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    let impactResponse = response.body
                    completion(impactResponse, nil)
                case let .failure(error):
                    completion(nil, error)
                }
            }
        }
    }

    private func proxyRequestForBuilder<T: Decodable>(requestBuilder: RequestBuilder<T>) -> RequestBuilder<T> {
        
        guard let proxyAuth = _config?.proxyAuth else { return requestBuilder }
//        guard let proxyUrl = _config?.proxyUrl else { return requestBuilder }
        
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
            "endpoint": "/v1" + endpoint,
//            "clientId": _config?.clientId,
//            "customerId": _config?.customerId,
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

public protocol SpiralDelegate: SpiralDeepLinkHandler {
    func onEvent(name: SpiralEventType, event: SpiralEventPayload?)
    func onBeginLoadingContent()
    func onFinishLoadingContent()
    func onReady(controller: SpiralViewController)
    func onFailedToStart(_ error: SpiralError)
    func onExit(_ error: SpiralError?)
    func onSuccess(_ result: SpiralSuccessPayload)
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

public enum SpiralEnvironment {
    case local(url: String)
    case integration
    case staging
    case uat
    case production
}

public enum SpiralFlow {
    case donateToCharityById(String)
    case charityByIdSummary(String)
    case searchCharities
    case customerSettings
    case givingCenter
    case receipts
    case custom(String, String, String?)
    
    static let defaultUrlStr = "v0.0.1/apps/web-sdk/index.html"
    
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
    
    init?(typeStr: String, params: String?, url: String? = nil) {
        if url != nil && url != SpiralFlow.defaultUrlStr {
            self = .custom(typeStr, params ?? .empty, url)
            return
        }
        
        switch typeStr {
        case "customerSettings": self = .customerSettings
        case "givingCenter": self = .givingCenter
        case "donateToCharityById": self = .donateToCharityById(params ?? .empty)
        case "charityByIdSummary": self = .charityByIdSummary(params ?? .empty)
        case "searchCharities": self = .searchCharities
        case "receipts": self = .receipts
        default: self = .custom(typeStr, params ?? .empty, url)
        }
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
