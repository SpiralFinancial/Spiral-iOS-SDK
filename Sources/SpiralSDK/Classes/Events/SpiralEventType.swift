//
//  SpiralEvent.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

public enum SpiralEventType: String, Codable {
    case open
    case close
    case initialized
    case exit
    case success
    case error
}

public protocol SpiralEvent: Codable {
    var type: String { get }
    var eventName: String { get }
    var payload: SpiralEventPayload { get }
    
    func toAnalyticsEvent(flow: SpiralFlow) -> SpiralAnalyticsEvent
    
    init(type: String, eventName: String, payload: SpiralEventPayload)
}

private enum SpiralEventKeys: String, CodingKey {
    case type
    case eventName
    case payload
}

public extension SpiralEvent {
    
    func toAnalyticsEvent(flow: SpiralFlow) -> SpiralAnalyticsEvent {
        let date = Date()
        
        var properties = payload.asCodableDictionary()
        properties["flow"] = AnyCodable(flow)
        properties["platform"] = AnyCodable("ios")
        
        let event = SpiralAnalyticsEvent(id: UUID().uuidString,
                                         event: "flow_" + eventName,
                                         properties: properties,
                                         date: date)
        return event
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SpiralEventKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(eventName, forKey: .eventName)
        try container.encode(payload, forKey: .payload)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: SpiralEventKeys.self)
        let type = try values.decode(String.self, forKey: .type)
        let eventName = try values.decode(String.self, forKey: .eventName)
        
        let payload: SpiralEventPayload
        
        let eventType = SpiralEventType(rawValue: eventName)
        switch eventType {
        case .close: payload = try values.decode(SpiralClosePayload.self, forKey: .payload)
        case .error: payload = try values.decode(SpiralError.self, forKey: .payload)
        case .exit: payload = try values.decode(SpiralExitPayload.self, forKey: .payload)
        case .initialized: payload = try values.decode(SpiralInitPayload.self, forKey: .payload)
        case .open: payload = try values.decode(SpiralOpenPayload.self, forKey: .payload)
        case .success: payload = try values.decode(SpiralSuccessPayload.self, forKey: .payload)
        default: payload = SpiralError(type: "unknown_event", code: "unknown_event", message: "unknown_event")
        }
                
        self.init(type: type, eventName: eventName, payload: payload)
    }
}
