//
// OperationalStatus.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Operational status of everyday impact or donation transactions. */
public enum OperationalStatus: String, Codable, CaseIterable {
    case denied = "DENIED"
    case pending = "PENDING"
    case approved = "APPROVED"
    case processed = "PROCESSED"
    case failed = "FAILED"
}