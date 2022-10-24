//
// Client.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct Client: Codable, JSONEncodable, Hashable {

    /** Spiral generated unique Client ID */
    public var id: String?
    /** URL within Cloudinary */
    public var logo: String?
    /** Full fintech name */
    public var fintechName: String
    /** Shortname description of the fintech brand */
    public var brandName: String?
    public var contactUser: User?
    public var clientSettings: ClientSettings?

    public init(id: String? = nil, logo: String? = nil, fintechName: String, brandName: String? = nil, contactUser: User? = nil, clientSettings: ClientSettings? = nil) {
        self.id = id
        self.logo = logo
        self.fintechName = fintechName
        self.brandName = brandName
        self.contactUser = contactUser
        self.clientSettings = clientSettings
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case logo
        case fintechName
        case brandName
        case contactUser
        case clientSettings
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(logo, forKey: .logo)
        try container.encode(fintechName, forKey: .fintechName)
        try container.encodeIfPresent(brandName, forKey: .brandName)
        try container.encodeIfPresent(contactUser, forKey: .contactUser)
        try container.encodeIfPresent(clientSettings, forKey: .clientSettings)
    }
}

