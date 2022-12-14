//
//  UIView+InspectableLayer.swift
//
//  Created by Martin Vasilev on 2.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import UIKit

extension UIView {
    // swiftlint:disable implicit_getter superfluous_disable_command valid_ibinspectable
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
}
