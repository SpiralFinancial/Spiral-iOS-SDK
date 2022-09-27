//
//  SpiralSuccessPayload.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

public struct SpiralSuccessPayload: SpiralEventPayload {
    public init(result: Bool) {
        self.result = result
    }
    
    public let result: Bool
}
