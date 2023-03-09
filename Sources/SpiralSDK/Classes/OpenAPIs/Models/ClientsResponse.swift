//
// ClientsResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ClientsResponse: Codable, JSONEncodable, Hashable {

    public var clients: [Client]

    public init(clients: [Client]) {
        self.clients = clients
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case clients
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(clients, forKey: .clients)
    }
}

