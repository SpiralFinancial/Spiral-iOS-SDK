//
//  SpiralError.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

public struct SpiralError: SpiralEventPayload {
    public init(type: String, code: String, message: String) {
        self.type = type
        self.code = code
        self.message = message
    }
    
    public let type: String
    public let code: String
    public let message: String
}

public enum SpiralErrorType: String {
    case failedToStartFlow
}
