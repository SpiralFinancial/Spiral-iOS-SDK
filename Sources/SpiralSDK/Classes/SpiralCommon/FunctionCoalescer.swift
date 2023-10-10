//
//  FunctionCoalescer.swift
//  SpiralBank
//
//  Created by Ron Soffer on 8/4/20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import Foundation

class FunctionCoalescer {

    private static var coalesceTracker: [String: Int] = [:]

    /// Waits the timeout to trigger the block. If it recieves a call with the same context it will then restart the timeout timer.
    /// It will continue doing this untill no additional calls have been made and the timer has run out. At which time it will execute the block.
    static func coalesce(context: String, timeout: TimeInterval, queue: DispatchQueue, block: @escaping () -> Void) {
        let mainQueue = DispatchQueue.main
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                coalesce(context: context, timeout: timeout, queue: queue, block: block)
            }
            return
        }
        coalesceTracker[context] = (coalesceTracker[context] ?? 0) + 1
        mainQueue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(timeout * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: {
            let trackingCode = (coalesceTracker[context] ?? 1) - 1
            if trackingCode == 0 {
                coalesceTracker[context] = nil
                if queue === mainQueue {
                    block()
                } else {
                    queue.async(execute: block)
                }
            } else {
                coalesceTracker[context] = trackingCode
            }
        })
    }
    
    /// Similar to coalesce(...). The major difference is that this triggers the block right away and then ignores subsequent calls that
    /// match the context until the ingore time passes.
    static func triggerFirstThenIgnoreCalls(context: String,
                                            ignoreTime: TimeInterval,
                                            queue: DispatchQueue = DispatchQueue.main,
                                            block: @escaping () -> Void) {
        
        let mainQueue = DispatchQueue.main
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                triggerFirstThenIgnoreCalls(context: context, ignoreTime: ignoreTime, queue: queue, block: block)
            }
            return
        }
        
        let trackingCode = coalesceTracker[context] ?? 0
        
        if trackingCode == 0 {
            coalesceTracker[context] = 1
            if queue === mainQueue {
                block()
            } else {
                queue.async(execute: block)
            }
        } else {
            return
        }
        
        mainQueue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(ignoreTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            coalesceTracker[context] = nil
        }
    }
    
    static func coalesce(context: String, timeout: TimeInterval, block: @escaping () -> Void) {
        coalesce(context: context, timeout: timeout, queue: DispatchQueue.main, block: block)
    }

    static func coalesce(context: String, block: @escaping () -> Void) {
        coalesce(context: context, timeout: 0, block: block)
    }
}
