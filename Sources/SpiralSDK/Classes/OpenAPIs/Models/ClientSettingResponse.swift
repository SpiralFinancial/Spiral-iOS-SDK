//
// ClientSettingResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ClientSettingResponse: Codable, JSONEncodable, Hashable {

    public var setting: [String: SettingValue]

    public init(setting: [String: SettingValue]) {
        self.setting = setting
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case setting
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(setting, forKey: .setting)
    }
}

