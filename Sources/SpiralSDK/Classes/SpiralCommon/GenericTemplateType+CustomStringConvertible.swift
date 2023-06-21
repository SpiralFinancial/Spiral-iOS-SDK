//
//  GenericTemplateType+CustomStringConvertible.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 11/10/22.
//

import Foundation

extension GenericTemplateType: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}
