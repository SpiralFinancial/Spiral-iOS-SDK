//
// TransactionImpactSummaryResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Single customer&#39;s Impact report */
public struct TransactionImpactSummaryResponse: Codable, JSONEncodable, Hashable {

    /** ID of most recently rewarded unit */
    public var mostRecentRewardedUnitId: String?
    public var impact: [TransactionImpactSummaryItem]

    public init(mostRecentRewardedUnitId: String? = nil, impact: [TransactionImpactSummaryItem]) {
        self.mostRecentRewardedUnitId = mostRecentRewardedUnitId
        self.impact = impact
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case mostRecentRewardedUnitId
        case impact
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(mostRecentRewardedUnitId, forKey: .mostRecentRewardedUnitId)
        try container.encode(impact, forKey: .impact)
    }
}
