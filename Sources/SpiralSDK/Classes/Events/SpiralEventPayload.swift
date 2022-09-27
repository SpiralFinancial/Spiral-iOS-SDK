//
//  SpiralEventPayload.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

public protocol SpiralEventPayload: Codable {
    func jsonString() throws -> String
}

extension SpiralEventPayload {
    public func jsonString() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let payloadString: String;
        if let jsonData = try? encoder.encode(self), let encoded = String(data: jsonData, encoding: .utf8) {
            payloadString = encoded
        } else {
            payloadString = ""
        }
        return payloadString
    }
}
