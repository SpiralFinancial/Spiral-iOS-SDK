//
//  SpiralAnalyticsManager.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/12/23.
//

import Foundation

public class SpiralAnalyticsManager {
    static let shared = SpiralAnalyticsManager()
    
    public func trackEvents(events: [SpiralAnalyticsEvent]) {
        SpiralAnalyticsDataStore.shared.addEvents(events: events)
    }
    
    public func trackEvent(event: SpiralAnalyticsEvent) {
        trackEvents(events: [event])
    }
    
    private func uploadEvents() {
        
    }
}
