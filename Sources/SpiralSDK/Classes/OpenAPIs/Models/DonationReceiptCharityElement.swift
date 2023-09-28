//
// DonationReceiptCharityElement.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct DonationReceiptCharityElement: Codable, JSONEncodable, Hashable {

    /** Charity name */
    public var name: String
    public var content: [DonationReceiptCharityDonationElement]

    public init(name: String, content: [DonationReceiptCharityDonationElement]) {
        self.name = name
        self.content = content
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case content
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(content, forKey: .content)
    }
}

