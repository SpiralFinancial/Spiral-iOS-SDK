//
// EverydayImpactCenterTransactionAllOf.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct EverydayImpactCenterTransactionAllOf: Codable, JSONEncodable, Hashable {

    /** Point value for cumulative impact (units) at the time of transaction */
    public var cumulativeImpactUnits: Double?
    /** Point value for one unit progress for that transaction. Can be >1 if transaction earned more than 1 unit. */
    public var cumulativeProgressUnits: Double?

    public init(cumulativeImpactUnits: Double? = nil, cumulativeProgressUnits: Double? = nil) {
        self.cumulativeImpactUnits = cumulativeImpactUnits
        self.cumulativeProgressUnits = cumulativeProgressUnits
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case cumulativeImpactUnits
        case cumulativeProgressUnits
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cumulativeImpactUnits, forKey: .cumulativeImpactUnits)
        try container.encodeIfPresent(cumulativeProgressUnits, forKey: .cumulativeProgressUnits)
    }
}

