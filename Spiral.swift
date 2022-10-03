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
    
    public func startDonationFlow(token: String, delegate: SpiralDelegate, config: SpiralConfig? = nil) {
        _donationViewController = SpiralViewController(token: token, delegate: delegate, config: config, onExit: { [weak self] in
            self?._donationViewController = nil
        })
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
