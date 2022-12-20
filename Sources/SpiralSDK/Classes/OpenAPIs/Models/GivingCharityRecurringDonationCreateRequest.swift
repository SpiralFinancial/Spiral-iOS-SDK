//
// GivingCharityRecurringDonationCreateRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct GivingCharityRecurringDonationCreateRequest: Codable, JSONEncodable, Hashable {

    /** External account ID donation is made from */
    public var accountId: String
    /** Spiral ID of Charity to donate to */
    public var charityId: String
    /** Recurring donation start date as timestamp */
    public var startDate: Int64
    /** Dollar value that is donated to Charity */
    public var amount: Double
    /** Is recurring donation paused */
    public var paused: Bool
    /** Is recurring donation stopped */
    public var stopped: Bool
    /** Is recurring donation anonymous */
    public var anonymous: Bool

    public init(accountId: String, charityId: String, startDate: Int64, amount: Double, paused: Bool, stopped: Bool, anonymous: Bool) {
        self.accountId = accountId
        self.charityId = charityId
        self.startDate = startDate
        self.amount = amount
        self.paused = paused
        self.stopped = stopped
        self.anonymous = anonymous
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accountId
        case charityId
        case startDate
        case amount
        case paused
        case stopped
        case anonymous
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(charityId, forKey: .charityId)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(amount, forKey: .amount)
        try container.encode(paused, forKey: .paused)
        try container.encode(stopped, forKey: .stopped)
        try container.encode(anonymous, forKey: .anonymous)
    }
}

