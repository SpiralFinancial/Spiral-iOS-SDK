//
//  TableColumnMarkup.swift
//  
//
//  Created by https://zhgchg.li on 2023/3/9.
//

import Foundation

final class TableColumnMarkup: Markup {
    
    let spacing: Int
    let fixedMaxLength: Int?
    let isHeader: Bool
    init(isHeader: Bool, fixedMaxLength: Int?, spacing: Int) {
        self.isHeader = isHeader
        self.fixedMaxLength = fixedMaxLength
        self.spacing = spacing
    }
    
    weak var parentMarkup: Markup? = nil
    var childMarkups: [Markup] = []
    
    func accept<V>(_ visitor: V) -> V.Result where V : MarkupVisitor {
        return visitor.visit(self)
    }
}
