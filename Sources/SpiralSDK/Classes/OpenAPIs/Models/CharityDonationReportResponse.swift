//
// CharityDonationReportResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CharityDonationReportResponse: Codable, JSONEncodable, Hashable {

    /** Dollar value aggragating all donations */
    public var totalAmountDonated: Double
    public var donations: [CharityDonation]

    public init(totalAmountDonated: Double, donations: [CharityDonation]) {
        self.totalAmountDonated = totalAmountDonated
        self.donations = donations
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case totalAmountDonated
        case donations
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalAmountDonated, forKey: .totalAmountDonated)
        try container.encode(donations, forKey: .donations)
    }
}

