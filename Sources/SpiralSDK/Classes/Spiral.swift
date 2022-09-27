//
//  Spiral.swift
//  Pods
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

import UIKit
import WebKit

public protocol SpiralDelegate: AnyObject {
    func onEvent(name: SpiralEventType, event: SpiralEventPayload?)
    func onExit(_ error: SpiralError?)
    func onSuccess(_ result: SpiralSuccessPayload)
    func onError(_ error: SpiralError)
}

// These empty implementations are to make them optional to implement
public extension SpiralDelegate {
    func onEvent(name: SpiralEventType, event: SpiralEventPayload?) {}
    func onExit(_ error: SpiralError?) {}
    func onSuccess(_ result: SpiralSuccessPayload) {}
    func onError(_ error: SpiralError) {}
}

class SpiralWebKitScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak private var delegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
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

public class SpiralViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler {
    var webView: WKWebView!
    weak var delegate: SpiralDelegate?
    private var token: String
    private var config: SpiralConfig?
    private var url: String {
        get {
            if let config = self.config {
                return config.url
            } else {
                return "https://cdn.getspiral.com/link-v2.3.0.html"
            }
        }
    }
    
    public init(token: String, delegate: SpiralDelegate, config: SpiralConfig) {
        self.delegate = delegate
        self.token = token
        self.config = config
        super.init(nibName: nil, bundle: nil)
        
        let script = getScript(token: self.token)
        let wkScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.addUserScript(wkScript)
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        
        let contentController = webView.configuration.userContentController
        let scriptHandlerDelegate = SpiralWebKitScriptMessageHandler(delegate:self)
        for handler in SpiralEventHandler.allCases {
            contentController.add(scriptHandlerDelegate, name: handler.rawValue)
        }
        
        view = webView
        
        guard let url = URL(string: url) else {
            print("Error constructing link URL")
            return
        }
        let linkRequest = URLRequest(url: url)
        webView.load(linkRequest)
    }
    
    public convenience init(token: String, delegate: SpiralDelegate) {
        let config = SpiralConfig(mode: .sandbox, environment: .staging)
        self.init(token: token, delegate: delegate, config: config)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print(message.body)
        
        switch message.name {
        case SpiralEventHandler.openEventHandler.rawValue:
            self.delegate?.onEvent(name: .open, event: nil)
        case SpiralEventHandler.closeEventHandler.rawValue:
            self.delegate?.onEvent(name: .close, event: nil)
        case SpiralEventHandler.initEventHandler.rawValue:
            if let bodyData = bodyDataFromMessage(message),
               let event = try? JSONDecoder().decode(SpiralInitEvent.self, from: bodyData) {
                
                self.delegate?.onEvent(name: .initialized, event: event.payload)
            }
        case SpiralEventHandler.exitEventHandler.rawValue:
            if let bodyData = bodyDataFromMessage(message),
               let event = try? JSONDecoder().decode(SpiralExitEvent.self, from: bodyData) {
                
                self.delegate?.onEvent(name: .exit, event: event.payload?.error)
                self.delegate?.onExit(event.payload?.error)
            }
        case SpiralEventHandler.successEventHandler.rawValue:
            if let bodyData = bodyDataFromMessage(message),
               let event = try? JSONDecoder().decode(SpiralSuccessEvent.self, from: bodyData) {

                self.delegate?.onEvent(name: .success, event: event.payload)
                self.delegate?.onSuccess(event.payload)
            }
        case SpiralEventHandler.errorEventHandler.rawValue:
            if let bodyData = bodyDataFromMessage(message),
               let event = try? JSONDecoder().decode(SpiralErrorEvent.self, from: bodyData) {
                
                self.delegate?.onEvent(name: .error, event: event.payload)
                self.delegate?.onError(event.payload)
            }
        default:
            print("Unhandled message: \(message.name)")
        }
    }
    
