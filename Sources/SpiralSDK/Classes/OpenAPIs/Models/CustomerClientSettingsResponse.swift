//
// CustomerClientSettingsResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CustomerClientSettingsResponse: Codable, JSONEncodable, Hashable {

    /** Shortname description of the fintech brand */
    public var brandName: String
    /** Client logo url */
    public var logo: String?
    public var clientSettings: CustomerClientSettings
    public var products: ClientProducts

    public init(brandName: String, logo: String? = nil, clientSettings: CustomerClientSettings, products: ClientProducts) {
        self.brandName = brandName
        self.logo = logo
        self.clientSettings = clientSettings
        self.products = products
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case brandName
        case logo
        case clientSettings
        case products
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brandName, forKey: .brandName)
        try container.encodeIfPresent(logo, forKey: .logo)
        try container.encode(clientSettings, forKey: .clientSettings)
        try container.encode(products, forKey: .products)
    }
}
