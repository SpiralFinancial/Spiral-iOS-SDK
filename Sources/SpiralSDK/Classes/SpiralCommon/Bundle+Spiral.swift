//
//  Bundle+Spiral.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 11/1/22.
//

import Foundation

extension Bundle {
    static var spiralResourcesBundle: Bundle? {
        if let bundleURL = Bundle(for: Spiral.self).url(forResource: "Resources", withExtension: "bundle"),
           let bundle = Bundle(url: bundleURL) {
            return bundle
        }
        
        return Bundle(for: self)
    }
}
