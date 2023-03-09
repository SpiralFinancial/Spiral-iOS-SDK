//
// ClientDonationResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Represents one singular donation instance for a given client that can then be operated on. */
public struct ClientDonationResponse: Codable, JSONEncodable, Hashable {

    public var clientId: String
    public var clientName: String
    public var charityId: String
    public var charityName: String
    /** The charity's address, formatted as a single line */
    public var charityAddress: String?
    public var customerId: String?
    /** Name of the charity category. */
    public var categoryName: String
    /** Permanent, unique donation identifier. */
    public var donationId: String?
    /** Donation Unix timestamp */
    public var donationTimestamp: Double?
    /** The type of the donation */
    public var donationType: String?
    /** donation amount with two decimal places. */
    public var donationAmount: Double?
    /** Transaction account identifier. */
    public var transactionAccountId: String?

    public init(clientId: String, clientName: String, charityId: String, charityName: String, charityAddress: String? = nil, customerId: String? = nil, categoryName: String, donationId: String? = nil, donationTimestamp: Double? = nil, donationType: String? = nil, donationAmount: Double? = nil, transactionAccountId: String? = nil) {
        self.clientId = clientId
        self.clientName = clientName
        self.charityId = charityId
        self.charityName = charityName
        self.charityAddress = charityAddress
        self.customerId = customerId
        self.categoryName = categoryName
        self.donationId = donationId
        self.donationTimestamp = donationTimestamp
        self.donationType = donationType
        self.donationAmount = donationAmount
        self.transactionAccountId = transactionAccountId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case clientId
        case clientName
        case charityId
        case charityName
        case charityAddress
        case customerId
        case categoryName
        case donationId
        case donationTimestamp
        case donationType
        case donationAmount
        case transactionAccountId
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(clientId, forKey: .clientId)
        try container.encode(clientName, forKey: .clientName)
        try container.encode(charityId, forKey: .charityId)
        try container.encode(charityName, forKey: .charityName)
        try container.encodeIfPresent(charityAddress, forKey: .charityAddress)
        try container.encodeIfPresent(customerId, forKey: .customerId)
        try container.encode(categoryName, forKey: .categoryName)
        try container.encodeIfPresent(donationId, forKey: .donationId)
        try container.encodeIfPresent(donationTimestamp, forKey: .donationTimestamp)
        try container.encodeIfPresent(donationType, forKey: .donationType)
        try container.encodeIfPresent(donationAmount, forKey: .donationAmount)
        try container.encodeIfPresent(transactionAccountId, forKey: .transactionAccountId)
    }
}

