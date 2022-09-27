//
//  SpiralSuccessEvent.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

public struct SpiralSuccessEvent: Codable {
    public init(type: String, eventName: String, payload: SpiralSuccessPayload) {
        self.type = type
        self.eventName = eventName
        self.payload = payload
    }
    
    public var type: String
    public var eventName: String
    public var payload: SpiralSuccessPayload
}
