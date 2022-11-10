//
//  SpiralGradientView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 2/2/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import Foundation

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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let gradientColor1 = gradientColor1, let gradientColor2 = gradientColor2 else {
            return
        }

        layer.sublayers?.forEach { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } }
        setGradientBackground(colors: [gradientColor1, gradientColor2],
                              direction: GradientDirection(rawValue: gradientDirectionRaw.rawValue),
                              distribution: nil)
    }
}
