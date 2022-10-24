//
//  SpiralBlurEffectView.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 29.01.21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import UIKit

class SpiralBlurEffectView: UIVisualEffectView {
    
    private var style: UIBlurEffect.Style = .extraLight
    private var intensity: CGFloat = 0.1
    var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
    var shouldAnimate: Bool = true
    
    init(style: UIBlurEffect.Style, intensity: CGFloat) {
        super.init(effect: nil)
        self.style = style
        self.intensity = intensity
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMoveToSuperview() {
        guard let superview = superview else { return }
        backgroundColor = .clear
        frame = superview.bounds
        setupBlurEffect()
    }
    
    private func setupBlurEffect() {
        if shouldAnimate {
            
            animator.stopAnimation(true)
            effect = nil
            
            animator.addAnimations { [weak self] in
                guard let self = self else { return }
                self.effect = UIBlurEffect(style: self.style)
            }
            animator.fractionComplete = intensity
        } else {
            self.effect = UIBlurEffect(style: self.style)
        }
    }
    
    deinit {
        animator.stopAnimation(true)
    }
}
