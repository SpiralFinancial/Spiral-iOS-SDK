//
//  Bundle+Spiral.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 11/1/22.
//

import Foundation

extension Bundle {
    static var spiralResourcesBundle: Bundle? {
        guard let bundleURL = Bundle(for: Spiral.self).url(forResource: "Resources", withExtension: "bundle"),
              let bundle = Bundle(url: bundleURL) else { return nil }
        
        return bundle
    }
}
