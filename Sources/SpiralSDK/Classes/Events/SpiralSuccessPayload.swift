//
//  SpiralSuccessPayload.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

public struct SpiralSuccessPayload: SpiralEventPayload {
    public init(type: String, data: [String: AnyCodable]) {
        self.type = type
        self.data = data
    }
    
    public let type: String
    public let data: [String: AnyCodable]
}
