//
//  SpiralCloseEvent.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/21/22.
//

import Foundation

public struct SpiralCloseEvent: SpiralEvent {
        
    public init(type: String, eventName: String, payload: SpiralEventPayload) {
        self.type = type
        self.eventName = eventName
        self.payload = payload
    }
    
    public var type: String
    public var eventName: String
    public var payload: SpiralEventPayload
}
