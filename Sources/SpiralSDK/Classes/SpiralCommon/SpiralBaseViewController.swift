//
//  BaseViewController.swift
//
//  Created by Martin Vasilev on 1.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import UIKit

public class SpiralBaseViewController: UIViewController {
    
    var name: String {
        return String(describing: classForCoder)
    }
        
    public var showsNavigationBar: Bool {
        return true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNavigationBarHidden(!showsNavigationBar, animated: false)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // register for keyboard notifications
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    /// Called on receiving system notification `keyboardWillShowNotification`.
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillShowWithHeight(keyboardSize.height)
        }
    }
    
    /// Called on receiving system notification `keyboardWillShowNotification` with calculated keyboard height.
    /// - Parameter height: `CGFloat` height of the keyboard to be shown.
    @objc func keyboardWillShowWithHeight(_ height: CGFloat) {
    }
    
    /// Called on receiving system notification `keyboardWillHideNotification`.
    @objc func keyboardWillHide(notification: Notification) {
    }
    
    /// Override for specific cases
    @objc func handleDidEnterBackground() {}
    
    /// Override for specific cases
    @objc func handleWillEnterForeground() {}
    
}
