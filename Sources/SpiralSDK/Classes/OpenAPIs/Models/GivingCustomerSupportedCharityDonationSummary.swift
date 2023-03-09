//
// GivingCustomerSupportedCharityDonationSummary.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Customer giving charity donations summary */
public struct GivingCustomerSupportedCharityDonationSummary: Codable, JSONEncodable, Hashable {

    public var charity: GivingCharityResponse?
    public var recurring: GivingCustomerSupportedCharityDonationSummaryRecurring?
    /** Total amount donated to this charity (one-time and processed recurring) */
    public var totalDonatedAmount: Double?

    public init(charity: GivingCharityResponse? = nil, recurring: GivingCustomerSupportedCharityDonationSummaryRecurring? = nil, totalDonatedAmount: Double? = nil) {
        self.charity = charity
        self.recurring = recurring
        self.totalDonatedAmount = totalDonatedAmount
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case charity
        case recurring
        case totalDonatedAmount
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(charity, forKey: .charity)
        try container.encodeIfPresent(recurring, forKey: .recurring)
        try container.encodeIfPresent(totalDonatedAmount, forKey: .totalDonatedAmount)
    }
}

