//
//  GenericCardModalViewModel.swift
//  SpiralBank
//
//  Created by Eric Collom on 3/7/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import Foundation

//public protocol SpiralGenericCardModalSceneDelegate: SpiralDeepLinkHandler {
//    func genericCardModalSceneDidRequestDismiss(controller: UIViewController)
//}

class SpiralGenericCardModalViewModel: GenericCardModalViewModelType {
    
    weak var delegate: SpiralDelegate?
    var genericCard = Observable<GenericCardDisplayModel>()
    var shouldRefreshLayout = Observable<Bool>(false)
    
    init(genericCard: SpiralGenericCardPayloadModel, delegate: SpiralDelegate) {
        self.delegate = delegate
        let displayModal = GenericCardDisplayModel(cardData: genericCard,
                                                   delegate: delegate,
                                                   layoutUpdateHandler: { [weak self] constraintUpdater in
            constraintUpdater()
            self?.shouldRefreshLayout.value = true
        })
        self.genericCard.value = displayModal
        
//        Notifications.addObserverForCardHidden(self, selector: #selector(didHideCard(notification:)))
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    func dismissModal(controller: UIViewController) {
        delegate?.genericCardModalSceneDidRequestDismiss(controller: controller)
    }
    
//    @objc func didHideCard(notification: Notification) {
//        if let (identifier, _, _) = notification.object as? (Int, String, String) {
//            if genericCard.value?.cardData.identifier == identifier {
//                dismissModal()
//            }
//        }
//    }
}
