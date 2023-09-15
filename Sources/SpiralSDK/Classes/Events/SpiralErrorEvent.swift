//
//  SpiralErrorEvent.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

public struct SpiralErrorEvent: SpiralEvent {
    
    public init(type: String, eventName: String, payload: SpiralEventPayload) {
        self.type = type
        self.eventName = eventName
        self.payload = payload
    }
    
    public let type: String
    public let eventName: String
    public let payload: SpiralEventPayload
    
    var error: SpiralError? { return payload as? SpiralError }
}
