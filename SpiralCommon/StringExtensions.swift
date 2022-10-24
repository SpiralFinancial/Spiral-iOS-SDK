//
//  StringExtensions.swift
//  SpiralBank
//
//  Created by Dyanko Yovchev on 13.02.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import Foundation

// swiftlint:disable file_length

extension NSAttributedString {
    
    /// Returns `NSAttributedString` from self with applied `attributes` to the last `N` number of symbols.
    func attributedStringWithFormattedLastSymbols(_ numberOfSymbols: Int = 3,
                                                  attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.applyFormattingToLastSymbols(numberOfSymbols,
                                                             attributes: attributes)
        return mutableAttributedString
    }
    
    /// Returns `NSAttributedString` from self with applied `attributes` to the first `N` number of symbols.
    func attributedStringWithFormattedFirstSymbols(_ numberOfSymbols: Int,
                                                  attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.applyFormattingToFirstSymbols(numberOfSymbols,
                                                             attributes: attributes)
        return mutableAttributedString
    }
    
    static func numberedListAttrStr(stringList: [String],
                                    bulletSymbol: String? = nil,
                                    indentation: CGFloat = 20,
                                    lineSpacing: CGFloat = 2,
                                    paragraphSpacing: CGFloat = 12) -> NSAttributedString {

        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation

        let numberedList = NSMutableAttributedString()
        for idx in 0..<stringList.count {
            let isLastLine = idx == stringList.count - 1
            let string = stringList[idx]
            let formattedString = "\(bulletSymbol ?? "\(idx + 1).")\t\(string)\(isLastLine ? "" : "\n")"
            let attributedString = NSMutableAttributedString(string: formattedString)

            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle: paragraphStyle],
                range: NSRange(location: 0, length: attributedString.length))
            numberedList.append(attributedString)
        }

        return numberedList
    }

}

extension NSMutableAttributedString {
    
    /// Mutating method, adding attributes to the last `N` symbols.
    func applyFormattingToLastSymbols(_ numberOfSymbols: Int = 3,
                                      attributes: [NSAttributedString.Key: Any]) {
        
        guard length >= numberOfSymbols else { return }
        
        let range = NSRange(location: length - numberOfSymbols, length: numberOfSymbols)
        self.addAttributes(attributes, range: range)
    }
    
    /// Mutating method, adding attributes to the first `N` symbols.
    func applyFormattingToFirstSymbols(_ numberOfSymbols: Int,
                                      attributes: [NSAttributedString.Key: Any]) {
        
        let range = NSRange(location: 0,
                            length: numberOfSymbols > length ? length : numberOfSymbols)
        self.addAttributes(attributes, range: range)
    }
    
    @discardableResult func applyLineHeight(_ lineHeight: CGFloat,
                                            alignment: NSTextAlignment? = nil,
                                            letterSpacing: CGFloat? = nil) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        
        if let textAlignment = alignment {
            paragraphStyle.alignment = textAlignment
        }

        addAttribute(.paragraphStyle,
                     value: paragraphStyle,
                     range: NSRange(location: 0, length: length))
        if let letterSpacing = letterSpacing {
            addAttribute(.kern,
                         value: letterSpacing,
                         range: NSRange(location: 0, length: length))
        }
        
