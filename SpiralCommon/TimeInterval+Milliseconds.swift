//
//  TimeInterval+Milliseconds.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 14.05.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func fromMilliseconds() -> TimeInterval {
        return self / 1000
    }
    
    func toMilliseconds() -> TimeInterval {
        return self * 1000
    }
    
}
