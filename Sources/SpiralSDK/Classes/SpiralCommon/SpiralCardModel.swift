//
//  CardModel.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 10/17/22.
//

import Foundation

public protocol SpiralCardPayloadModel: Decodable {}

public enum SpiralPayloadType: String, Codable, Equatable {
    case generic
}

public struct SpiralCardModel: Decodable {

    let payloadType: SpiralPayloadType
    var timestamp: TimeInterval?
    var timestampAsMilliseconds: TimeInterval? {
        return timestamp?.fromMilliseconds()
    }

    var payload: SpiralCardPayloadModel?

    var identifier: Int?

    enum CodingKeys: String, CodingKey {
        case timestamp
        case payload
        case payloadType = "type"
    }

    public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)

            payloadType = try values.decode(SpiralPayloadType.self, forKey: .payloadType)
            timestamp = try? values.decode(TimeInterval.self, forKey: .timestamp)
            payload = try payload(with: values)
        } catch let parseError {
            print("\(parseError)")
            throw parseError
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func payload(with values: KeyedDecodingContainer<SpiralCardModel.CodingKeys>) throws -> SpiralCardPayloadModel? {

        switch payloadType {
        case .generic:
            return try values.decode(SpiralGenericCardPayloadModel.self, forKey: .payload)
        default:
            return nil
        }
    }

    public init(payloadType: SpiralPayloadType, payload: SpiralCardPayloadModel?) {
        self.payloadType = payloadType
        self.payload = payload
    }
}