        return self
    }
    
    @discardableResult func applyBoldText(boldText: String, boldFont: UIFont) -> NSMutableAttributedString {
        if let range = string.range(of: boldText) {
            let boldRange = NSRange(range, in: string)
            addAttribute(.font, value: boldFont, range: boldRange)
        }
        return self
    }
    
    @discardableResult func applyBoldText(listToBold: [String], boldFont: UIFont) -> NSMutableAttributedString {
        for string in listToBold {
            applyBoldText(boldText: string, boldFont: boldFont)
        }
        return self
    }
    
    @discardableResult func applyHighlightedText(highlightedText: String, highlightedColor: UIColor) -> NSMutableAttributedString {
        if let range = string.range(of: highlightedText) {
            let highlightedRange = NSRange(range, in: string)
            addAttribute(.foregroundColor, value: highlightedColor, range: highlightedRange)
        }
        return self
    }
    
    @discardableResult func insert(image: UIImage,
                                   at index: Int,
                                   sideLength: CGFloat = 20,
                                   leftPadding: CGFloat = 0,
                                   verticalOffset: CGFloat = 0,
                                   url: String? = nil) -> NSMutableAttributedString {
        
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -verticalOffset, width: sideLength, height: sideLength)
        
        let spacing = NSMutableAttributedString(string: "\u{200B}",
                                                    attributes: [NSAttributedString.Key.kern: leftPadding])
        let iconString = NSMutableAttributedString(attachment: attachment)
        
        spacing.append(iconString)
        
        insert(spacing, at: index)
        
        if let url = url {
            self.applyHyperlink(linkText: iconString.string,
                                url: url,
                                linkTextColor: .black,
                                showUnderline: false,
                                for: UITextView())
        }
        
        return self
    }
    
    @discardableResult func applyHyperlink(linkText: String,
                                           url: String,
                                           linkTextColor: UIColor,
                                           showUnderline: Bool,
                                           for textView: UITextView? = nil) -> NSMutableAttributedString {
        if let range = string.range(of: linkText, options: .caseInsensitive) {
            
            let linkRange = NSRange(range, in: string)
            addAttribute(.link, value: url, range: linkRange)
            addAttribute(.foregroundColor, value: linkTextColor, range: linkRange)
            
            if showUnderline {
                addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)
            }
            
            textView?.tintColor = linkTextColor
        }
        return self
    }
    
    @discardableResult func applyFontSpacing(amount: Double) -> NSMutableAttributedString {
        addAttribute(NSAttributedString.Key.kern,
                                      value: amount,
                                      range: NSRange(location: 0, length: length))
        return self
    }
    
    @discardableResult func applyBackgroundColor(backgroundColor: UIColor) -> NSMutableAttributedString {
        addAttribute(NSAttributedString.Key.backgroundColor,
                                      value: backgroundColor,
                                      range: NSRange(location: 0, length: length))
        return self
    }
    
    convenience init?(html: String) {
        guard let data = html.data(using: .unicode) else {
            return nil
        }
        try? self.init(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
    }
    
    /// Replaces the base font (typically Times) with the given font, while preserving traits like bold and italic
    func setBaseFont(baseFont: UIFont) {
        let baseDescriptor = baseFont.fontDescriptor
        let wholeRange = NSRange(location: 0, length: length)
        beginEditing()
        enumerateAttribute(.font, in: wholeRange, options: []) { object, range, _ in
            guard let font = object as? UIFont else { return }
            // Instantiate a font with our base font's family, but with the current range's traits
            let traits = font.fontDescriptor.symbolicTraits
            guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else { return }
            let newSize = font.pointSize
            let newFont = UIFont(descriptor: descriptor, size: newSize)
            self.removeAttribute(.font, range: range)
            self.addAttribute(.font, value: newFont, range: range)
        }
        endEditing()
    }
}

extension String {
    
