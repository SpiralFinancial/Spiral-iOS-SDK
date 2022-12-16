//
//  DeepLink.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 10/17/22.
//

import Foundation

public class SpiralDeepLink {
    
    let path: String
    let sceneType: SceneType
    let scene: String
    let params: [String: Any]
    
    init?(from path: String) {
        
        let path = path.starts(with: "/") ? String(path.suffix(from: path.index(after: path.startIndex))) : path
        guard let url = URL(string: path) else { return nil }
        
        self.path = path
        
        let components = url.pathComponents
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems
        
        var params = [String: String]()
        queryItems?.forEach({ (item) in
            params[item.name] = item.value
        })
        
        let type = SceneType(rawValue: components.first ?? .empty) ?? .unknown
        let sceneString = components.last ?? .empty
                
        self.sceneType = type
        self.scene = sceneString
        self.params = params
    }
    
    private init(path: String, sceneType: SceneType, scene: String, params: [String: Any]) {
        self.path = path
        self.sceneType = sceneType
        self.scene = scene
        self.params = params
    }
    
    func stringParamForKey(_ key: String) -> String? {
        return params[key] as? String
    }
    
    func boolParamForKey(_ key: String) -> Bool? {
        if let boolVal = params[key] as? Bool {
            return boolVal
        }
        if let stringVal = stringParamForKey(key) {
            return Bool(stringVal)
        }
        return nil
    }
    
    func intParamForKey(_ key: String) -> Int? {
        if let intVal = params[key] as? Int {
            return intVal
        }
        if let stringVal = stringParamForKey(key) {
            return Int(stringVal)
        }
        return nil
    }
    
    func stringArrayForKey(_ key: String) -> [String]? {
        if let string = params[key] as? String {
            let strings = string.split(separator: ",").map { String($0) }
            return strings
        }
        
        return nil
    }
    
    static func == (lhs: SpiralDeepLink, rhs: SpiralDeepLink) -> Bool {
        return lhs.sceneType == rhs.sceneType && lhs.scene == rhs.scene
    }
    
    public func copy(with params: [String: Any]) -> SpiralDeepLink {
        SpiralDeepLink(path: path, sceneType: sceneType, scene: scene, params: params)
    }
}

enum SceneType: String {
    case flow
    case webview
    case actions
    case unknown
}

public protocol SpiralDeepLinkHandler: AnyObject {
    @discardableResult func handleDeepLink(_ deepLink: SpiralDeepLink) -> Bool
}

public extension SpiralDeepLinkHandler {
    @discardableResult func handleDeepLink(_ deepLink: SpiralDeepLink) -> Bool {
        return false
    }
}

extension SpiralDeepLinkHandler {
    
    private func isDismissLink(_ deepLink: SpiralDeepLink) -> Bool {
        return deepLink.scene == "dismiss"
    }
    
    @discardableResult func handleDeepLink(_ deepLink: SpiralDeepLink, priorityHandler: SpiralDelegate?) -> Bool {
        guard priorityHandler?.handleDeepLink(deepLink) ?? false == false else { return true }
            
        var deepLink = deepLink
        if let delegate = priorityHandler,
           deepLink.params["delegate"] == nil {
            var params = deepLink.params
            params["delegate"] = delegate
            deepLink = deepLink.copy(with: params)
        }
        
        return handleDeepLink(deepLink)
    }
    
    func handleDeepLinks(_ deepLinks: [SpiralDeepLink], priorityHandler: SpiralDelegate? = nil) {
        var links = [SpiralDeepLink]()
        var linksAfterDismiss = [SpiralDeepLink]()
        var didEncounterDismiss = false
        for link in deepLinks {
            if didEncounterDismiss {
                linksAfterDismiss.append(link)
            } else {
                links.append(link)
            }

            if isDismissLink(link) {
                didEncounterDismiss = true
            }
        }
        
        links.forEach({
            if isDismissLink($0) {
                dismissModal(completion: {
                    self.handleDeepLinks(linksAfterDismiss, priorityHandler: priorityHandler)
                })
            } else {
                let deepLink: SpiralDeepLink? = $0
                if let deepLink = deepLink {
                    handleDeepLink(deepLink, priorityHandler: priorityHandler)
                }
            }
        })
    }
    
    func dismissModal(completion: EmptyOptionalClosure) {
        guard let topViewController = UIApplication.topViewController() as? SpiralGenericCardModalViewController else {
            return
        }
        
        topViewController.dismiss(animated: true, completion: {
            completion?()
        })
    }
    
    func genericCardModalSceneDidRequestDismiss(controller: UIViewController) {
        controller.dismiss(animated: true)
    }
}

class SpiralDefaultDeepLinkHandler: SpiralDeepLinkHandler {
    
    static let shared = SpiralDefaultDeepLinkHandler()
        
    func handleDeepLink(_ deepLink: SpiralDeepLink) -> Bool {
        
        let sceneType = deepLink.sceneType
        
        switch sceneType {
        case .flow:
            startFlow(from: deepLink)
        case .webview:
            showWebView(from: deepLink)
        case .actions:
            handleActionsScene(deepLink: deepLink)
        case .unknown:
            _ = ""
        }
        
        return true
    }
    
    func startFlow(from deepLink: SpiralDeepLink) {
        guard let type = deepLink.stringParamForKey("type"),
              let flow = SpiralFlow(rawValue: type),
              let delegate = deepLink.params["delegate"] as? SpiralDelegate else { return }
        
        Spiral.shared.startFlow(flow: flow, delegate: delegate)
    }
    
    func handleActionsScene(deepLink: SpiralDeepLink) {
        let scene = ActionsSceneType(rawValue: deepLink.scene)
        
        switch scene {
        case .showModal:
            if let modalType = deepLink.stringParamForKey("type"),
               let delegate = deepLink.params["delegate"] as? SpiralDelegate {
                showModal(type: modalType, delegate: delegate)
            }
        case .none:
            _ = ""
        }
    }
    
    func showModal(type: String, delegate: SpiralDelegate) {
        Spiral.shared.showModalContent(type: type, success: nil, failure: nil, delegate: delegate)
    }
    
    private func showWebView(from deepLink: SpiralDeepLink) {
        var isExternal = false
        var url: String?
        
        if let style = deepLink.stringParamForKey("style") {
            isExternal = style == "external"
        }
        
        if let page = deepLink.stringParamForKey("page") {
            url = page
        } else if let urlStr = deepLink.stringParamForKey("url") {
            url = urlStr
        }
        
        guard let url = url else { return }
        
        // Don't show in an in-app webview, open externally
        if isExternal {
            guard let link = URL(string: url) else { return}
            if UIApplication.shared.canOpenURL(link) {
                UIApplication.shared.open(link, options: [:], completionHandler: nil)
            }
        } else {
            showWebView(with: url)
        }
    }
    
    private func showWebView(with url: String) {
        if let topVC = UIApplication.topViewController() {
            
            if let nav = topVC.navigationController {
                let webViewScene = SpiralWebViewViewController.createScene(url: url)
                nav.pushViewController(webViewScene, animated: true)
            } else {
                let webViewScene = SpiralWebViewViewController.createScene(url: url, sceneTitle: .empty)
                let navigation = SpiralWhiteNavigationController(rootViewController: webViewScene)
                navigation.modalPresentationStyle = .fullScreen
                topVC.present(navigation, animated: true)
            }
        }
    }
}

enum ActionsSceneType: String {
    case showModal
}
