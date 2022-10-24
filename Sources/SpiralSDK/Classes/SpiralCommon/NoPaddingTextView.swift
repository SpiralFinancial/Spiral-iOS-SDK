//
//  NoPaddingTextView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 8/25/20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import Foundation
import UIKit

class NoPaddingTextView: LinkTextView {
    
    override var intrinsicContentSize: CGSize {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        return newSize
    }
    
    // Used to vertically center text when frame is too large
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if contentSize.height < bounds.size.height {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        } else {
            contentInset = .zero
        }
    }
}
