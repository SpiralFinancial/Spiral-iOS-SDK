//
// ClientAgreementsResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ClientAgreementsResponse: Codable, JSONEncodable, Hashable {

    public var agreements: [ClientAgreementResponse]

    public init(agreements: [ClientAgreementResponse]) {
        self.agreements = agreements
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case agreements
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(agreements, forKey: .agreements)
    }
}

