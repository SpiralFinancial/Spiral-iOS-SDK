//
//  UIView+Analytics.swift
//  SpiralBank
//
//  Created by Ron Soffer on 1/13/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

private var analyticsIdentifierKey: Void?
private var analyticsViewStartTimeKey: Void?
private var analyticsFlowIdentifierKey: Void?

extension UIView {
    
    @objc var showLogViewEvent: Bool { true }
    
    // class level
    @objc var analyticsIdentifierForClass: String? {
        return nil
    }
    
    // swiftlint:disable implicit_getter superfluous_disable_command
    @objc var analyticsIdentifier: String? {
        get {
            let identifier = objc_getAssociatedObject(self, &analyticsIdentifierKey) as? String
            // if not available, use class level (also if available)
            return identifier ?? analyticsIdentifierForClass
        }
        set {
            objc_setAssociatedObject(self, &analyticsIdentifierKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // swiftlint:disable implicit_getter superfluous_disable_command
    @objc var analyticsFlowIdentifier: String? {
        get {
            let identifier = objc_getAssociatedObject(self, &analyticsFlowIdentifierKey) as? String
            // if not available, use class level (also if available)
            return identifier
        }
        set {
            objc_setAssociatedObject(self, &analyticsFlowIdentifierKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @objc private var analyticsViewStartTime: TimeInterval {
        get {
            return (objc_getAssociatedObject(self, &analyticsViewStartTimeKey) as? TimeInterval) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &analyticsViewStartTimeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var analyticsViewTime: TimeInterval {
        return Date().timeIntervalSince1970 - analyticsViewStartTime
    }
    
    @objc var fullAnalyticsIdentifier: String {
        var prefix: String = .empty
        if let superviewIdentifier = superview?.fullAnalyticsIdentifier {
            prefix = superviewIdentifier
        }
        
        var fullIdentifier = prefix
        if let analyticsIdentifier = analyticsIdentifier {
            fullIdentifier += (fullIdentifier.count > 0 ? "." : "") + analyticsIdentifier
        }
        
        return fullIdentifier
    }
    
    @objc func handleAnalyticsTapEvent() {
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(event: "\(fullAnalyticsIdentifier).click", properties: [:]))
    }
    
    func addAnalyticsTapHandling(identifier: String? = nil) {
        if let identifier = identifier {
            analyticsIdentifier = identifier
        }
        
        // Don't add more than once
        gestureRecognizers?.removeAll(where: { (gr) -> Bool in
            return gr.name == Constants.analyticsTapGestureRecognizerName
        })
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleAnalyticsTapEvent))
        gestureRecognizer.name = Constants.analyticsTapGestureRecognizerName
        gestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(gestureRecognizer)
    }
    
    func startTrackingViewTime() {
        analyticsViewStartTime = Date().timeIntervalSince1970
    }
    
}

extension UIButton {
    @objc override var analyticsIdentifier: String? {
        get {
            // Use button title if not available
            return super.analyticsIdentifier ?? title(for: .normal)?.formattedForAnalytics
        }
        set {
            super.analyticsIdentifier = newValue
            addAnalyticsTapHandling()
        }
    }
    
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        addAnalyticsTapHandling()
//    }
}

extension UITextField {
    func addAnalyticsHandling(identifier: String) {
        analyticsIdentifier = identifier
        addTarget(self, action: #selector(handleAnalyticsFocusEvent), for: .editingDidBegin)
    }
    
    @objc func handleAnalyticsFocusEvent() {
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(event: "\(fullAnalyticsIdentifier).focus", properties: [:]))
    }
    
    func addAnalyticsTypedHandling() {
        addTarget(self, action: #selector(handleAnalyticsTypedEvent), for: .editingChanged)
    }
    
    @objc func handleAnalyticsTypedEvent() {
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(event: "\(fullAnalyticsIdentifier).types", properties: ["text": AnyCodable(text ?? .empty)]))
    }
}

extension String {
    var formattedForAnalytics: String {
        hyphenCased
    }
    
    var hyphenCased: String {
        replacingOccurrences(of: " ", with: "-").replacingOccurrences(of: "_", with: "-").lowercased()
    }
}

fileprivate extension Constants {
    static let analyticsTapGestureRecognizerName = "analyticsTapGesture"
}
