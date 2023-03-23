//
// GivingCharityCategory.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct GivingCharityCategory: Codable, JSONEncodable, Hashable {

    /** Unique ID of the charity category. */
    public var id: String?
    /** Name of the charity category. */
    public var name: String
    /** Background image. */
    public var backgroundImageUrl: String?
    /** List of Giving Charities belonging to this category */
    public var charities: [GivingCharity]?
    /** Whether this category is client scoped */
    public var clientScoped: Bool?

    public init(id: String? = nil, name: String, backgroundImageUrl: String? = nil, charities: [GivingCharity]? = nil, clientScoped: Bool? = nil) {
        self.id = id
        self.name = name
        self.backgroundImageUrl = backgroundImageUrl
        self.charities = charities
        self.clientScoped = clientScoped
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case backgroundImageUrl
        case charities
        case clientScoped
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(backgroundImageUrl, forKey: .backgroundImageUrl)
        try container.encodeIfPresent(charities, forKey: .charities)
        try container.encodeIfPresent(clientScoped, forKey: .clientScoped)
    }
}

