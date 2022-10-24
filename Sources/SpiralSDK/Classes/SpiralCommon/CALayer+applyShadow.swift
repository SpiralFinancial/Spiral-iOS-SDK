//
//  CALayer+applyShadow.swift
//  SpiralBank
//
//  Created by Dyanko Yovchev on 12.02.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import UIKit

extension CALayer {
    func apply(shadow: Constants.Styles.Shadow) {
        shadowColor = shadow.shadowColor
        shadowOffset = shadow.shadowOffset
        shadowRadius = shadow.shadowRadius
        shadowOpacity = shadow.shadowOpacity
    }
    
    func apply(border: Constants.Styles.Border) {
        borderColor = border.borderColor
        borderWidth = border.borderWidth
    }
}
