//
// DonationReceiptSummaryGrouping.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Possible groupings to select when getting receipt summary - ungrouped or grouped by charity */
public enum DonationReceiptSummaryGrouping: String, Codable, CaseIterable {
    case ungrouped = "UNGROUPED"
    case charity = "CHARITY"
}