//
// GivingCustomerDonationReceiptSummaryReceipt.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct GivingCustomerDonationReceiptSummaryReceipt: Codable, JSONEncodable, Hashable {

    /** Receipt ID */
    public var id: String
    /** Datetime of the receipt */
    public var receiptDate: Date
    /** Recipient charity name */
    public var charityName: String
    /** Donation period - one-time or monthly */
    public var period: String
    /** Whether the receipt has been processed and is ready for viewing */
    public var isReady: Bool

    public init(id: String, receiptDate: Date, charityName: String, period: String, isReady: Bool) {
        self.id = id
        self.receiptDate = receiptDate
        self.charityName = charityName
        self.period = period
        self.isReady = isReady
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case receiptDate
        case charityName
        case period
        case isReady
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(receiptDate, forKey: .receiptDate)
        try container.encode(charityName, forKey: .charityName)
        try container.encode(period, forKey: .period)
        try container.encode(isReady, forKey: .isReady)
    }
}

