//
// GivingCharitiesSearchRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Filter for Charity a customer can donate to. */
public struct GivingCharitiesSearchRequest: Codable, JSONEncodable, Hashable {

    /** Search query term for a Charity lookup by ID, name or EIN. */
    public var query: String

    public init(query: String) {
        self.query = query
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case query
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(query, forKey: .query)
    }
}
