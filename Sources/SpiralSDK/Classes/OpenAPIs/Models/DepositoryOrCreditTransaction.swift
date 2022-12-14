//
// DepositoryOrCreditTransaction.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Describes a transaction against a debit or credit card account. */
public struct DepositoryOrCreditTransaction: Codable, JSONEncodable, Hashable {

    /** Permanent, unique transaction identifier. Must survive changes to pending status or amount. */
    public var transactionId: String
    /** Unique customer ID */
    public var customerId: String?
    /** References to the account that this transaction is posting against. */
    public var accountId: String?
    /** Description of the transaction. */
    public var description: String?
    /** Addenda or distinguishing information for the transaction. */
    public var name: String?
    /** Hierarchical categorization, use multi-valued array to indicate hierarchy. */
    public var category: [String]?
    /** Flat categorization. For hashtags omit leading */
    public var tags: [String]?
    /** Fixed-point decimal number, carried up to two decimal places. */
    public var endingBalance: Int?
    /** The date/time when the transaction was authorized, in the time zone local to the transaction or to the customer. */
    public var transactedAt: Date
    /** The date/time when the transaction settled, in the time zone local to the customer. Must be null if the transaction is pending. */
    public var settledAt: Date?
    /** Reference to the identity of the merchant related to this transaction. */
    public var merchantCategoryCode: String
    public var geolocation: GeoLocation?
    /** The ISO 4217 currency in which this transaction is denominated. One of either the currency or non_iso_currency fields is required. */
    public var currency: String?
    /** If the transaction is denominated in a non-ISO currency, provide the currency's symbol. */
    public var nonIsoCurrency: String?
    public var type: DepositoryOrCreditTransactionType
    public var method: DepositoryOrCreditTransactionMethod
    /** Indicates that this transaction has not posted. */
    public var pending: Bool?
    /** Fixed-point decimal number, carried up to two decimal places. */
    public var amount: Double
    /** Fixed-point decimal number, carried up to two decimal places. */
    public var feeAmount: Double?
    /** If this transaction is an internal transfer type, references the accountId associated with this transaction. */
    public var transferAccountId: String?
    /** Fixed-point decimal number, carried up to two decimal places. */
    public var rewardAmount: Double?
    /** Fixed-point representation of a normalized rate, carried up to four decimal places. */
    public var rewardRate: Double?
    /** ISO 4217 currency code. */
    public var rewardCurrency: String?
    /** If the reward contribution is denominated in a non-ISO currency, provide the currency's symbol. */
    public var rewardNonIsoCurrency: String?

    public init(transactionId: String, customerId: String? = nil, accountId: String? = nil, description: String? = nil, name: String? = nil, category: [String]? = nil, tags: [String]? = nil, endingBalance: Int? = nil, transactedAt: Date, settledAt: Date? = nil, merchantCategoryCode: String, geolocation: GeoLocation? = nil, currency: String? = nil, nonIsoCurrency: String? = nil, type: DepositoryOrCreditTransactionType, method: DepositoryOrCreditTransactionMethod, pending: Bool? = nil, amount: Double, feeAmount: Double? = nil, transferAccountId: String? = nil, rewardAmount: Double? = nil, rewardRate: Double? = nil, rewardCurrency: String? = nil, rewardNonIsoCurrency: String? = nil) {
        self.transactionId = transactionId
        self.customerId = customerId
        self.accountId = accountId
        self.description = description
        self.name = name
        self.category = category
        self.tags = tags
        self.endingBalance = endingBalance
        self.transactedAt = transactedAt
        self.settledAt = settledAt
        self.merchantCategoryCode = merchantCategoryCode
        self.geolocation = geolocation
        self.currency = currency
        self.nonIsoCurrency = nonIsoCurrency
        self.type = type
        self.method = method
        self.pending = pending
        self.amount = amount
        self.feeAmount = feeAmount
        self.transferAccountId = transferAccountId
        self.rewardAmount = rewardAmount
        self.rewardRate = rewardRate
        self.rewardCurrency = rewardCurrency
        self.rewardNonIsoCurrency = rewardNonIsoCurrency
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case transactionId
        case customerId
        case accountId
        case description
        case name
        case category
        case tags
        case endingBalance
        case transactedAt
        case settledAt
        case merchantCategoryCode
        case geolocation
        case currency
        case nonIsoCurrency
        case type
        case method
        case pending
        case amount
        case feeAmount
        case transferAccountId
        case rewardAmount
        case rewardRate
        case rewardCurrency
        case rewardNonIsoCurrency
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(customerId, forKey: .customerId)
        try container.encodeIfPresent(accountId, forKey: .accountId)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(endingBalance, forKey: .endingBalance)
        try container.encode(transactedAt, forKey: .transactedAt)
        try container.encodeIfPresent(settledAt, forKey: .settledAt)
        try container.encode(merchantCategoryCode, forKey: .merchantCategoryCode)
        try container.encodeIfPresent(geolocation, forKey: .geolocation)
        try container.encodeIfPresent(currency, forKey: .currency)
        try container.encodeIfPresent(nonIsoCurrency, forKey: .nonIsoCurrency)
        try container.encode(type, forKey: .type)
        try container.encode(method, forKey: .method)
        try container.encodeIfPresent(pending, forKey: .pending)
        try container.encode(amount, forKey: .amount)
        try container.encodeIfPresent(feeAmount, forKey: .feeAmount)
        try container.encodeIfPresent(transferAccountId, forKey: .transferAccountId)
        try container.encodeIfPresent(rewardAmount, forKey: .rewardAmount)
        try container.encodeIfPresent(rewardRate, forKey: .rewardRate)
        try container.encodeIfPresent(rewardCurrency, forKey: .rewardCurrency)
        try container.encodeIfPresent(rewardNonIsoCurrency, forKey: .rewardNonIsoCurrency)
    }
}

