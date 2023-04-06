//
//  SpiralGradientView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 2/2/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class SpiralGradientView: UIView {
    
    enum SpiralGradientViewDirection: String {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
        case topLeftToBottomRight
    }
    
    var gradientDirectionRaw: SpiralGradientViewDirection = .topLeftToBottomRight
    
    @IBInspectable var gradientDirection: String {
        get {
            return self.gradientDirectionRaw.rawValue
        }
        set(val) {
            self.gradientDirectionRaw = SpiralGradientViewDirection(rawValue: val) ?? .topLeftToBottomRight
        }
    }
    @IBInspectable var gradientColor1: UIColor?
    @IBInspectable var gradientColor2: UIColor?
    
    var colors: [UIColor]?
    var distribution: [NSNumber]?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var colors: [UIColor]! = colors
        if colors == nil {
            guard let gradientColor1 = gradientColor1, let gradientColor2 = gradientColor2 else {
                return
            }
            colors = [gradientColor1, gradientColor2]
        }

        layer.sublayers?.forEach { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } }
        setGradientBackground(colors: colors,
                              direction: GradientDirection(rawValue: gradientDirectionRaw.rawValue),
                              distribution: distribution)
    }
}
