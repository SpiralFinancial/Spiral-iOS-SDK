//
// CstOperationProcessRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CstOperationProcessRequest: Codable, JSONEncodable, Hashable {

    /** Client IDs to process */
    public var clientIds: [String]
    /** The search start timestamp. */
    public var from: Double?
    /** The search end timestamp. */
    public var to: Double?
    /** Search query; filters client names. */
    public var query: String?
    /** List of products to include. Defaults to all products. */
    public var products: [Product]?

    public init(clientIds: [String], from: Double? = nil, to: Double? = nil, query: String? = nil, products: [Product]? = nil) {
        self.clientIds = clientIds
        self.from = from
        self.to = to
        self.query = query
        self.products = products
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case clientIds
        case from
        case to
        case query
        case products
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(clientIds, forKey: .clientIds)
        try container.encodeIfPresent(from, forKey: .from)
        try container.encodeIfPresent(to, forKey: .to)
        try container.encodeIfPresent(query, forKey: .query)
        try container.encodeIfPresent(products, forKey: .products)
    }
}

