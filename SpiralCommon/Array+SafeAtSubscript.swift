//
//  Array+SafeAtSubscript.swift
//
//  Created by Dimitar V. Petrov on 4.12.19.
//  Copyright © 2019 Upnetix. All rights reserved.
//

import Foundation

extension Array {
    
    subscript(safeAt index: Int) -> Element? {
        guard index < endIndex, index >= startIndex else { return nil }
        return self[index]
    }
    
    /// Removes and returns the first element of the collection which satisfies the
    /// given predicate.
    ///
    /// You can use the predicate to find and remove an element that matches particular criteria.
    ///
    ///     var cookieJar = [CookieProtocol]()
    ///     _ = cookieJar.removeFirst(where: {$0.ingredients.contains("Chocolate")})
    ///
    /// - Parameter predicate: A closure that takes an element as its argument
    ///   and returns a Boolean value that indicates whether the passed element
    ///   represents a match.
    /// - Returns: The first element of the collection for which `predicate` returns
    ///   `true`. If no elements in the collection satisfy the given predicate,
    ///   returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @discardableResult mutating func removeFirst(where predicate: (Element) -> Bool) -> Element? {
        guard let index = firstIndex(where: predicate) else { return nil }
        
        return remove(at: index)
    }
    
}
