//
//  Url+OpenUrl.swift
//
//  Created by Martin Vasilev on 2.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import UIKit

extension URL {
    
    func open(options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
              completion: ((Bool) -> Void)? = nil) {
        UIApplication.shared.open(self,
                                  options: options,
                                  completionHandler: completion)
    }
    
    func canOpen() -> Bool {
        return UIApplication.shared.canOpenURL(self)
    }
    
}
