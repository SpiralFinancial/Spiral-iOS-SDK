//
// ClientPatchRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ClientPatchRequest: Codable, JSONEncodable, Hashable {

    /** Spiral generated unique Client ID */
    public var id: String
    /** Starting timestamp of the fintech's contract. */
    public var contractStart: Double?
    /** Ending timestamp of the fintech's contract. */
    public var contractEnd: Double?
    /** Spiral-side manager assigned to this client. */
    public var manager: String?

    public init(id: String, contractStart: Double? = nil, contractEnd: Double? = nil, manager: String? = nil) {
        self.id = id
        self.contractStart = contractStart
        self.contractEnd = contractEnd
        self.manager = manager
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case contractStart
        case contractEnd
        case manager
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(contractStart, forKey: .contractStart)
        try container.encodeIfPresent(contractEnd, forKey: .contractEnd)
        try container.encodeIfPresent(manager, forKey: .manager)
    }
}
