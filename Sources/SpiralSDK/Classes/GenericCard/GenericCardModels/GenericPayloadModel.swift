//
//  GenericPayloadModel.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 20.06.22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import Foundation

public struct GenericCardPayloadModel: Codable, SpiralCardPayloadModel {
    let identifier: Int
    let type: String
    var data: GenericCardModel

    let isNew: Bool
    
    public init(identifier: Int, type: String, data: GenericCardModel, isNew: Bool) {
        self.identifier = identifier
        self.type = type
        self.data = data
        self.isNew = isNew
    }
}

struct GenericPayloadVersionModel: Codable {
    let id: String
    
    let created: TimeInterval
    let modified: TimeInterval
    
    let major: Int
    let minor: Int
    let patch: Int
    
    let platform: String
    let preview: String
}
