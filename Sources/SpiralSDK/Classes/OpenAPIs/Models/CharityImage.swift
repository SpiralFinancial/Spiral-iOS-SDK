//
// CharityImage.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CharityImage: Codable, JSONEncodable, Hashable {

    /** Unique Charity image id */
    public var id: String?
    /** URL within Cloudinary */
    public var url: String
    /** Image type */
    public var type: String

    public init(id: String? = nil, url: String, type: String) {
        self.id = id
        self.url = url
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case url
        case type
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(type, forKey: .type)
    }
}

