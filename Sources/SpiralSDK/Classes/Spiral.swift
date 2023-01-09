//
//  Spiral.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/29/22.
//

import Foundation

public class Spiral {
    
    public static let shared = Spiral()
    
    // TODO: implement auth
    private var _token: String? = "abc"
    
    private var _config: SpiralConfig?
    
    private var _apiHeaders: [String: String] {
        return ["X-SPIRAL-SDK-VERSION": "ios-1.0.0",
                "X-SPIRAL-CUSTOMER-ID": _config?.customerId ?? .empty,
                "X-SPIRAL-CLIENT-ID": _config?.clientId ?? .empty]
    }
    
    public func token() -> String? {
        return _token
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
        guard _token != nil, _config != nil else {
            print("Spiral: missing config. Please call Spiral.shared.setup() before starting this flow.")
            return
        }
        
        _currentFlowController = SpiralViewController(flow: flow, delegate: delegate, onExit: { [weak self] in
            self?._currentFlowController = nil
        })
    }
    
    public func setup(config: SpiralConfig) {
        _config = config
        
        // TODO: load token
    }
    
    public func getCustomerSettings(success: ((CustomerSettings) -> Void)?,
                                    failure: ((Error?) -> Void)?) {
        let requestBuilder = ManagementAPI.getCustomerSettingsWithRequestBuilder()
        requestBuilder.addHeaders(_apiHeaders)
        requestBuilder.execute { result in
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
                                      failure: ((Error?) -> Void)?,
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
                                failure: ((Error?) -> Void)?,
                                updateLayout: EmptyOptionalClosure) {
        
        let requestBuilder = CmsAPI.getGenericCardWithRequestBuilder(type: type)
        requestBuilder.addHeaders(_apiHeaders)
        requestBuilder.execute { result in
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
                                 failure: ((Error?) -> Void)?,
                                 delegate: SpiralDelegate) {
        
        let requestBuilder = CmsAPI.getGenericCardWithRequestBuilder(type: type)
        requestBuilder.addHeaders(_apiHeaders)
        requestBuilder.execute { result in
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
    
    public func getTransactionImpact(transactionId: String, completion: @escaping (SocialResponsibilityTransactionInstantImpactResponse?, Error?) -> Void) {
        let requestBuilder = SocialResponsibilityAPI.getInstantImpactByTransactionIdWithRequestBuilder(transactionId: transactionId)
        requestBuilder.addHeaders(_apiHeaders)
        requestBuilder.execute { result in
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
    
    public func getTransactionImpactList(transactionIds: [String], completion: @escaping (SocialResponsibilityTransactionListResponse?, Error?) -> Void) {
        let requestBuilder = SocialResponsibilityAPI.getInstantImpactTransactionsWithRequestBuilder(ids: transactionIds)
        requestBuilder.addHeaders(_apiHeaders)
        requestBuilder.execute { result in
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
            return (Spiral.shared.config()?.baseUrl ?? .empty) + "v0.0.1/apps/donate/index.html"
        case .customerSettings:
            return (Spiral.shared.config()?.baseUrl ?? .empty) + "v0.0.1/apps/customerSettings/index.html"
        case .givingCenter:
            return (Spiral.shared.config()?.baseUrl ?? .empty) + "v0.0.1/apps/givingCenter/index.html"
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
        
    public var baseUrl: String {
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
    public init(mode: SpiralMode, environment: SpiralEnvironment, clientId: String, customerId: String) {
        self.mode = mode
        self.environment = environment
        self.clientId = clientId
        self.customerId = customerId
    }
}
