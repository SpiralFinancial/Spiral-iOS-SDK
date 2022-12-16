//
//  WebViewViewController.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 25.04.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import Foundation
import WebKit

class SpiralWebViewViewController: SpiralBaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    fileprivate var didCloseClosure: (() -> Void)?
    
    static func createScene(url: String,
                            sceneTitle: String? = nil) -> SpiralWebViewViewController {
        
        guard let bundle = Bundle.spiralResourcesBundle else { return SpiralWebViewViewController() }
        
        let controller = SpiralWebViewViewController(nibName: "\(self)", bundle: bundle)
        
        controller.url = URL(string: url)
        controller.title = sceneTitle
        return controller
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didCloseClosure?()
    }
        
    // MARK: - Properties
    
    var url: URL?
    open var webView: WKWebView!
    private var fileName: String?
    
    open func setupWebview(config: WKWebViewConfiguration?) {
        if let config = config {
            webView = WKWebView(frame: .zero, configuration: config)
        } else {
            webView = WKWebView()
        }
        webView.navigationDelegate = self
        webView.embed(in: containerView)
        
        self.startInitialRequest()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebview(config: nil)
        
        if navigationController?.presentingViewController != nil && navigationController?.viewControllers.first == self {
            setupCloseButton()
        }
                
        startInitialRequest()
    }
    
    func setupCloseButton(title: String? = nil) {
        let bundle = Bundle.spiralResourcesBundle
        let closeImage = UIImage(named: "closeBlack", in: bundle, compatibleWith: nil)
        
        var barButton = UIBarButtonItem(image: closeImage,
                                        style: .done,
                                        target: self,
                                        action: #selector(didTapClose))
        if let title = title {
            barButton = UIBarButtonItem(title: title,
                                        style: .done,
                                        target: self,
                                        action: #selector(didTapClose))
        }
        barButton.accessibilityIdentifier = "navBarCloseButton"
        navigationItem.rightBarButtonItem = barButton
    }
                                        
    
    func startInitialRequest() {
        guard let url = url, let webView = webView else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func didTapClose() {
        dismiss(animated: true)
    }
    
}

extension SpiralWebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
        
}

extension WKWebViewConfiguration {
    /// Async Factory method to acquire WKWebViewConfigurations packaged with system cookies
    static func cookiesIncluded(completion: @escaping (WKWebViewConfiguration?) -> Void) {
        let config = WKWebViewConfiguration()
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            completion(config)
            return
        }
        // Use nonPersistent() or default() depending on if you want cookies persisted to disk
        // and shared between WKWebViews of the same app (default), or not persisted and not shared
        // across WKWebViews in the same app.
        let dataStore = WKWebsiteDataStore.nonPersistent()
        let waitGroup = DispatchGroup()
        for cookie in cookies {
            waitGroup.enter()
            dataStore.httpCookieStore.setCookie(cookie) { waitGroup.leave() }
        }
        waitGroup.notify(queue: DispatchQueue.main) {
            config.websiteDataStore = dataStore
            completion(config)
        }
    }
}
