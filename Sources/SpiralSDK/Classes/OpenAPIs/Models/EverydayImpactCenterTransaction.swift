//
// EverydayImpactCenterTransaction.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct EverydayImpactCenterTransaction: Codable, JSONEncodable, Hashable {

    public var categoryId: String
    public var customerId: String?
    /** Name of the charity category. */
    public var categoryName: String
    public var rewardUnit: CharityRewardUnit?
    /** Point value for associated Impact Category Unit. */
    public var impact: Double
    /** Dollar value donated to Impact Category Charity. */
    public var donatedAmount: Double?
    /** Dollar value of how much was rounded up */
    public var roundupAmount: Double?
    /** Permanent, unique transaction identifier. Must survive changes to pending status or amount. */
    public var transactionId: String?
    /** Transaction Unix timestamp */
    public var transactionTimestamp: Double?
    /** The cleaned up transaction title. */
    public var transactionTitle: String?
    /** The type or source of the transaction */
    public var transactionType: String?
    /** Detailed transaction description, like it would appear in your statement. */
    public var statementDescription: String?
    /** Transaction amount with two decimal places. */
    public var transactionAmount: Double?
    /** Transaction account identifier. */
    public var transactionAccountId: String?
    /** Point value for cumulative impact (units) at the time of transaction */
    public var cumulativeImpact: Double?
    /** Point value for one unit progress for that transaction. Can be >1 if transaction earned more than 1 unit. */
    public var cumulativeProgress: Double?

    public init(categoryId: String, customerId: String? = nil, categoryName: String, rewardUnit: CharityRewardUnit? = nil, impact: Double, donatedAmount: Double? = nil, roundupAmount: Double? = nil, transactionId: String? = nil, transactionTimestamp: Double? = nil, transactionTitle: String? = nil, transactionType: String? = nil, statementDescription: String? = nil, transactionAmount: Double? = nil, transactionAccountId: String? = nil, cumulativeImpact: Double? = nil, cumulativeProgress: Double? = nil) {
        self.categoryId = categoryId
        self.customerId = customerId
        self.categoryName = categoryName
        self.rewardUnit = rewardUnit
        self.impact = impact
        self.donatedAmount = donatedAmount
        self.roundupAmount = roundupAmount
        self.transactionId = transactionId
        self.transactionTimestamp = transactionTimestamp
        self.transactionTitle = transactionTitle
        self.transactionType = transactionType
        self.statementDescription = statementDescription
        self.transactionAmount = transactionAmount
        self.transactionAccountId = transactionAccountId
        self.cumulativeImpact = cumulativeImpact
        self.cumulativeProgress = cumulativeProgress
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case categoryId
        case customerId
        case categoryName
        case rewardUnit
        case impact
        case donatedAmount
        case roundupAmount
        case transactionId
        case transactionTimestamp
        case transactionTitle
        case transactionType
        case statementDescription
        case transactionAmount
        case transactionAccountId
        case cumulativeImpact
        case cumulativeProgress
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categoryId, forKey: .categoryId)
        try container.encodeIfPresent(customerId, forKey: .customerId)
        try container.encode(categoryName, forKey: .categoryName)
        try container.encodeIfPresent(rewardUnit, forKey: .rewardUnit)
        try container.encode(impact, forKey: .impact)
        try container.encodeIfPresent(donatedAmount, forKey: .donatedAmount)
        try container.encodeIfPresent(roundupAmount, forKey: .roundupAmount)
        try container.encodeIfPresent(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(transactionTimestamp, forKey: .transactionTimestamp)
        try container.encodeIfPresent(transactionTitle, forKey: .transactionTitle)
        try container.encodeIfPresent(transactionType, forKey: .transactionType)
        try container.encodeIfPresent(statementDescription, forKey: .statementDescription)
        try container.encodeIfPresent(transactionAmount, forKey: .transactionAmount)
        try container.encodeIfPresent(transactionAccountId, forKey: .transactionAccountId)
        try container.encodeIfPresent(cumulativeImpact, forKey: .cumulativeImpact)
        try container.encodeIfPresent(cumulativeProgress, forKey: .cumulativeProgress)
    }
}

