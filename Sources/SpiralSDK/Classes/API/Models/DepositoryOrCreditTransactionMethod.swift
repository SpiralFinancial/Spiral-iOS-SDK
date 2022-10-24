//
// DepositoryOrCreditTransactionMethod.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Classification of DepositoryOrCreditTransaction by purpose as an enum. */
public enum DepositoryOrCreditTransactionMethod: String, Codable, CaseIterable {
    case cardPresent = "card present"
    case cardNotPresent = "card not present"
    case check = "check"
    case eft = "eft"
}
