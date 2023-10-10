//
//  UIView+Analytics.swift
//  SpiralBank
//
//  Created by Ron Soffer on 1/13/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

private var spiralAnalyticsIdentifierKey: Void?
private var spiralAnalyticsViewStartTimeKey: Void?
private var spiralAnalyticsFlowIdentifierKey: Void?

extension UIView {
    
    @objc var showLogViewEvent: Bool { true }
    
    // class level
    @objc var spiralAnalyticsIdentifierForClass: String? {
        return nil
    }
    
    // swiftlint:disable implicit_getter superfluous_disable_command
    @objc var spiralAnalyticsIdentifier: String? {
        get {
            let identifier = objc_getAssociatedObject(self, &spiralAnalyticsIdentifierKey) as? String
            // if not available, use class level (also if available)
            return identifier ?? spiralAnalyticsIdentifierForClass
        }
        set {
            objc_setAssociatedObject(self, &spiralAnalyticsIdentifierKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // swiftlint:disable implicit_getter superfluous_disable_command
    @objc var spiralAnalyticsFlowIdentifier: String? {
        get {
            let identifier = objc_getAssociatedObject(self, &spiralAnalyticsFlowIdentifierKey) as? String
            // if not available, use class level (also if available)
            return identifier
        }
        set {
            objc_setAssociatedObject(self, &spiralAnalyticsFlowIdentifierKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @objc private var spiralAnalyticsViewStartTime: TimeInterval {
        get {
            return (objc_getAssociatedObject(self, &spiralAnalyticsViewStartTimeKey) as? TimeInterval) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &spiralAnalyticsViewStartTimeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var spiralAnalyticsViewTime: TimeInterval {
        return Date().timeIntervalSince1970 - spiralAnalyticsViewStartTime
    }
    
    @objc var fullSpiralAnalyticsIdentifier: String {
        var prefix: String = .empty
        if let superviewIdentifier = superview?.fullSpiralAnalyticsIdentifier {
            prefix = superviewIdentifier
        }
        
        var fullIdentifier = prefix
        if let spiralAnalyticsIdentifier = spiralAnalyticsIdentifier {
            fullIdentifier += (fullIdentifier.count > 0 ? "." : "") + spiralAnalyticsIdentifier
        }
        
        return fullIdentifier
    }
    
    @objc func handleAnalyticsTapEvent() {
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(event: "\(fullSpiralAnalyticsIdentifier).click", properties: [:]))
    }
    
    func addAnalyticsTapHandling(identifier: String? = nil) {
        if let identifier = identifier {
            spiralAnalyticsIdentifier = identifier
        }
        
        // Don't add more than once
        gestureRecognizers?.removeAll(where: { (gr) -> Bool in
            return gr.name == Constants.spiralAnalyticsTapGestureRecognizerName
        })
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleAnalyticsTapEvent))
        gestureRecognizer.name = Constants.spiralAnalyticsTapGestureRecognizerName
        gestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(gestureRecognizer)
    }
    
    func startTrackingViewTime() {
        spiralAnalyticsViewStartTime = Date().timeIntervalSince1970
    }
    
}

extension UIButton {
    @objc override var spiralAnalyticsIdentifier: String? {
        get {
            // Use button title if not available
            return super.spiralAnalyticsIdentifier ?? title(for: .normal)?.formattedForAnalytics
        }
        set {
            super.spiralAnalyticsIdentifier = newValue
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
        spiralAnalyticsIdentifier = identifier
        addTarget(self, action: #selector(handleAnalyticsFocusEvent), for: .editingDidBegin)
    }
    
    @objc func handleAnalyticsFocusEvent() {
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(event: "\(fullSpiralAnalyticsIdentifier).focus", properties: [:]))
    }
    
    func addAnalyticsTypedHandling() {
        addTarget(self, action: #selector(handleAnalyticsTypedEvent), for: .editingChanged)
    }
    
    @objc func handleAnalyticsTypedEvent() {
        SpiralAnalyticsManager.shared.trackEvent(event: SpiralAnalyticsEvent(event: "\(fullSpiralAnalyticsIdentifier).types", properties: ["text": AnyCodable(text ?? .empty)]))
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
    static let spiralAnalyticsTapGestureRecognizerName = "spiralAnalyticsTapGesture"
}
