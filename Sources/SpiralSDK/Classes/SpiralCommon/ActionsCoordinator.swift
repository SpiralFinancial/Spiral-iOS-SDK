//
//  ActionsCoordinator.swift
//  SpiralBank
//
//  Created by Ron Soffer on 3/24/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import Foundation

enum ActionsCoordinatorSceneType: String {
    case showModal
}

class ActionsCoordinator: Coordinator, DeepLinkable {
    
    let navigationController: UINavigationController
    var deepLinkHandlers: [DeepLinkHandler]?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {

    }
    
    func start(with deepLink: DeepLink) {
        let sceneType = ActionsCoordinatorSceneType(rawValue: deepLink.scene)
        
        switch sceneType {
        case .showModal:
            if let modalType = deepLink.stringParamForKey("type") {
                let scope = deepLink.stringParamForKey("scope")
                showModal(type: modalType, scope: scope)
            }
        case .none:
            _ = ""
//            handleDeepLinkNotFound()
        }
    }
    
    func showModal(type: String, scope: String?) {
//        guard !(UIApplication.topViewController() is GenericCardModalViewController) else { return }
//
//        navigationController.startLoadingIndicator(displayAfter: 0.5)
//        GetGenericContentRequest(type: type, scope: scope).execute { [weak self] result, response in
//            guard let self = self else { return }
//            self.navigationController.stopLoadingIndicator()
//
//            guard self.willShowErrorMessage(result, response: response) == false,
//                  let contentData = result?.payload,
//                  let genericContent = contentData.payload as? GenericCardPayloadModel else { return }
//
//            self.showModal(with: genericContent)
//        }
    }
    
    func showModal(with genericCard: GenericCardPayloadModel) {
        let vc = GenericCardModalViewController.create(with: genericCard, delegate: self)
        navigationController.present(vc, animated: true, completion: nil)
    }
}

extension ActionsCoordinator: GenericCardModalSceneDelegate {
    func genericCardModalSceneDidRequestDismiss() {
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
    }
}
