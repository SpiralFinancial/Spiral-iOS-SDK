//
//  SpiralInitEvent.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/21/22.
//

import Foundation

public struct SpiralInitEvent: Codable {
    public init(type: String, eventName: String, payload: SpiralInitPayload?) {
        self.type = type
        self.eventName = eventName
        self.payload = payload
    }
    
    public let type: String
    public let eventName: String
    public let payload: SpiralInitPayload?
}
