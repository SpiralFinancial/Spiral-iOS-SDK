//
//  SpiralCustomFonts.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 10/26/22.
//

import Foundation

import CoreText

public class SpiralCustomFonts: NSObject {

    public enum Style: CaseIterable {
        case semibold
        case regular
        case black
        case light
        case thin
        case medium
        case ultralight
        case heavy
        case bold
        
        public var value: String {
            switch self {
            case .semibold: return "SF-Pro-Rounded-Semibold"
            case .regular: return "SF-Pro-Rounded-Regular"
            case .black: return "SF-Pro-Rounded-Black"
            case .light: return "SF-Pro-Rounded-Light"
            case .thin: return "SF-Pro-Rounded-Thin"
            case .medium: return "SF-Pro-Rounded-Medium"
            case .ultralight: return "SF-Pro-Rounded-Ultralight"
            case .heavy: return "SF-Pro-Rounded-Heavy"
            case .bold: return "SF-Pro-Rounded-Bold"
            }
        }
        public var font: UIFont {
            return UIFont(name: self.value, size: 14) ?? UIFont.init()
        }
    }

    static var didRegisterFonts = false
    public static func registerFontsIfNeeded() {
        guard !didRegisterFonts else { return }
        
        let fontNames = Style.allCases.map { $0.value }
        for fontName in fontNames {
            loadFont(withName: fontName)
        }
        
        didRegisterFonts = true
    }
    
    private static func loadFont(withName fontName: String) {
        guard
            let bundleURL = Bundle(for: self).url(forResource: "Resources", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL),
            let fontURL = bundle.url(forResource: fontName, withExtension: "otf"),
            let fontData = try? Data(contentsOf: fontURL) as CFData,
            let provider = CGDataProvider(data: fontData),
            let font = CGFont(provider) else {
            return
        }
        CTFontManagerRegisterGraphicsFont(font, nil)
    }
    
}
