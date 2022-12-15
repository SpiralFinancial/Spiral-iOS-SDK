//
//  GenericCardTextView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 7/29/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

class GenericCardTextView: GenericCardComponentView {
    
    @IBOutlet private weak var textView: NoPaddingTextView! {
        didSet {
            textView.linkTextAttributes = [.foregroundColor: UIColor.black]
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    override func configureWith(_ data: GenericCardComponentDisplayModel) {
        super.configureWith(data)
        
        guard let textComponentData = data.componentModel.content as? SpiralGenericCardTextComponent else { return }
        
        if let html = textComponentData.html {
            let fontWrappedHtml = wrapWithHTMLFontStyles(html: html)
            let attributedString = NSMutableAttributedString(html: fontWrappedHtml)
            textView.attributedText = attributedString
        } else {
            if let text = textComponentData.text {
                textView.text = text
            }
            if let textColorHex = textComponentData.textColor,
               let textColor = UIColor(hexString: textColorHex) {
                textView.textColor = textColor
            }
            
            let textSize = textComponentData.textSize ?? Constants.defaultTextSize
            let textWeight = textComponentData.textWeight ?? .medium
            
            let textFont = AppFont.textAttributesToFont(weight: textWeight, size: textSize)
            
            textView.font = textFont
            
            if let lineHeight = textComponentData.lineHeight {
                let attributedString = textView.text.mutableAttributedString(font: textFont,
                                                                             textColor: textView.textColor ?? .black,
                                                                             alignment: textView.textAlignment)
                attributedString.applyLineHeight(lineHeight, alignment: textView.textAlignment)
                textView.attributedText = attributedString
            }
        }
        
        if let alignment = textComponentData.alignment {
            switch alignment {
            case .left: textView.textAlignment = .left
            case .right: textView.textAlignment = .right
            case .center: textView.textAlignment = .center
            case .justified: textView.textAlignment = .justified
            }
        }
        
        // When added to a stack view, subviews don't get the correct width until
        // after the text has been set. We need this width for proper height calculation.
        if let superview = superview as? UIStackView, superview.axis == .horizontal {
            superview.layoutSubviews()
        }
        
        if componentModel?.fixedHeight == nil {
            self.heightConstraint.isActive = true
            self.heightConstraint.constant = self.heightForWidth(self.frame.size.width)
        }
    }

    func heightForWidth(_ width: CGFloat) -> CGFloat {
        let leftPadding: CGFloat = leftPaddingConstraint.constant
        let rightPadding: CGFloat = rightPaddingConstraint.constant
        let totalWidth = width - (leftPadding + rightPadding)
        let size = textView.sizeThatFits(CGSize(width: totalWidth, height: CGFloat.greatestFiniteMagnitude))
        return size.height
    }
    
    func wrapWithHTMLFontStyles(html: String) -> String {
        var wrappedHtml = html
        if !wrappedHtml.hasPrefix("<html>") {

            // Register available fonts
            SpiralCustomFonts.registerFontsIfNeeded()
            
            var prefixHtml = "<html><style>"
            UIFont.familyNames.forEach({ familyName in
                let fontNames = UIFont.fontNames(forFamilyName: familyName)
                fontNames.forEach { fontName in
                    prefixHtml.append("""
                    @font-face {
                        font-family: \(fontName);
                        font-style: normal;
                        font-weight: 300;
                        src: local("\(fontName)");
                    }
                    """)
                }
            })
            prefixHtml.append("</style>")
            
            wrappedHtml.insert(contentsOf: prefixHtml, at: wrappedHtml.startIndex)
        }
        if !wrappedHtml.hasSuffix("</html>") {
            wrappedHtml.append("</html>")
        }
        return wrappedHtml
    }
}

// MARK: - UITextViewDelegate
extension GenericCardTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        
        guard let delegate = componentDisplayData?.delegate else { return false }
        
        handleTextTapped(fullText: textView.text,
                         characterRange: characterRange,
                         url: URL,
                         delegate: delegate)
        
        return false
    }
    
}

extension Constants {
    static let defaultTextSize: CGFloat = 20
}

extension UITextViewDelegate {
    
    // swiftlint:disable function_parameter_count
    func handleTextTapped(fullText: String,
                          characterRange: NSRange,
                          url: URL,
                          delegate: SpiralDelegate) {
        let urlString = url.urlStringWithoutLocalScheme
        
        if urlString.isValidURL {
            if urlString.starts(with: "mailto:") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
//                let deepLink = SpiralDeepLink(sceneType: .webview, scene: .empty, params: ["page": urlString])
                guard let deepLink = SpiralDeepLink(from: "/webview?page=" + urlString) else { return }
//                deepLinker.goToDeepLink(deepLink)
                SpiralDefaultDeepLinkHandler.shared.handleDeepLink(deepLink,
                                                                   priorityHandler: delegate)
            }
        } else if let deepLink = SpiralDeepLink(from: urlString) {
//            deepLinker.goToDeepLink(deepLink)
            SpiralDefaultDeepLinkHandler.shared.handleDeepLink(deepLink,
                                                               priorityHandler: delegate)
        }
        
    }
    
}
