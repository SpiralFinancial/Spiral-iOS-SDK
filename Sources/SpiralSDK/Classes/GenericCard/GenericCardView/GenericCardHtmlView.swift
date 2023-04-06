//
//  GenericCardHtmlView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 5/3/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import Foundation
import WebKit
import UIKit

class GenericCardHtmlView: GenericCardComponentView {
    
    enum JavascriptCommand: String {
        case addLinkInterceptors = """
        function interceptClickEvent(e) {
            var href;
            var target = e.target || e.srcElement;
            if (target.tagName === 'A' || target.tagName === 'a') {
                href = target.getAttribute('href');

                // pass message to webkit
                window.webkit.messageHandlers.linkHandler.postMessage(href);
                
                // tell the browser not to respond to the link click
                e.preventDefault();
            }
        }
        
        if (document.addEventListener) {
            document.addEventListener('click', interceptClickEvent);
        } else if (document.attachEvent) {
            document.attachEvent('onclick', interceptClickEvent);
        }
        """
        
        case disableSelectionStyle = """
        var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}';
        var head = document.head || document.getElementsByTagName('head')[0];
        var style = document.createElement('style');
        style.type = 'text/css'; style.appendChild(document.createTextNode(css));
        head.appendChild(style);
        """
        
        case disableZoomStyle = """
        var meta = document.createElement('meta');
        meta.setAttribute( 'name', 'viewport' );
        meta.setAttribute( 'content', 'width = device-width, initial-scale = 1.0, minimum-scale = 1.0, maximum-scale = 1.0, user-scalable = yes' );
        document.getElementsByTagName('head')[0].appendChild(meta)
        """
        
        case captureLogMessages = """
        function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); }
        window.console.log = captureLog;
        """
        
        case getContentHeight = """
            document.body.lastChild.getBoundingClientRect().bottom + window.scrollY
        """
    }
    
    private var webView: WKWebView?

    private var didFinishLoading: Bool = false
    
    var allowNavigation: Bool = false
    
    convenience init(allowNavigation: Bool) {
        self.init()
        self.allowNavigation = allowNavigation
    }
    
    func setupInitialLayout() {
        if webView == nil {
            let config = WKWebViewConfiguration()
            self.setupWebview(config: config)
        }
    }
    
    override func configureWith(_ data: GenericCardComponentDisplayModel) {
        super.configureWith(data)
        
        setupInitialLayout()
        
        guard let htmlComponentData = data.componentModel.content as? SpiralGenericCardHtmlComponent else { return }
        
        clearContent()
        
        let html = htmlComponentData.html
        loadHtml(html: html)
        
        setContentHeightAndDisplay(height: WebContentLayoutHelper.shared.lastKnownContentHeight(for: html) ?? Constants.defaultContentHeight)
    }
    
    func loadHtml(html: String?) {
        guard let html = html else { return }
        
        let wrappedHtml = wrapWithHTMLFontStyles(html: html)
        
        let bundleURL = Bundle.main.bundleURL
        
        webView?.loadHTMLString(wrappedHtml, baseURL: bundleURL)
    }
    
    func wrapWithHTMLFontStyles(html: String) -> String {
        var wrappedHtml = html
        if !wrappedHtml.hasPrefix("<html") {
            wrappedHtml.insert(contentsOf: Constants.fontStyleHtmlStartTag, at: wrappedHtml.startIndex)
        }
        if !wrappedHtml.hasSuffix("</html>") {
            wrappedHtml.append("</html>")
        }
        return wrappedHtml
    }

    func setContentHeightAndDisplay(height: CGFloat) {
        guard let webView = webView else { return }

        heightConstraint?.constant = height
        heightConstraint?.isActive = true
        
        webView.frame.size.width = genericContentView.frame.size.width
        webView.frame.size.height = height
    }
    
    var suggestedHeight: CGFloat {
        heightConstraint?.constant ?? 0
    }

    func clearContent() {
        webView?.evaluateJavaScript("document.body.remove()")
    }

    private func setupWebview(config: WKWebViewConfiguration?) {
        if var config = config {
            setupMessageHandling(configuration: &config)
            webView = WKWebView(frame: bounds, configuration: config)
        } else {
            webView = WKWebView()
        }

        guard let webView = webView else { return }

        webView.navigationDelegate = self
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = false
        
        webView.backgroundColor = .white

        genericContentView.addSubview(webView)
        webView.frame.size.width = genericContentView.frame.size.width
        
        let widthConstraint = NSLayoutConstraint(item: webView,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: genericContentView,
                                            attribute: .width,
                                            multiplier: 1.0,
                                            constant: 1)
        widthConstraint.priority = UILayoutPriority(999)
        widthConstraint.isActive = true

        setupScrollViewObserver()
    }

    func setupMessageHandling(configuration: inout WKWebViewConfiguration) {
        let userController = WKUserContentController()

        userController.add(self, name: "observer")

        // inject JS to capture console.log output and send to iOS
        let script = WKUserScript(source: JavascriptCommand.captureLogMessages.rawValue,
                                  injectionTime: .atDocumentEnd,
                                  forMainFrameOnly: false)
        userController.addUserScript(script)
        userController.add(self, name: "logHandler")

        addLinkInterceptors(userController: userController)
        
        configuration.userContentController = userController
    }
    
    func addLinkInterceptors(userController: WKUserContentController) {
        let script = WKUserScript(source: JavascriptCommand.addLinkInterceptors.rawValue,
                                  injectionTime: .atDocumentEnd,
                                  forMainFrameOnly: false)
        userController.addUserScript(script)
        userController.add(self, name: "linkHandler")
    }

    var scrollViewObserver: Any?

