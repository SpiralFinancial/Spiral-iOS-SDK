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
    
    public func startDonationFlow(token: String, delegate: SpiralDelegate, config: SpiralConfig? = nil) {
        _token = token
        _config = config
        _donationViewController = SpiralViewController(token: token, delegate: delegate, config: config, onExit: { [weak self] in
            self?._donationViewController = nil
        })
    }
    
    public func loadInstantImpactCard(into view: UIView,
                                      success: EmptyOptionalClosure,
                                      failure: EmptyOptionalClosure,
                                      updateLayout: EmptyOptionalClosure) {
        SocialResponsibilityAPI.getSocialResponsibilityImpactCard(type: "instantImpact", X_SPIRAL_SDK_VERSION: "ios-1.0.0", X_SPIRAL_CUSTOMER_ID: nil, X_SPIRAL_REQUEST_ID: nil, apiResponseQueue: DispatchQueue.global()) { data, error in
            DispatchQueue.main.async {
                if let data = data {
                    let cardData = data.card
                    let payload = SpiralGenericCardPayloadModel(identifier: 0, type: "instantImpact", data: cardData, isNew: false)
                    let genericCardView = SpiralGenericCardView()
                    genericCardView.configureWith(GenericCardDisplayModel(cardData: payload, deepLinker: nil, layoutUpdateHandler: { handler in
                        updateLayout?()
                        handler()
                    }))
                    
                    genericCardView.embed(in: view)
                    
                    success?()
                } else {
                    failure?()
                }
            }
        }
    }
    
    public func token() -> String? {
        return _token
    }
    
    public func config() -> SpiralConfig? {
        return _config
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
