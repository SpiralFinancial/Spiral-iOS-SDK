//
//  Constants.swift
//  Skeleton
//
//  Created by Martin Vasilev on 15.11.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import UIKit
// swiftlint:disable nesting
struct Constants {
    
    struct Strings {
        static let connectionIssueTitle = "Connection interrupted"
        static let connectionIssueMessage = "It seems we cannot connect to the internet. Please check your connection and try again."
        static let connectionIssueButton = "Got it, thanks"
        
        static let genericIssueTitle = "Something went wrong"
        static let genericIssueMessage = "Something went wrong and we are looking into it. Please try again and if the issue persists, please contact Spiral support."
        static let genericIssueButton = "Got it, thanks"
    }
    
    struct Styles {
        struct Shadow {
            let shadowColor: CGColor
            let shadowOffset: CGSize
            let shadowRadius: CGFloat
            let shadowOpacity: Float
            
            static let homeSceneCellShadow = Shadow(shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor,
                                                    shadowOffset: CGSize(width: 0, height: 0),
                                                    shadowRadius: CGFloat(3),
                                                    shadowOpacity: Float(0.1))
            
        }
        
        struct Border {
            let borderWidth: CGFloat
            let borderColor: CGColor
            
            static let homeSceneCellBorder = Border(borderWidth: CGFloat(1),
                                                    borderColor: UIColor.battleshipGrey02Opacity.cgColor)
            
        }
        
        struct Corners {
            static let homeSceneCellRadius: CGFloat = 7.2
            static let givingSceneCellRadius: CGFloat = 13
        }
        
        struct Gradient {
            static let from: UIColor = .lavender
            static let to: UIColor = .darkishPink
                    
            static let colors = [from, to]
        }
    }
    
    struct LocaleOverrides {
        static let groupingSeparator = ","
        static let decimalSeparator = "."
        static let currencySymbol = "$"
    }
    
    struct LoadingIndicator {
        static let defaultLoadingIndicatorDelay = 0.5
    }
    
    struct Timeout {
        static let flowLoadingTimeout: TimeInterval = 10
    }
    
    struct ErrorCodes {
        static let unauthorizedCode = 403
        static let maintenanceCode = 504
    }
}
