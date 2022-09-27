//
//  SpiralExitPayload.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

public struct SpiralExitPayload: SpiralEventPayload {
    public init(error: SpiralError?) {
        self.error = error
    }
    
    public let error: SpiralError?
}
