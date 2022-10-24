//
//  URL+Extra.swift
//  SpiralBank
//
//  Created by Ron Soffer on 6/7/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

extension URL {
    
    var deeplinkCleanString: String {
        var urlString = absoluteString
        urlString = urlString.replacingOccurrences(of: "http://", with: "")
        urlString = urlString.replacingOccurrences(of: "https://", with: "")
        urlString = urlString.replacingOccurrences(of: host ?? .empty, with: "")
        
        return urlString
    }
    
    var urlStringWithoutLocalScheme: String {
        var urlString = absoluteString
        if urlString.hasPrefix("applewebdata") {
            urlString = urlString.replacingOccurrences(of: "^(?:applewebdata://[0-9A-Z-]*/?)",
                                                       with: "",
                                                       options: .regularExpression,
                                                       range: nil)
        }
        return urlString
    }
}
