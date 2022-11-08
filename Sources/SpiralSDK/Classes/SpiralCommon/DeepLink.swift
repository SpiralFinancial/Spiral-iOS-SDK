//
//  DeepLink.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 10/17/22.
//

import Foundation

public class DeepLink {
    
    let sceneType: SceneType
    let scene: String
    let params: [String: Any]
    
    init(sceneType: SceneType, scene: String, params: [String: Any] = [String: Any]()) {
        self.sceneType = sceneType
        self.scene = scene
        self.params = params
    }
    
    init?(from path: String) {
        
        let path = path.starts(with: "/") ? String(path.suffix(from: path.index(after: path.startIndex))) : path
        guard let url = URL(string: path) else { return nil }
        
        let components = url.pathComponents
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems
        
        var params = [String: String]()
        queryItems?.forEach({ (item) in
            params[item.name] = item.value
        })
        
        let type = SceneType(rawValue: components.first ?? .empty)
        let sceneString = components.last ?? .empty
        
        let sceneType = type ?? .actions
        
        self.sceneType = sceneType
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
    
    static func == (lhs: DeepLink, rhs: DeepLink) -> Bool {
        return lhs.sceneType == rhs.sceneType && lhs.scene == rhs.scene
    }
}

enum SceneType: String {
    case webview
    case actions
    
    var coordinatorType: DeepLinkable.Type {
        switch self {
        case .webview, .actions:
            return ActionsCoordinator.self
        }
    }
}

//public protocol DeepLinkable: Coordinator {
//    var navigationController: UINavigationController { get }
//    var deepLinkHandlers: [DeepLinkHandler]? { get set }
//    init(navigationController: UINavigationController)
//    func start(with deepLink: DeepLink)
//    func goToDeepLink(_ deepLink: DeepLink)
//}

public protocol DeepLinkable: AnyObject {
//    var navigationController: UINavigationController { get }
//    var deepLinkHandlers: [DeepLinkHandler]? { get set }
//    init(navigationController: UINavigationController)
//    func start(with deepLink: DeepLink)
    func goToDeepLink(_ deepLink: DeepLink)
}

public struct DeepLinkListener {
    let owner: ObjectIdentifier
    let trigger: DeepLink
    let action: ([String: Any]) -> Void
}

public class DeepLinkHandler: SpiralHandler<DeepLink> {
    
    private let listener: DeepLinkListener
    
    var owner: ObjectIdentifier {
        return listener.owner
    }
    
    init(listener: DeepLinkListener) {
        self.listener = listener
    }

    override func handle(_ handleable: DeepLink) -> DeepLink? {
        
        if listener.trigger == handleable {
            listener.action(handleable.params)
            return nil
        }
        
        return nextHandler?.handle(handleable) ??  handleable
    }
}

public class SpiralHandler<T> {
    
    @discardableResult
    func setNext(handler: SpiralHandler) -> SpiralHandler {
        nextHandler = handler
        return handler
    }
    
    func handle(_ handleable: T) -> T? {
        return nextHandler?.handle(handleable)
    }

    var nextHandler: SpiralHandler?
}

extension DeepLinkable {
    func goToDeepLink(_ deepLink: DeepLink) {
//        guard let mainCoordinator = firstParent(of: MainCoordinator.self) else { return }
//        mainCoordinator.goTo(deepLink: deepLink, originCoordinator: self)
    }
    
    private func isDismissLink(_ deepLink: DeepLink) -> Bool {
        return deepLink.scene == "dismiss"
    }
    
    func handleDeepLinks(_ deepLinks: [DeepLink]) {
        var links = [DeepLink]()
        var linksAfterDismiss = [DeepLink]()
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
                let deepLink: DeepLink? = $0
                if let deepLink = deepLink {
                    goToDeepLink(deepLink)
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
    
}

protocol DeepLinkRequestHandler {
    func execute(from deepLink: DeepLink)
}
