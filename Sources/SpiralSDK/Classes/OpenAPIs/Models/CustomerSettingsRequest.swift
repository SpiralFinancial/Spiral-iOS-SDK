//
// CustomerSettingsRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CustomerSettingsRequest: Codable, JSONEncodable, Hashable {

    public enum RewardType: String, Codable, CaseIterable {
        case userSponsored = "UserSponsored"
        case bankSponsored = "BankSponsored"
    }
    /** True if the customer has ever opted in to round up in the user-sponsored flow. */
    public var userSponsoredEverOptedIn: Bool?
    public var rewardType: RewardType?
    /** Has customer ever consented to our TOS */
    public var consented: Bool?
    /** Is user currently opted in for everyday impact */
    public var optedIn: Bool?
    public var roundUp: RoundUpSelections
    public var limitSelection: CustomerImpactLimitSelections
    /** Customer's limit value as in dollar amount */
    public var limitValue: Double?

    public init(userSponsoredEverOptedIn: Bool? = nil, rewardType: RewardType? = nil, consented: Bool? = nil, optedIn: Bool? = nil, roundUp: RoundUpSelections, limitSelection: CustomerImpactLimitSelections, limitValue: Double? = nil) {
        self.userSponsoredEverOptedIn = userSponsoredEverOptedIn
        self.rewardType = rewardType
        self.consented = consented
        self.optedIn = optedIn
        self.roundUp = roundUp
        self.limitSelection = limitSelection
        self.limitValue = limitValue
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case userSponsoredEverOptedIn
        case rewardType
        case consented
        case optedIn
        case roundUp
        case limitSelection
        case limitValue
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(userSponsoredEverOptedIn, forKey: .userSponsoredEverOptedIn)
        try container.encodeIfPresent(rewardType, forKey: .rewardType)
        try container.encodeIfPresent(consented, forKey: .consented)
        try container.encodeIfPresent(optedIn, forKey: .optedIn)
        try container.encode(roundUp, forKey: .roundUp)
        try container.encode(limitSelection, forKey: .limitSelection)
        try container.encodeIfPresent(limitValue, forKey: .limitValue)
    }
}

