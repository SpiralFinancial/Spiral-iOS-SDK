//
// ExtendedInstantImpactCategoryRewardSelection.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Instant Impact Category Charity and Reward Unit selection with additional details */
public struct ExtendedInstantImpactCategoryRewardSelection: Codable, JSONEncodable, Hashable {

    public var instantImpactCategoryId: String
    public var charityId: String
    public var rewardUnitId: String
    public var rewardUnitName: String
    public var enabled: Bool?

    public init(instantImpactCategoryId: String, charityId: String, rewardUnitId: String, rewardUnitName: String, enabled: Bool? = nil) {
        self.instantImpactCategoryId = instantImpactCategoryId
        self.charityId = charityId
        self.rewardUnitId = rewardUnitId
        self.rewardUnitName = rewardUnitName
        self.enabled = enabled
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case instantImpactCategoryId
        case charityId
        case rewardUnitId
        case rewardUnitName
        case enabled
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(instantImpactCategoryId, forKey: .instantImpactCategoryId)
        try container.encode(charityId, forKey: .charityId)
        try container.encode(rewardUnitId, forKey: .rewardUnitId)
        try container.encode(rewardUnitName, forKey: .rewardUnitName)
        try container.encodeIfPresent(enabled, forKey: .enabled)
    }
}

