//
//  UIView+Descendants.swift
//  SpiralBank
//
//  Created by Ron Soffer on 9/17/20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import UIKit

extension UIView {
    func descendants() -> [UIView] {
        return subviews + subviews.flatMap { $0.descendants() }
    }
    
    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
        return descendants().compactMap { $0 as? T }
    }
    
    func superviews() -> [UIView] {
        if let superview = superview {
            return [superview] + superview.superviews()
        }
        return []
    }
    
    func findSuperview<T: UIView>(subclassOf: T.Type) -> T? {
        return superviews().first(where: { $0 is T }) as? T
    }
    
    public func embed(in container: UIView!) {
        translatesAutoresizingMaskIntoConstraints = false
        frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 1, constant: 0).isActive = true
    }
}
