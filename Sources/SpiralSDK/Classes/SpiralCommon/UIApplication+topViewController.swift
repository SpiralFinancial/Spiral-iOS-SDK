//
//  UIApplication+topViewController.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 13.05.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selectedViewController = tabController.selectedViewController {
                return topViewController(controller: selectedViewController)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}
