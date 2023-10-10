//
// FeatureFlagsResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** List of feature flags and their values */
public struct FeatureFlagsResponse: Codable, JSONEncodable, Hashable {

    public var featureFlags: [FeatureFlag]

    public init(featureFlags: [FeatureFlag]) {
        self.featureFlags = featureFlags
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case featureFlags
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(featureFlags, forKey: .featureFlags)
    }
}

