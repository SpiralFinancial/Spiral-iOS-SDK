//
// ClientGivingCategorySettings.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ClientGivingCategorySettings: Codable, JSONEncodable, Hashable {

    /** Giving category id */
    public var id: String?
    /** Giving category name */
    public var name: String?
    /** Whether this category is client scoped */
    public var clientScoped: Bool?
    /** Whether this category is enabled for client */
    public var enabled: Bool?
    /** List of sorted Charity IDs associated with this category */
    public var charities: [String]?

    public init(id: String? = nil, name: String? = nil, clientScoped: Bool? = nil, enabled: Bool? = nil, charities: [String]? = nil) {
        self.id = id
        self.name = name
        self.clientScoped = clientScoped
        self.enabled = enabled
        self.charities = charities
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case clientScoped
        case enabled
        case charities
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(clientScoped, forKey: .clientScoped)
        try container.encodeIfPresent(enabled, forKey: .enabled)
        try container.encodeIfPresent(charities, forKey: .charities)
    }
}
