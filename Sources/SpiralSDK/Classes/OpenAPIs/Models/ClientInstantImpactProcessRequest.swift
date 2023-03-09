//
// ClientInstantImpactProcessRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ClientInstantImpactProcessRequest: Codable, JSONEncodable, Hashable {

    public var action: OperationsCenterAction
    /** The search start timestamp. */
    public var from: Double?
    /** The search end timestamp. */
    public var to: Double?
    /** Search query; filters transaction descriptions in a case-insensitive way. */
    public var search: String?
    /** A list of reward units to include in the search. Defaults to all units if not provided. */
    public var rewardUnits: [String]?
    /** List of II transaction IDs to process. Optional, but if provided will overwrite the supplied filters and only process these donation IDs. */
    public var transactions: [String]?

    public init(action: OperationsCenterAction, from: Double? = nil, to: Double? = nil, search: String? = nil, rewardUnits: [String]? = nil, transactions: [String]? = nil) {
        self.action = action
        self.from = from
        self.to = to
        self.search = search
        self.rewardUnits = rewardUnits
        self.transactions = transactions
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case from
        case to
        case search
        case rewardUnits
        case transactions
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action)
        try container.encodeIfPresent(from, forKey: .from)
        try container.encodeIfPresent(to, forKey: .to)
        try container.encodeIfPresent(search, forKey: .search)
        try container.encodeIfPresent(rewardUnits, forKey: .rewardUnits)
        try container.encodeIfPresent(transactions, forKey: .transactions)
    }
}

