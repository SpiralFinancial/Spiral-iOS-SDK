//
//  SpiralAnalyticsManager.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/12/23.
//

import Foundation

public enum SpiralSDKEvent: String {
    case sdkStart = "sdk_start"
    case loadCustomerSettings = "load_customer_settings"
    case loadCustomerSettingsSuccess = "load_customer_settings_success"
    case loadCustomerSettingsError = "load_customer_settings_error"
    case startFlow = "flow_start"
    case loadGenericContent = "load_generic_content"
    case loadGenericContentSuccess = "load_generic_content_success"
    case loadGenericContentError = "load_generic_content_error"
    case loadModalContent = "load_modal_content"
    case loadModalContentSuccess = "load_modal_content_success"
    case loadModalContentError = "load_modal_content_error"
    case loadTransactionImpact = "load_transaction_impact"
    case loadTransactionImpactSuccess = "load_transaction_impact_success"
    case loadTransactionImpactError = "load_transaction_impact_error"
    case loadTransactionsImpactList = "load_transactions_impact_list"
    case loadTransactionsImpactListSuccess = "load_transactions_impact_list_success"
    case loadTransactionsImpactListError = "load_transactions_impact_list_error"
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
