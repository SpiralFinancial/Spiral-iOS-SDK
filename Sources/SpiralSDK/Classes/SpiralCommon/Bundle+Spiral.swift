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
        
        return Bundle.module
    }
}

private class BundleFinder {}

extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static var module: Bundle = {
        let bundleName = "SpiralSDK"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named SpiralSDK")
    }()
}
