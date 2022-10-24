//
//  LinkTextView.swift
//  SpiralBank
//
//  Created by Eric Collom on 8/10/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import UIKit

class LinkTextView: UITextView {
    
    override public var selectedTextRange: UITextRange? {
        didSet {
            if !(selectedTextRange?.isEmpty ?? true) {
                selectedTextRange = nil
                main {
                    if self.isFirstResponder {
                        self.resignFirstResponder()
                    }
                }
            }
        }
    }
}
