//
//  Spiral.swift
//  Pods
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

import UIKit
import WebKit

class SpiralWebKitScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak private var delegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}

public class SpiralViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    var webView: WKWebView!
    weak var delegate: SpiralDelegate?
    private var flow: SpiralFlow
    private var url: String {
        return flow.url
    }
    
    private var wasReady: Bool = false
    
    private var onExit: (() -> Void)?
    
    public init(flow: SpiralFlow, delegate: SpiralDelegate, onExit: ( () -> Void)? = nil ) {
        self.delegate = delegate
        self.flow = flow
        self.onExit = onExit
        super.init(nibName: nil, bundle: nil)
        
        let script = getScript()
        let wkScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
                
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.addUserScript(wkScript)
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        
        let contentController = webView.configuration.userContentController
        let scriptHandlerDelegate = SpiralWebKitScriptMessageHandler(delegate:self)
        for handler in SpiralEventHandler.allCases {
            contentController.add(scriptHandlerDelegate, name: handler.rawValue)
        }
                
        guard let url = URL(string: url) else {
            print("Error constructing link URL")
            return
        }
        let linkRequest = URLRequest(url: url)
        webView.load(linkRequest)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print(message.body)
        
        switch message.name {
        case SpiralEventHandler.openEventHandler.rawValue:
            self.delegate?.onEvent(name: .open, event: nil)
            self.delegate?.onFinishLoadingContent()
            self.delegate?.onReady(controller: self)
            self.wasReady = true
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
                
                self.onExit?()
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
                
                if !wasReady {
                    self.delegate?.onFinishLoadingContent()
                }
                
                self.delegate?.onError(event.payload)
            }
        default:
            print("Unhandled message: \(message.name)")
        }
    }
    
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        if let response = navigationResponse.response as? HTTPURLResponse {
            if !wasReady, response.statusCode != 200 {
                self.delegate?.onFinishLoadingContent()
                self.delegate?.onFailedToStart(SpiralError(type: SpiralErrorType.failedToStartFlow.rawValue,
                                                           code: String(response.statusCode),
                                                           message: "Unable to start Spiral flow. Please try again later."))
                self.onExit?()
            }
        }
        decisionHandler(.allow)
    }
    
    public override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        var yOffset: CGFloat = 0
        
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        if #available(iOS 13.0, *) {
            let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            yOffset = modalPresentationStyle == .fullScreen ? statusBarHeight : 0
        } else {
            yOffset = UIApplication.shared.statusBarFrame.height
        }
        
        
        webView.frame = CGRect(x: 0,
                               y: yOffset,
                               width: view.frame.width,
                               height: view.frame.height - yOffset)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.clipsToBounds = true
        view.addSubview(webView)
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
    
    var initAuthParams: String {
        if let proxyAuth = Spiral.shared.config()?.proxyAuth {
            return """
            authToken: "\(proxyAuth.authToken)",
            proxyUrl: "\(proxyAuth.proxyUrl)",
            """
        } else if let clientSecretAuth = Spiral.shared.config()?.clientSecretAuth {
            return """
            customerId: "\(clientSecretAuth.customerId)",
            clientId: "\(clientSecretAuth.clientId)",
            clientSecret: "\(clientSecretAuth.secret)",
            """
        }
        return .empty
    }
    
    private func getScript() -> String {
        var versionString = "1.0.0"
        if let bundleVersion = Bundle(identifier: "org.cocoapods.SpiralSDK")?.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("Spiral version: " + bundleVersion)
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
                    \(initAuthParams)
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
