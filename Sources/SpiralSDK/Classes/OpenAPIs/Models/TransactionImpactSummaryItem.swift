//
// TransactionImpactSummaryItem.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Customer&#39;s Impact summary report per unit */
public struct TransactionImpactSummaryItem: Codable, JSONEncodable, Hashable {

    /** Unique Charity Reward Unit id */
    public var charityRewardUnitId: String?
    /** Unique Reward Unit id */
    public var rewardUnitId: String?
    /** Reward unit name */
    public var rewardUnitName: String
    /** Title label text for associated reward unit */
    public var rewardUnitTitle: String?
    /** Subtitle label text for associated reward unit */
    public var rewardUnitSubtitle: String?
    /** URL for reward unit icon */
    public var rewardUnitIcon: String?
    /** Aggregated point value for associated reward unit */
    public var totalImpactUnits: Double?
    /** Aggregated dollar value for associated reward unit */
    public var totalDonatedAmount: Double?
    /** Is reward a monetary amount */
    public var isMonetaryAmount: Bool?
    /** Charity name */
    public var charityName: String?

    public init(charityRewardUnitId: String? = nil, rewardUnitId: String? = nil, rewardUnitName: String, rewardUnitTitle: String? = nil, rewardUnitSubtitle: String? = nil, rewardUnitIcon: String? = nil, totalImpactUnits: Double? = nil, totalDonatedAmount: Double? = nil, isMonetaryAmount: Bool? = nil, charityName: String? = nil) {
        self.charityRewardUnitId = charityRewardUnitId
        self.rewardUnitId = rewardUnitId
        self.rewardUnitName = rewardUnitName
        self.rewardUnitTitle = rewardUnitTitle
        self.rewardUnitSubtitle = rewardUnitSubtitle
        self.rewardUnitIcon = rewardUnitIcon
        self.totalImpactUnits = totalImpactUnits
        self.totalDonatedAmount = totalDonatedAmount
        self.isMonetaryAmount = isMonetaryAmount
        self.charityName = charityName
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case charityRewardUnitId
        case rewardUnitId
        case rewardUnitName
        case rewardUnitTitle
        case rewardUnitSubtitle
        case rewardUnitIcon
        case totalImpactUnits
        case totalDonatedAmount
        case isMonetaryAmount
        case charityName
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(charityRewardUnitId, forKey: .charityRewardUnitId)
        try container.encodeIfPresent(rewardUnitId, forKey: .rewardUnitId)
        try container.encode(rewardUnitName, forKey: .rewardUnitName)
        try container.encodeIfPresent(rewardUnitTitle, forKey: .rewardUnitTitle)
        try container.encodeIfPresent(rewardUnitSubtitle, forKey: .rewardUnitSubtitle)
        try container.encodeIfPresent(rewardUnitIcon, forKey: .rewardUnitIcon)
        try container.encodeIfPresent(totalImpactUnits, forKey: .totalImpactUnits)
        try container.encodeIfPresent(totalDonatedAmount, forKey: .totalDonatedAmount)
        try container.encodeIfPresent(isMonetaryAmount, forKey: .isMonetaryAmount)
        try container.encodeIfPresent(charityName, forKey: .charityName)
    }
}

