//
//  NotificationsService.swift
//  SpiralBank
//
//  Created by Eric Collom on 1/26/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import Foundation

class Notifications {
    
    class func addObserverForCardHidden(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: Notification.Name.hideCard,
                                               object: nil)
    }
    
    class func notifyObserverForCardHidden(identifier: Int, type: String, option: String) {
        NotificationCenter.default.post(name: .hideCard, object: (identifier, type, option))
    }
    
}

extension Notification.Name {
    static let hideCard = Notification.Name(rawValue: "hideCard")
}
