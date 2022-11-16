//
//  Spiral.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/29/22.
//

import Foundation

public class Spiral {
    
    public static let shared = Spiral()
    
    private var _donationViewController: SpiralViewController?
    
    private var _token: String?
    private var _config: SpiralConfig?
    
    private var _apiHeaders: [String: String] {
        return ["X-SPIRAL-SDK-VERSION": "ios-1.0.0",
                "X-SPIRAL-CUSTOMER-ID": "CUST12345",
                "X-SPIRAL-CLIENT-ID": "a327d188-5e7e-4d1c-93bf-2d2b662ee311"]
    }
    
    public func token() -> String? {
        return _token
    }
    
    public func config() -> SpiralConfig? {
        return _config
    }
    
    public func startDonationFlow(token: String, delegate: SpiralDelegate, config: SpiralConfig? = nil) {
        _token = token
        _config = config
        _donationViewController = SpiralViewController(token: token, delegate: delegate, config: config, onExit: { [weak self] in
            self?._donationViewController = nil
        })
    }
    
    public func loadInstantImpactCard(into view: UIView,
                                      success: EmptyOptionalClosure,
                                      failure: ((Error?) -> Void)?,
                                      updateLayout: EmptyOptionalClosure) {
                
        let requestBuilder = CmsAPI.getTypedGenericCardWithRequestBuilder(type: .srSummary)
        requestBuilder.addHeaders(_apiHeaders)
        requestBuilder.execute { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let cardData = response.body.card.value as? GenericCardModel {
                        
                        let payload = SpiralGenericCardPayloadModel(identifier: 0, type: "instantImpact", data: cardData, isNew: false)
                        let genericCardView = SpiralGenericCardView()
                        genericCardView.configureWith(GenericCardDisplayModel(cardData: payload, deepLinker: nil, layoutUpdateHandler: { handler in
                            updateLayout?()
                            handler()
                        }))
                        
                        genericCardView.embed(in: view)
                        
                        success?()
                    } else {
                        failure?(nil)
                    }
                case let .failure(error):
                    failure?(error)
                }
            }
        }
        
//        SocialResponsibilityAPI.getSocialResponsibilityImpactCard(type: "SR_SUMMARY", X_SPIRAL_SDK_VERSION: "ios-1.0.0", X_SPIRAL_CUSTOMER_ID: "CUST12345", X_SPIRAL_CLIENT_ID: "9e2484b6-1d4b-4cc3-b5cf-a48790bb18ad", X_SPIRAL_REQUEST_ID: nil, apiResponseQueue: DispatchQueue.global()) { data, error in
//            DispatchQueue.main.async {
//                if let data = data,
//                    let cardData = data.card.value as? GenericCardModel {
//
//                    let payload = SpiralGenericCardPayloadModel(identifier: 0, type: "instantImpact", data: cardData, isNew: false)
//                    let genericCardView = SpiralGenericCardView()
//                    genericCardView.configureWith(GenericCardDisplayModel(cardData: payload, deepLinker: nil, layoutUpdateHandler: { handler in
//                        updateLayout?()
//                        handler()
//                    }))
//
//                    genericCardView.embed(in: view)
//
//                    success?()
//                } else {
//                    failure?(error)
//                }
//            }
//        }
    }
    
    public func showModalContent(type: String,
                                 delegate: SpiralGenericCardModalSceneDelegate,
                                 success: EmptyOptionalClosure,
                                 failure: ((Error?) -> Void)?) {
        
//        SocialResponsibilityAPI.getSocialResponsibilityImpactCard(type: "SR_SUMMARY", X_SPIRAL_SDK_VERSION: "ios-1.0.0", X_SPIRAL_CUSTOMER_ID: "CUST12345", X_SPIRAL_CLIENT_ID: "9e2484b6-1d4b-4cc3-b5cf-a48790bb18ad", X_SPIRAL_REQUEST_ID: nil, apiResponseQueue: DispatchQueue.global()) { data, error in
//            DispatchQueue.main.async {
//                if let data = data,
//                   let cardData = data.card.value as? GenericCardModel {
//                    let payload = SpiralGenericCardPayloadModel(identifier: 0, type: "instantImpact", data: cardData, isNew: false)
//
//                    let vc = SpiralGenericCardModalViewController.create(with: payload, delegate: delegate)
//                    UIApplication.topViewController()?.present(vc, animated: true)
//
//                    success?()
//                } else {
//                    failure?(error)
//                }
//            }
//        }

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
    
}

public protocol SpiralDelegate: AnyObject {
    func onEvent(name: SpiralEventType, event: SpiralEventPayload?)
    func onReady(controller: SpiralViewController)
    func onExit(_ error: SpiralError?)
    func onSuccess(_ result: SpiralSuccessPayload)
    func onError(_ error: SpiralError)
}

// These empty implementations are to make them optional to implement
public extension SpiralDelegate {
    func onEvent(name: SpiralEventType, event: SpiralEventPayload?) {}
    func onReady(controller: SpiralViewController) {}
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
    public var url: String {
        get {
            switch environment {
            case .local(let _url):
                return _url
            case .staging:
                return "https://integration-sdk.spiral.us/v0.0.1/apps/donate/index.html"
            case .production:
                return "https://cdn.getspiral.com/link-v2.3.0.html"
            }
        }
    }
    public init(mode: SpiralMode, environment: SpiralEnvironment) {
        self.mode = mode
        self.environment = environment
    }
}
