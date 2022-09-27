//
//  SpiralOpenEvent.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

public struct SpiralOpenEvent: Codable {
    public init(type: String, eventName: String, payload: SpiralOpenPayload) {
        self.type = type
        self.eventName = eventName
        self.payload = payload
    }
    
    public var type: String
    public var eventName: String
    public var payload: SpiralOpenPayload
}
