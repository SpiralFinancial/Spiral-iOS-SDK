//
//  UIColor+HexToColor.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 25.05.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let red, green, blue, alpha: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            var hexColor = hex[start...]
            
            // Handles hexes without alpha
            if hexColor.count == 6 {
                hexColor.append(contentsOf: "FF")
            }
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: String(hexColor))
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    alpha = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }
        }
        
        return nil
    }
    
    public static func hexColor(_ hex: String?, fallbackColor: UIColor) -> UIColor {
        if let hex = hex,
           let color = UIColor(hex: hex) {
            return color
        } else {
            return fallbackColor
        }
    }
}
