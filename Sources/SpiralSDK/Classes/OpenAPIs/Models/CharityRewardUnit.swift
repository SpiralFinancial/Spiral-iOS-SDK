//
// CharityRewardUnit.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CharityRewardUnit: Codable, JSONEncodable, Hashable {

    /** Unique Charity Reward Unit ID */
    public var id: String
    /** Charity ID this reward unit is assigned to */
    public var charityId: String
    /** Name of the charity (used in reply of enriched transactions). */
    public var charityName: String?
    /** Internal cost per one unit. Up to 2 decimal points */
    public var internalCostAmount: Double?
    /** Reward unit ID */
    public var rewardUnitId: String
    /** Reward Unit key */
    public var unit: String
    /** Whether the unit is represented as donated currency */
    public var isMonetaryUnit: Bool?

    public init(id: String, charityId: String, charityName: String? = nil, internalCostAmount: Double? = nil, rewardUnitId: String, unit: String, isMonetaryUnit: Bool? = nil) {
        self.id = id
        self.charityId = charityId
        self.charityName = charityName
        self.internalCostAmount = internalCostAmount
        self.rewardUnitId = rewardUnitId
        self.unit = unit
        self.isMonetaryUnit = isMonetaryUnit
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case charityId
        case charityName
        case internalCostAmount
        case rewardUnitId
        case unit
        case isMonetaryUnit
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(charityId, forKey: .charityId)
        try container.encodeIfPresent(charityName, forKey: .charityName)
        try container.encodeIfPresent(internalCostAmount, forKey: .internalCostAmount)
        try container.encode(rewardUnitId, forKey: .rewardUnitId)
        try container.encode(unit, forKey: .unit)
        try container.encodeIfPresent(isMonetaryUnit, forKey: .isMonetaryUnit)
    }
}

