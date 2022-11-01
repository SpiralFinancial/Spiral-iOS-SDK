//
//  GenericCardButtonView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 7/28/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

class GenericCardButtonView: GenericCardComponentView {
    
    @IBOutlet private weak var button: UIButton!
    
    @IBOutlet private var buttonLeftConstraint: NSLayoutConstraint!
    @IBOutlet private var buttonRightConstraint: NSLayoutConstraint!
    
    private var deepLinkHandler: (() -> Void)?
        
    override func configureWith(_ data: GenericCardComponentDisplayModel) {
        super.configureWith(data)
        
        guard let buttonComponentData = data.componentModel.content as? SpiralGenericCardButtonComponent else { return }
        
        button.borderColor = .black
        button.borderWidth = borderWidth
        button.setTitleColor(.black, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.cornerRadius = button.frame.height / 2
        button.titleLabel?.font = AppFont.medium(size: 14)
        
        if let borderColorHex = buttonComponentData.borderColor,
           let borderColor = UIColor(hexString: borderColorHex) {
            button.borderColor = borderColor
        }
        
        button.setTitle(buttonComponentData.text, for: .normal)
        
        if let textColorHex = buttonComponentData.textColor,
           let textColor = UIColor(hexString: textColorHex) {
            button.setTitleColor(textColor, for: .normal)
        }
        
        let textSize = buttonComponentData.textSize ?? Constants.defaultGenericButtonTextSize
        let textWeight = buttonComponentData.textWeight ?? .medium
        
        let textFont = AppFont.textAttributesToFont(weight: textWeight, size: textSize)
        
        button.titleLabel?.font = textFont
    }
    
    override func applyFixedDimensions() {
        
        guard let buttonComponentData = componentModel?.content as? SpiralGenericCardButtonComponent else { return }
        
        if let fixedWidth = buttonComponentData.fixedWidth {
            widthConstraint.constant = fixedWidth
            widthConstraint.isActive = true
        } else if let fixedWidth = componentModel?.fixedWidth {
            widthConstraint.constant = fixedWidth
            widthConstraint.isActive = true
        } else {
            widthConstraint.isActive = false
        }

        if let fixedHeight = buttonComponentData.fixedHeight {
            heightConstraint.constant = fixedHeight
        } else if let fixedHeight = componentModel?.fixedHeight {
            heightConstraint.constant = fixedHeight
        } else {
            heightConstraint.constant = Constants.defaultGenericButtonHeight
        }
        
    }
    
    override func applyPadding() {
        var requiresSideConstraints = false
        
        if let padding = componentModel?.padding {
            leftPaddingConstraint.constant = padding.left
            rightPaddingConstraint.constant = padding.right
            topPaddingConstraint.constant = padding.top
            bottomPaddingConstraint.constant = padding.bottom
            
            if padding.left > 0 || padding.right > 0 {
                requiresSideConstraints = true
            }
        }
        
        buttonLeftConstraint.isActive = !widthConstraint.isActive || requiresSideConstraints
        buttonRightConstraint.isActive = !widthConstraint.isActive || requiresSideConstraints
    }
    
    override func addDeepLinkHandler() {
        deepLinkHandler = { [weak self] in
            guard let deepLinks = self?.deepLinks else { return }
            self?.componentDisplayData?.deepLinker?.handleDeepLinks(deepLinks)
        }
    }
    
    override func setBackgroundColor(colorHex: String?) {
        if let bgColorHex = colorHex,
           let backgroundColorVal = UIColor(hexString: bgColorHex) {
            button.backgroundColor = backgroundColorVal
        } else {
            button.backgroundColor = .white
        }
    }
    
    @IBAction func buttonTapped() {
        deepLinkHandler?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.cornerRadius = button.frame.size.height / 2
    }
}

fileprivate extension Constants {
    static let defaultGenericButtonTextSize: CGFloat = 14
    static let defaultGenericButtonHeight: CGFloat = 40
}
