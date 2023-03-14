//
// OperationsCenterAction.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Possible actions in CST operations center */
public enum OperationsCenterAction: String, Codable, CaseIterable {
    case process = "PROCESS"
    case deny = "DENY"
}