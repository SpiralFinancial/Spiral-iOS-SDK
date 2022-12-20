//
// ClientUpdate.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ClientUpdate: Codable, JSONEncodable, Hashable {

    /** Spiral generated unique Client ID */
    public var id: String
    /** URL within Cloudinary */
    public var logo: String?
    /** Full fintech name */
    public var fintechName: String
    /** Starting timestamp of the fintech's contract. */
    public var contractStart: Double?
    /** Ending timestamp of the fintech's contract. */
    public var contractEnd: Double?
    /** Spiral-side manager assigned to this client. */
    public var manager: String?
    /** Shortname description of the fintech brand */
    public var brandName: String?
    public var contactUser: User?
    public var clientSettings: ClientSettings?
    public var products: ClientProducts

    public init(id: String, logo: String? = nil, fintechName: String, contractStart: Double? = nil, contractEnd: Double? = nil, manager: String? = nil, brandName: String? = nil, contactUser: User? = nil, clientSettings: ClientSettings? = nil, products: ClientProducts) {
        self.id = id
        self.logo = logo
        self.fintechName = fintechName
        self.contractStart = contractStart
        self.contractEnd = contractEnd
        self.manager = manager
        self.brandName = brandName
        self.contactUser = contactUser
        self.clientSettings = clientSettings
        self.products = products
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case logo
        case fintechName
        case contractStart
        case contractEnd
        case manager
        case brandName
        case contactUser
        case clientSettings
        case products
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(logo, forKey: .logo)
        try container.encode(fintechName, forKey: .fintechName)
        try container.encodeIfPresent(contractStart, forKey: .contractStart)
        try container.encodeIfPresent(contractEnd, forKey: .contractEnd)
        try container.encodeIfPresent(manager, forKey: .manager)
        try container.encodeIfPresent(brandName, forKey: .brandName)
        try container.encodeIfPresent(contactUser, forKey: .contactUser)
        try container.encodeIfPresent(clientSettings, forKey: .clientSettings)
        try container.encode(products, forKey: .products)
    }
}

