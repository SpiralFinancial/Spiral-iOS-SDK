//
//  HorizontalLineMarkup.swift
//  
//
//  Created by https://zhgchg.li on 2023/2/3.
//

import Foundation

final class HorizontalLineMarkup: Markup {
    let dashLength: Int
    
    weak var parentMarkup: Markup? = nil
    var childMarkups: [Markup] = []
    
    init(dashLength: Int) {
        self.dashLength = dashLength
    }
    
    func accept<V>(_ visitor: V) -> V.Result where V : MarkupVisitor {
        return visitor.visit(self)
    }
}
