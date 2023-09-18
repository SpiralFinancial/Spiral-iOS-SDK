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
    case startFlow = "start_flow"
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
    
    public func trackEvents(events: [SpiralAnalyticsEvent]) {
        SpiralAnalyticsDataStore.shared.addEvents(events: events)
    }
    
    public func trackEvent(event: SpiralAnalyticsEvent) {
        trackEvents(events: [event])
    }
    
    private func uploadEvents() {
        
    }
}
