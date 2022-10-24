//
//  AppFont.swift
//  SpiralBank
//
//  Created by Dyanko Yovchev on 12.02.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import UIKit
import SwiftUI

struct AppFont {
    
    static func ultrathin(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Ultralight", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func thin(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Thin", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func light(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func semibold(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func heavy(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Heavy", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func black(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Black", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func signature(size: CGFloat) -> UIFont {
        return UIFont(name: "SignPainter-HouseScript", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func greycliffRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "GreycliffCF-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func greycliffBold(size: CGFloat) -> UIFont {
        return UIFont(name: "GreycliffCF-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    // swiftlint:disable cyclomatic_complexity
    static func textAttributesToFont(weight: GenericCardTextWeight, size: CGFloat) -> UIFont {
        switch weight {
        case .ultrathin: return AppFont.ultrathin(size: size)
        case .thin: return AppFont.thin(size: size)
        case .light: return AppFont.light(size: size)
        case .regular: return AppFont.regular(size: size)
        case .medium: return AppFont.medium(size: size)
        case .semibold: return AppFont.semibold(size: size)
        case .bold: return AppFont.bold(size: size)
        case .heavy: return AppFont.heavy(size: size)
        case .black: return AppFont.black(size: size)
        case .signature: return AppFont.signature(size: size)
        case .greycliffRegular: return AppFont.greycliffRegular(size: size)
        case .greycliffBold: return AppFont.greycliffBold(size: size)
        }
    }
}