    func setupScrollViewObserver() {
        guard let webView = webView else { return }
        scrollViewObserver = webView.scrollView.observe(\.contentSize, options: [.initial, .new]) { [weak self] (_, _) in
            guard let self = self else { return }
            self.updateLayoutIfNeeded()
        }
    }

    func updateLayoutIfNeeded() {
        guard let webView = webView else { return }
        
        if didFinishLoading && webView.isLoading != true &&
            webView.scrollView.contentSize.height > 0 {
                                
            webView.evaluateJavaScript(JavascriptCommand.getContentHeight.rawValue) { [weak self] (result, _) in
                guard let self = self,
                      let height = result as? CGFloat,
                        height > 0 else { return }
                
                if self.heightConstraint?.constant != height {
                    print("Finished loading webcontent with content size: \(height)")
                    
                    if let htmlComponentData = self.componentModel?.content as? SpiralGenericCardHtmlComponent {
                        WebContentLayoutHelper.shared.setLastKnownContentHeight(for: htmlComponentData.html, height: height)
                    }
                    
                    if let layoutUpdateHandler = self.componentDisplayData?.layoutUpdateHandler {
                        layoutUpdateHandler { [weak self] in
                            self?.setContentHeightAndDisplay(height: height)
                        }
                    } else {
                        self.setContentHeightAndDisplay(height: height)
                    }
                }
            }
            
            webView.frame.size.height = webView.scrollView.contentSize.height
        }
    }

    func disableUserSelection() {
        webView?.evaluateJavaScript(JavascriptCommand.disableSelectionStyle.rawValue)
        webView?.evaluateJavaScript(JavascriptCommand.disableZoomStyle.rawValue)
    }
}

extension GenericCardHtmlView: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finished loading webview")

        disableUserSelection()

        didFinishLoading = true
        updateLayoutIfNeeded()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webview failure: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("webview failure: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(allowNavigation ? .allow : .cancel)
    }

}

extension GenericCardHtmlView: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
        
        if message.name == "logHandler" {
            print("LOG: \(message.body)")
            return
        }
        
        if message.name == "linkHandler" {
            print("LINK: \(message.body)")
            
            guard let urlString = message.body as? String else { return }
                        
            if urlString.isValidURL {
                if urlString.starts(with: "mailto:") {
                    guard let url = URL(string: urlString) else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
//                    let deepLink = SpiralDeepLink(sceneType: .webview, scene: .empty, params: ["page": urlString])
                    guard let deepLink = SpiralDeepLink(from: "/webview?page=" + urlString) else { return }
//                    componentDisplayData?.deepLinker?.goToDeepLink(deepLink)
                    SpiralDefaultDeepLinkHandler.shared.handleDeepLink(deepLink,
                                                                       priorityHandler: componentDisplayData?.delegate)
                }
            } else if let deepLink = SpiralDeepLink(from: urlString) {
//                componentDisplayData?.deepLinker?.goToDeepLink(deepLink)
                SpiralDefaultDeepLinkHandler.shared.handleDeepLink(deepLink,
                                                                   priorityHandler: componentDisplayData?.delegate)
            }
        }
    }

}

class WebContentLayoutHelper {
    static let shared = WebContentLayoutHelper()
    
    var knownHeights = [Int: CGFloat]()

    func lastKnownContentHeight(for html: String?) -> CGFloat? {
        guard let html = html else { return nil }
        
        let lastKnownHeight = knownHeights[html.hashValue]
        return lastKnownHeight
    }

    func setLastKnownContentHeight(for html: String?, height: CGFloat) {
        guard let html = html else { return }
        knownHeights[html.hashValue] = height
    }
}

private extension Constants {
    static let defaultContentHeight: CGFloat = 200
    
    static let fontStyleHtmlStartTag =
        """
        <html>
        <style>
        @font-face {
          font-family: 'sfpro-ultrathin';
          src: url(SF-Pro-Rounded-Ultralight.otf) format('opentype');
        }
        @font-face {
          font-family: 'sfpro-thin';
          src: url(SF-Pro-Rounded-Thin.otf) format('opentype');
        }
        @font-face {
          font-family: 'sfpro-light';
          src: url(SF-Pro-Rounded-Light.otf) format('opentype');
        }
        @font-face {
          font-family: 'sfpro-regular';
          src: url(SF-Pro-Rounded-Regular.otf);
        }
        @font-face {
          font-family: 'sfpro-medium';
          src: url(SF-Pro-Rounded-Medium.otf) format('opentype');
        }
        @font-face {
          font-family: 'sfpro-semibold';
          src: url(SF-Pro-Rounded-Semibold.otf) format('opentype');
        }
        @font-face {
          font-family: 'sfpro-bold';
          src: url(SF-Pro-Rounded-Bold.otf) format('opentype');
        }
        @font-face {
          font-family: 'sfpro-heavy';
          src: url(SF-Pro-Rounded-Heavy.otf) format('opentype');
        }
        @font-face {
          font-family: 'sfpro-black';
          src: url(SF-Pro-Rounded-Black.otf) format('opentype');
        }
        @font-face {
          font-family: 'signpainter-signature';
          src: url(SignPainter-HouseScript.otf) format('opentype');
        }
        @font-face {
          font-family: 'greycliff-regular';
          src: url(GreycliffCF-Regular.otf) format('opentype');
        }
        @font-face {
          font-family: 'greycliff-bold';
          src: url(GreycliffCF-Bold.otf) format('opentype');
        }
        </style>
        """
}

extension String {
    public var isValidURL: Bool {
        if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) {
            if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                // it is a link, if the match covers the whole string
                return match.range.length == self.utf16.count
            } else {
                return false
            }
        }
        return false
    }
}
