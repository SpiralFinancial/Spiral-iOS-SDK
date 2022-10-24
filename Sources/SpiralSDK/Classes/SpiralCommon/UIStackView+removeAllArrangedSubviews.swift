//
//  UIStackView+removeAllArrangedSubviews.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 29.09.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (sum, next) -> [UIView] in
            removeArrangedSubview(next)
            return sum + [next]
        }
        
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach { $0.removeFromSuperview() }
    }
}
