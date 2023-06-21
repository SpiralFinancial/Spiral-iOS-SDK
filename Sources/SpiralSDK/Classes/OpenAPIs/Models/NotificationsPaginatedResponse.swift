//
// NotificationsPaginatedResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct NotificationsPaginatedResponse: Codable, JSONEncodable, Hashable {

    /** Total number of pages */
    public var totalPages: Int
    /** Total number of elements */
    public var totalElements: Int64
    /** Is this the first page */
    public var first: Bool
    /** Is this the last page */
    public var last: Bool
    /** Page number */
    public var number: Int
    public var sort: SortResponse
    /** Page size */
    public var size: Int
    /** Is this page empty */
    public var empty: Bool
    public var content: [NotificationResponse]

    public init(totalPages: Int, totalElements: Int64, first: Bool, last: Bool, number: Int, sort: SortResponse, size: Int, empty: Bool, content: [NotificationResponse]) {
        self.totalPages = totalPages
        self.totalElements = totalElements
        self.first = first
        self.last = last
        self.number = number
        self.sort = sort
        self.size = size
        self.empty = empty
        self.content = content
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case totalPages
        case totalElements
        case first
        case last
        case number
        case sort
        case size
        case empty
        case content
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalPages, forKey: .totalPages)
        try container.encode(totalElements, forKey: .totalElements)
        try container.encode(first, forKey: .first)
        try container.encode(last, forKey: .last)
        try container.encode(number, forKey: .number)
        try container.encode(sort, forKey: .sort)
        try container.encode(size, forKey: .size)
        try container.encode(empty, forKey: .empty)
        try container.encode(content, forKey: .content)
    }
}

