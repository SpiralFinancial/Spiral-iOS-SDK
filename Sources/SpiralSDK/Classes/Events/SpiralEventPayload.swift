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

extension Encodable {
    
    func asCodableDictionary() -> [String: AnyCodable] {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try? JSONDecoder().decode([String: AnyCodable].self, from: data) else {
                return [:]
            }
            return dictionary
        } catch {
            print("Spiral Encodable asDictionary: \(error)")
            return [:]
        }
    }
    
}