    /// Sets spacing between letters according to the value given
     func spacedOutTextBy(value: Double) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: value,
                                      range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    func mutableAttributedString(font: UIFont,
                                 textColor: UIColor = .black,
                                 alignment: NSTextAlignment?,
                                 lineHeight: CGFloat? = nil,
                                 letterSpacing: CGFloat? = nil) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: self,
                                                         attributes: [.font: font, .foregroundColor: textColor])
        
        if let alignment = alignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            
            if let lineHeight = lineHeight {
                paragraphStyle.maximumLineHeight = lineHeight
                paragraphStyle.minimumLineHeight = lineHeight
            }
            
            if let letterSpacing = letterSpacing {
                let range = NSRange(location: 0, length: attributedString.length)
                attributedString.addAttribute(.kern,
                                              value: letterSpacing,
                                              range: range)
            }

            attributedString.addAttribute(.paragraphStyle,
                              value: paragraphStyle,
                              range: NSRange(location: 0, length: attributedString.length))
        }
        
        return attributedString
    }
    
    func attributedString(withLineHeightOf lineHeight: CGFloat,
                          alignment: NSTextAlignment? = nil,
                          letterSpacing: CGFloat? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.applyLineHeight(lineHeight,
                                         alignment: alignment,
                                         letterSpacing: letterSpacing)
        return attributedString
    }
    
    // swiftlint:disable function_parameter_count
    func attributedStringWithHyperlink(for linkText: String,
                                       url: String,
                                       defaultTextColor: UIColor,
                                       linkTextColor: UIColor,
                                       lineHeight: CGFloat = 0,
                                       alignment: NSTextAlignment? = nil,
                                       showUnderline: Bool,
                                       textView: UITextView) -> NSMutableAttributedString? {
        let range = NSRange(location: 0, length: self.count)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.foregroundColor, value: defaultTextColor, range: range)
        attributedString.applyHyperlink(linkText: linkText, url: url, linkTextColor: linkTextColor, showUnderline: showUnderline, for: textView)
        
        if lineHeight > 0 {
            attributedString.applyLineHeight(lineHeight, alignment: alignment)
        } else if let alignment = alignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }
        
        return attributedString
    }
    
    func attributedStringWithBoldText(boldText: String, defaultFont: UIFont, boldFont: UIFont) -> NSAttributedString? {
        if let range = self.range(of: boldText) {
            let boldRange = NSRange(range, in: self)
            let attributedString = NSMutableAttributedString(string: self)
            attributedString.addAttribute(.font, value: defaultFont, range: NSRange(location: 0, length: self.count))
            attributedString.addAttribute(.font, value: boldFont, range: boldRange)
            return attributedString
        }
        
        return nil
    }
    
    func highlight(with color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        let range = (self as NSString).range(of: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        return attributedString
    }
    
    func highlight(with color: UIColor, _ targets: String...) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        targets.forEach {
            let range = (self as NSString).range(of: $0)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        
        return attributedString
    }
    
    func didHighlightIfNeeded(markers: (prefix: String, suffix: String)?,
                              highlightColors: (highlightedTextColor: UIColor, highlightedBackgroundColor: UIColor),
                              defaultColor: UIColor) -> NSMutableAttributedString {
        
        guard let markers = markers else {
            return NSMutableAttributedString(string: self, attributes: [.foregroundColor: defaultColor] )
        }
        
        let pattern = "\(markers.prefix)((?!\(markers.prefix)).*?)\(markers.suffix)"
        
        guard let matches = findMatches(with: pattern), !matches.isEmpty else { return NSMutableAttributedString(string: self, attributes: [.foregroundColor: defaultColor] ) }
        var text = replacingOccurrences(of: markers.prefix, with: "")
        text = text.replacingOccurrences(of: markers.suffix, with: "")
        
        let attributeTxt = NSMutableAttributedString(string: text, attributes: [.foregroundColor: defaultColor])
        let initialLength = attributeTxt.string.count
        matches.map { $0.lowercased()
            .replacingOccurrences(of: markers.prefix, with: "")
            .replacingOccurrences(of: markers.suffix, with: "")
        }.forEach { match in
                var range = NSRange(location: 0, length: attributeTxt.length)
                while range.location != NSNotFound {
                    range = attributeTxt.mutableString.range(of: match, options: .caseInsensitive, range: range)
                    if range.location != NSNotFound {
                        attributeTxt.setAttributes([
                            .backgroundColor: highlightColors.highlightedBackgroundColor,
                            .foregroundColor: highlightColors.highlightedTextColor
                        ], range: range)
                        range = NSRange(location: range.location + range.length, length: initialLength - (range.location + range.length))
                    }
                }
        }
        
        return attributeTxt
    }
    
    func findMatches(with regex: String) -> [String]? {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(startIndex..., in: self))
            return results.compactMap {
                guard let range = Range($0.range, in: self) else { return nil }
                return String(self[range])
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return nil
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont, lineHeight: CGFloat? = nil) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
        if let lineHeight = lineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
            attributes[.paragraphStyle] = paragraphStyle
        }
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont, lineHeight: CGFloat? = nil) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
        if let lineHeight = lineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
            attributes[.paragraphStyle] = paragraphStyle
        }
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return ceil(boundingBox.width)
    }
    
    var withoutPunctuation: String {
        let punctuationSet = CharacterSet(charactersIn: ".,").union(CharacterSet.punctuationCharacters)
        return components(separatedBy: punctuationSet).joined()
    }
    
    var withoutWhiteSpace: String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    func attributedStringWithListFormatting(font: UIFont = AppFont.light(size: 15),
                                            textColor: UIColor = .charcoalGrey,
                                            bulletSymbol: String? = nil,
                                            alignment: NSTextAlignment = .left,
                                            lineHeight: CGFloat? = nil) -> NSAttributedString {
        var textWithoutBullets = self
        var bullets = [String]()
        
        self.enumerateLines { (line, _) in
            if line.starts(with: "<li>") {
                textWithoutBullets = textWithoutBullets.replacingOccurrences(of: line, with: "")
                let cleanLine = line.replacingOccurrences(of: "<li>", with: "").replacingOccurrences(of: "</li>", with: "")
                bullets.append(cleanLine.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        textWithoutBullets = textWithoutBullets.trimmingCharacters(in: .whitespacesAndNewlines)
        if !bullets.isEmpty {
            textWithoutBullets += "\n\n"
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributedString = NSMutableAttributedString(string: textWithoutBullets,
                                                         attributes: [.paragraphStyle: paragraphStyle])
        
        if let lineHeight = lineHeight {
            attributedString.applyLineHeight(lineHeight, alignment: alignment, letterSpacing: nil)
        }
        
        let numberedString = NSAttributedString.numberedListAttrStr(stringList: bullets, bulletSymbol: bulletSymbol)
        
        attributedString.append(numberedString)
        
        attributedString.addAttributes([NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: textColor],
                                       range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var truncatedForAnalytics: String {
        return shortenTo(length: 254)
    }
    
    func shortenTo(length: Int) -> String {
        return String(prefix(length))
    }
    
    func formattedPhoneForStr() -> String {
        var phone = self
                
        let nonAlpha = CharacterSet.alphanumerics.inverted
        phone = phone.components(separatedBy: nonAlpha).joined(separator: "")
        
        phone = String(phone.prefix(10))
        
        let currentPhoneLength = phone.count
        
        if currentPhoneLength > 0 {
            phone.insert(contentsOf: "(", at: phone.index(phone.startIndex, offsetBy: 0))
        }
        if currentPhoneLength > 2 {
            phone.insert(contentsOf: ") ", at: phone.index(phone.startIndex, offsetBy: 4))
        }
        if currentPhoneLength > 6 {
            phone.insert(contentsOf: "-", at: phone.index(phone.startIndex, offsetBy: 9))
        }
        
        return phone
    }
    
    // Converts an aspect ratio string with format "16:9" to
    // a float value representing the height multiplier relative to width
    // (i.e 2:1 returns 0.5)
    var toHeightAspectRatio: CGFloat? {
        let values = split(separator: ":")
        if let widthSlice = values[safeAt: 0],
           let heightSlice = values[safeAt: 1] {
            let widthStr = String(widthSlice).trimmed
            let heightStr = String(heightSlice).trimmed
            
            if let widthVal = widthStr.asCGFloat,
               let heightVal = heightStr.asCGFloat {
                return (heightVal / widthVal)
            }
        }
        return nil
    }
    
    var asCGFloat: CGFloat? {
        if let num = NumberFormatter().number(from: self) {
            let floatVal = CGFloat(truncating: num)
            return floatVal
        }
        return nil
    }
    
    func spiralSafeUrl() -> String {
        if hasPrefix("http") {
            return self
        }

        let apiURL = Spiral.shared.config()?.url ?? .empty
        let newURL = apiURL + self
        return newURL
    }
    
    static var empty: Self {
        return ""
    }
    
}

extension Optional where Wrapped == String {
    var orEmpty: String {
        return self ?? .empty
    }
}
