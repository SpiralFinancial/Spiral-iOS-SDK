//
//  GenericCardModalViewModel.swift
//  SpiralBank
//
//  Created by Eric Collom on 3/7/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import Foundation

public protocol SpiralGenericCardModalSceneDelegate: DeepLinkable {
    func genericCardModalSceneDidRequestDismiss()
}

class SpiralGenericCardModalViewModel: GenericCardModalViewModelType {
    
    weak var delegate: SpiralGenericCardModalSceneDelegate?
    var genericCard = Observable<GenericCardDisplayModel>()
    var shouldRefreshLayout = Observable<Bool>(false)
    
    init(genericCard: SpiralGenericCardPayloadModel, delegate: SpiralGenericCardModalSceneDelegate) {
        self.delegate = delegate
        let displayModal = GenericCardDisplayModel(cardData: genericCard,
                                                   deepLinker: delegate,
                                                   layoutUpdateHandler: { [weak self] constraintUpdater in
            constraintUpdater()
            self?.shouldRefreshLayout.value = true
        })
        self.genericCard.value = displayModal
        
        Notifications.addObserverForCardHidden(self, selector: #selector(didHideCard(notification:)))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func dismissModal() {
        delegate?.genericCardModalSceneDidRequestDismiss()
    }
    
    @objc func didHideCard(notification: Notification) {
        if let (identifier, _, _) = notification.object as? (Int, String, String) {
            if genericCard.value?.cardData.identifier == identifier {
                dismissModal()
            }
        }
    }
}
