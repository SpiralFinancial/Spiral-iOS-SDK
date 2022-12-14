//
// SocialResponsibilityTransactionListResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct SocialResponsibilityTransactionListResponse: Codable, JSONEncodable, Hashable {

    /** The count of all transactions across all pages. */
    public var totalTransactions: Double
    /** The count of all transactions on this page. */
    public var pageTransactions: Double
    /** The total summed amount of all transactions across all pages. */
    public var totalAmount: Double
    /** The summed amount of all transactions on this page. */
    public var pageAmount: Double
    public var transactions: [SocialResponsibilityTransactionInstantImpactResponse]

    public init(totalTransactions: Double, pageTransactions: Double, totalAmount: Double, pageAmount: Double, transactions: [SocialResponsibilityTransactionInstantImpactResponse]) {
        self.totalTransactions = totalTransactions
        self.pageTransactions = pageTransactions
        self.totalAmount = totalAmount
        self.pageAmount = pageAmount
        self.transactions = transactions
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case totalTransactions
        case pageTransactions
        case totalAmount
        case pageAmount
        case transactions
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalTransactions, forKey: .totalTransactions)
        try container.encode(pageTransactions, forKey: .pageTransactions)
        try container.encode(totalAmount, forKey: .totalAmount)
        try container.encode(pageAmount, forKey: .pageAmount)
        try container.encode(transactions, forKey: .transactions)
    }
}

