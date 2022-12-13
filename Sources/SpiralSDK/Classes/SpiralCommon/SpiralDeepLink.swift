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
    
//    init(sceneType: SceneType, scene: String, params: [String: Any] = [String: Any]()) {
//        self.sceneType = sceneType
//        self.scene = scene
//        self.params = params
//    }
    
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
}

enum SceneType: String {
    case webview
    case actions
    case unknown
    
//    var coordinatorType: SpiralDeepLinkable.Type {
//        switch self {
//        case .webview, .actions:
//            return ActionsCoordinator.self
//        }
//    }
}

//public protocol DeepLinkable: Coordinator {
//    var navigationController: UINavigationController { get }
//    var deepLinkHandlers: [DeepLinkHandler]? { get set }
//    init(navigationController: UINavigationController)
//    func start(with deepLink: DeepLink)
//    func goToDeepLink(_ deepLink: DeepLink)
//}

public protocol SpiralDeepLinkHandler: AnyObject {
    @discardableResult func handleDeepLink(_ deepLink: SpiralDeepLink) -> Bool
}

//public struct DeepLinkListener {
//    let owner: ObjectIdentifier
//    let trigger: SpiralDeepLink
//    let action: ([String: Any]) -> Void
//}
//
//public class SpiralDeepLinkHandler: SpiralHandler<SpiralDeepLink> {
//
//    private let listener: DeepLinkListener
//
//    var owner: ObjectIdentifier {
//        return listener.owner
//    }
//
//    init(listener: DeepLinkListener) {
//        self.listener = listener
//    }
//
//    override func handle(_ handleable: SpiralDeepLink) -> SpiralDeepLink? {
//
//        if listener.trigger == handleable {
//            listener.action(handleable.params)
//            return nil
//        }
//
//        return nextHandler?.handle(handleable) ??  handleable
//    }
//}

//public class SpiralHandler<T> {
//
//    @discardableResult
//    func setNext(handler: SpiralHandler) -> SpiralHandler {
//        nextHandler = handler
//        return handler
//    }
//
//    func handle(_ handleable: T) -> T? {
//        return nextHandler?.handle(handleable)
//    }
//
//    var nextHandler: SpiralHandler?
//}

extension SpiralDeepLinkHandler {
//    @discardableResult func goToDeepLink(_ deepLink: SpiralDeepLink) -> Bool {
////        guard let mainCoordinator = firstParent(of: MainCoordinator.self) else { return }
////        mainCoordinator.goTo(deepLink: deepLink, originCoordinator: self)
//
//        return false
//    }
    
    private func isDismissLink(_ deepLink: SpiralDeepLink) -> Bool {
        return deepLink.scene == "dismiss"
    }
    
    @discardableResult func handleDeepLink(_ deepLink: SpiralDeepLink, priorityHandler: SpiralDeepLinkHandler?) -> Bool {
        guard priorityHandler?.handleDeepLink(deepLink) ?? false == false else { return true }
                    
        return handleDeepLink(deepLink)
    }
    
    func handleDeepLinks(_ deepLinks: [SpiralDeepLink], priorityHandler: SpiralDeepLinkHandler? = nil) {
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
                    self.handleDeepLinks(linksAfterDismiss)
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
        case .webview:
            showWebView(from: deepLink)
        case .actions:
            handleActionsScene(deepLink: deepLink)
        case .unknown:
            _ = ""
        }
        
        return true
    }
    
    func handleActionsScene(deepLink: SpiralDeepLink) {
        let scene = ActionsSceneType(rawValue: deepLink.scene)
        
        switch scene {
        case .showModal:
            if let modalType = deepLink.stringParamForKey("type") {
                showModal(type: modalType)
            }
        case .none:
            _ = ""
        }
    }
    
    func showModal(type: String) {
        Spiral.shared.showModalContent(type: type, success: nil, failure: nil, deepLinkHandler: self)
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
