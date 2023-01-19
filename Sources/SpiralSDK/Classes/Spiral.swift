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
        return ["X-SPIRAL-SDK-VERSION": "ios-" + Spiral.sdkVersion,
                "X-SPIRAL-CUSTOMER-ID": _config?.customerId ?? .empty,
                "X-SPIRAL-CLIENT-ID": _config?.clientId ?? .empty,
                "X-AUTH-TOKEN": _config?.authToken ?? .empty]
    }
    
    public func config() -> SpiralConfig? {
        return _config
    }
    
    public func startDonationFlow(delegate: SpiralDelegate) {
        startFlow(flow: .donation, delegate: delegate)
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
                                      success: ((UIView) -> Void)?,
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
                                success: ((UIView) -> Void)?,
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
        
        guard let proxyUrl = _config?.proxyUrl else { return requestBuilder }
        
        let localVariableURLString = proxyUrl
        
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
            "clientId": _config?.clientId,
            "customerId": _config?.customerId,
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
    func onReady(controller: SpiralViewController)
    func onFailedToStart(_ error: SpiralError)
    func onExit(_ error: SpiralError?)
    func onSuccess(_ result: SpiralSuccessPayload)
    func onError(_ error: SpiralError)
}

// These empty implementations are to make them optional to implement
public extension SpiralDelegate {
    func onEvent(name: SpiralEventType, event: SpiralEventPayload?) {}
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
    case staging
    case production
}

public enum SpiralFlow: String {
    case donation
    case customerSettings
    case givingCenter
    
    var url: String {
        switch self {
        case .donation:
            return (Spiral.shared.config()?.webBaseUrl ?? .empty) + "/apps/donate/index.html"
        case .customerSettings:
            return (Spiral.shared.config()?.webBaseUrl ?? .empty) + "v0.0.1/apps/customerSettings/index.html"
        case .givingCenter:
            return (Spiral.shared.config()?.webBaseUrl ?? .empty) + "v0.0.1/apps/givingCenter/index.html"
        }
    }
}

extension SpiralEnvironment {
    public init(value: String) {
        if value == "local" {
            self = .local(url: "")
        } else if value == "staging" {
            self = .staging
        } else if value == "production" {
            self = .production
        } else {
            self = .staging
        }
    }
    
    public init(value: String, url: String?) {
        if value == "local" {
            self = .local(url: url ?? "")
        } else if value == "staging" {
            self = .staging
        } else if value == "production" {
            self = .production
        } else {
            self = .staging
        }
    }
    
    public var rawValue: String {
        switch self {
        case .local(let url):
            return "local@\(url)"
        case .staging:
            return "staging"
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
    
    public let clientId: String
    public let customerId: String
    
    public let proxyUrl: String?
    public let authToken: String
        
    public var webBaseUrl: String {
        get {
            switch environment {
            case .local(let _url):
                return _url
            case .staging:
                return "https://integration-sdk.spiral.us/"
            case .production:
                return "https://sdk.spiral.us/"
            }
        }
    }
    public init(mode: SpiralMode, environment: SpiralEnvironment, clientId: String, customerId: String, authToken: String, proxyUrl: String? = nil) {
        self.mode = mode
        self.environment = environment
        self.clientId = clientId
        self.customerId = customerId
        self.authToken = authToken
        self.proxyUrl = proxyUrl
    }
}