    public override func loadView() {
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if let url = navigationAction.request.url {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
        return nil
    }
    
    private func bodyDataFromMessage(_ message: WKScriptMessage) -> Data? {
        if let bodyString = message.body as? String,
           let bodyData = bodyString.data(using: .utf8) {

            return bodyData
        }
        return nil
    }
    
    private func getScript(token: String) -> String {
        var versionString = "2.3.13"
        if let bundleVersion = Bundle(identifier: "org.cocoapods.SpiralSDK")?.infoDictionary?["CFBundleShortVersionString"] as? String {
            print(bundleVersion)
            versionString = bundleVersion
        }
        let version = versionString.split(separator: ".")
        
        return """
            function storageAvailable(type) {
              try {
                const storage = window[type];
                const x = '__storage_test__';
                storage.setItem(x, x);
                storage.removeItem(x);
                return true;
              } catch (e) {
                return false;
              }
            }
            
            function generateUUID() {
              let uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
              });
              return uuid;
            }
            
            function getUniqueUserId() {
                const uuidKey = 'spiral-uuid';
                if (!storageAvailable('localStorage')) {
                  return generateUUID();
                }

                let uniqueUserId = localStorage.getItem(uuidKey);
                if (!uniqueUserId) {
                  uniqueUserId = generateUUID();
                  localStorage.setItem(uuidKey, uniqueUserId);
                }
                return uniqueUserId;
            };
            
            
            const uuid = getUniqueUserId();
            try {
            window.addEventListener('message', event => {
                if (window.webkit && window.webkit.messageHandlers) {
            
                    if (event.data.type === "SPIRAL_EVENT") {
                        switch (event.data.eventName) {
                            case "\(SpiralEventType.open.rawValue)":
                                if (window.webkit.messageHandlers.\(SpiralEventHandler.openEventHandler.rawValue)) {
                                    window.webkit.messageHandlers.\(SpiralEventHandler.openEventHandler.rawValue).postMessage(JSON.stringify(event.data));
                                }
                                break;
                            case "\(SpiralEventType.close.rawValue)":
                                if (window.webkit.messageHandlers.\(SpiralEventHandler.closeEventHandler.rawValue)) {
                                    window.webkit.messageHandlers.\(SpiralEventHandler.closeEventHandler.rawValue).postMessage(JSON.stringify(event.data));
                                }
                                break;
                            case "\(SpiralEventType.initialized.rawValue)":
                                if (window.webkit.messageHandlers.\(SpiralEventHandler.initEventHandler.rawValue)) {
                                    window.webkit.messageHandlers.\(SpiralEventHandler.initEventHandler.rawValue).postMessage(JSON.stringify(event.data));
                                }
                                break;
                            case "\(SpiralEventType.exit.rawValue)":
                                if (window.webkit.messageHandlers.\(SpiralEventHandler.exitEventHandler.rawValue)) {
                                    window.webkit.messageHandlers.\(SpiralEventHandler.exitEventHandler.rawValue).postMessage(JSON.stringify(event.data));
                                }
                                break;
                            case "\(SpiralEventType.success.rawValue)":
                                if (window.webkit.messageHandlers.\(SpiralEventHandler.successEventHandler.rawValue)) {
                                    window.webkit.messageHandlers.\(SpiralEventHandler.successEventHandler.rawValue).postMessage(JSON.stringify(event.data));
                                }
                                break;
                            case "\(SpiralEventType.error.rawValue)":
                                if (window.webkit.messageHandlers.\(SpiralEventHandler.errorEventHandler.rawValue)) {
                                    window.webkit.messageHandlers.\(SpiralEventHandler.errorEventHandler.rawValue).postMessage(JSON.stringify(event.data));
                                }
                                break;
                        }
                    }
                }
            });
            window.postMessage(
              {
                type: 'SPIRAL_INIT',
                payload: {
                    sdk: "ios",
                    spiralToken: "\(token)",
                    uniqueUserId: uuid,
                    initializationTimestamp: Date.now(),
                    version: {
                        major: \(version[0]),
                        minor: \(version.count > 1 ? version[1] : "0"),
                        patch: \(version.count > 2 ? version[2] : "0")
                    },
                    deviceMetadata: {
                        os: "\(UIDevice.current.systemVersion)",
                        manufacturer: "apple",
                        model: "\(utsname())",
                        product: "\(UIDevice.current.userInterfaceIdiom)",
                        device: "\(UIDevice.current.model)",
                        hardware: "",
                        platform: "ios"
                    },
                }
              },
              "\(self.url)"
            );
            } catch (err) {
                console.error(err);
            }
            true;
            """
    }

    deinit {        
        guard let contentController = webView?.configuration.userContentController else {
            return
        }
        
        for handler in SpiralEventHandler.allCases {
            contentController.removeScriptMessageHandler(forName: handler.rawValue)
        }
    }
}

private enum SpiralEventHandler: String, CaseIterable {
    case openEventHandler
    case closeEventHandler
    case initEventHandler
    case exitEventHandler
    case successEventHandler
    case errorEventHandler
}
