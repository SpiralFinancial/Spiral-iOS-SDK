//
//  SpiralAnalyticsManager.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/12/23.
//

import Foundation

public enum SpiralSDKEvent: String {
    case sdkStart = "sdk-start"
    case loadCustomerSettings = "load-customer-settings"
    case loadCustomerSettingsSuccess = "load-customer-settings-success"
    case loadCustomerSettingsError = "load-customer-settings-error"
    case loadGenericContent = "load-generic-content"
    case loadGenericContentSuccess = "load-generic-content-success"
    case loadGenericContentError = "load-generic-content-error"
    case loadModalContent = "load-modal-content"
    case loadModalContentSuccess = "load-modal-content-success"
    case loadModalContentError = "load-modal-content-error"
    case loadTransactionImpact = "load-transaction-impact"
    case loadTransactionImpactSuccess = "load-transaction-impact-success"
    case loadTransactionImpactError = "load-transaction-impact-error"
    case loadTransactionsImpactList = "load-transactions-impact-list"
    case loadTransactionsImpactListSuccess = "load-transactions-impact-list-success"
    case loadTransactionsImpactListError = "load-transactions-impact-list-error"
}

public class SpiralAnalyticsManager {
    static let shared = SpiralAnalyticsManager()
    
    static let timerInterval: TimeInterval = 60
    
    var timer: Timer?
    
    init() {
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] notification in
            self?.uploadEvents()
            self?.resetTimer()

        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] notification in
            self?.uploadEvents()
            self?.resetTimer()

        }
        
        resetTimer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: SpiralAnalyticsManager.timerInterval,
                                     target: self,
                                     selector: #selector(uploadEvents),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    public func trackEvents(events: [SpiralAnalyticsEvent]) {
        SpiralAnalyticsDataStore.shared.addEvents(events: events)
    }
    
    public func trackEvent(event: SpiralAnalyticsEvent) {
        trackEvents(events: [event])
    }
    
    var isCurrentlyUploading = false
    
    @objc public func uploadEvents() {
        guard !isCurrentlyUploading else { return }
        
        let events = SpiralAnalyticsDataStore.shared.getEvents()
        guard !events.isEmpty else { return }
        
        isCurrentlyUploading = true
        
        Spiral.shared.trackAnalyticsEvents(events: events) { [weak self] isSuccess, _ in
            if isSuccess {
                // Delete the events from the data store
                SpiralAnalyticsDataStore.shared.deleteEvents(events: events)
            }
            self?.isCurrentlyUploading = false
        }
    }
}
