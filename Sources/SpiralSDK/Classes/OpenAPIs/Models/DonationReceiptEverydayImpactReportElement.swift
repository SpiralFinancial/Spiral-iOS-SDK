//
// DonationReceiptEverydayImpactReportElement.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct DonationReceiptEverydayImpactReportElement: Codable, JSONEncodable, Hashable {

    /** Charity name */
    public var charityName: String
    /** Charity EIN */
    public var charityEin: String
    /** Charity Logo url */
    public var charityLogoUrl: String?
    /** Reward unit key */
    public var unit: String
    /** Human readable reward unit label */
    public var unitLabel: String
    /** Total amount customer donated to this charity for this unit */
    public var totalDonatedAmount: Double
    /** Number of units customer donated for */
    public var totalImpactUnits: Int

    public init(charityName: String, charityEin: String, charityLogoUrl: String? = nil, unit: String, unitLabel: String, totalDonatedAmount: Double, totalImpactUnits: Int) {
        self.charityName = charityName
        self.charityEin = charityEin
        self.charityLogoUrl = charityLogoUrl
        self.unit = unit
        self.unitLabel = unitLabel
        self.totalDonatedAmount = totalDonatedAmount
        self.totalImpactUnits = totalImpactUnits
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case charityName
        case charityEin
        case charityLogoUrl
        case unit
        case unitLabel
        case totalDonatedAmount
        case totalImpactUnits
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(charityName, forKey: .charityName)
        try container.encode(charityEin, forKey: .charityEin)
        try container.encodeIfPresent(charityLogoUrl, forKey: .charityLogoUrl)
        try container.encode(unit, forKey: .unit)
        try container.encode(unitLabel, forKey: .unitLabel)
        try container.encode(totalDonatedAmount, forKey: .totalDonatedAmount)
        try container.encode(totalImpactUnits, forKey: .totalImpactUnits)
    }
}
