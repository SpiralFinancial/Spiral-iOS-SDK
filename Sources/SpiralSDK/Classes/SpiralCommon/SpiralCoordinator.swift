//
//  Coordinator.swift
//
//  Created by Martin Vasilev on 1.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import Foundation

public class SpiralCoordinator: Equatable {
    
    private(set) var childCoordinators: [SpiralCoordinator] = []
    weak var parentCoordinator: SpiralCoordinator?
    
    /// Unique string value, to easily identify a coordinator
    var identifier: String?
    
    init() { }
    
    /// Start The Coordinator !!! SHOULD BE OVERRIDEN IN EACH SUBCLASS !!!
    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    /// Finish The Coordinator !!!
    /// The base class automatically handles memory management:
    ///     - removing `self` from childCoordinator's array of the parent coordinator
    /// Subclasses should provide custom navigation action: pop/dimiss/etc...
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    /// Adds a child coordinator to the current childCoordinators array
    ///
    /// - Parameter coordinator: the coordinator to add
    func addChildCoordinator(_ coordinator: SpiralCoordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    func addOrReplaceChildCoordinator(_ coordinator: SpiralCoordinator) {
        
        let index = childCoordinators.firstIndex { child in
            return type(of: child) == type(of: coordinator)
        }
        
        if let index = index {
            childCoordinators[index] = coordinator
            coordinator.parentCoordinator = self
        } else {
            addChildCoordinator(coordinator)
        }
    }
    
    func addChildCoordinators(_ coordinators: [SpiralCoordinator]) {
        coordinators.forEach { addChildCoordinator($0) }
    }
    
    /// Removes a child coordinator if such exists from the childCoordinators array
    ///
    /// - Parameter coordinator: the coordinator to remove
    func removeChildCoordinator(_ coordinator: SpiralCoordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    /// Removes all child coordinators of a generic type if they exist from the childCoordinators array
    ///
    /// - Parameter type: the type by which the array is filtered
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }
    
    /// Removes all child coordinators from the childCoordinators array
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    
    /// Returns the first parent coordinator of passed type,
    /// with the possibility to search for specific coordinator with desired identifier
    func firstParent<T: SpiralCoordinator>(of type: T.Type, with identifier: String? = nil) -> T? {
        if isCorrectCoordinator(parentCoordinator as? T, with: identifier) {
            return parentCoordinator as? T
        }
        
        return parentCoordinator?.firstParent(of: type, with: identifier)
    }
    
    /// Returns the first child coordinator of passed type, checking the self's child coordinators
    /// with the possibility to search for specific coordinator with desired identifier
    func firstChildCoordinator<T: SpiralCoordinator>(of type: T.Type, with identifier: String? = nil) -> T? {
        for coordinator in childCoordinators {
            if isCorrectCoordinator(coordinator as? T, with: identifier) {
                return coordinator as? T
            }
        }
        
        return nil
    }
    
    /// Returns the first child coordinator of passed type, recursively checking all of the child coordinators children
    /// with the possibility to search for specific coordinator with desired identifier
    func firstChildCoordinatorRecursive<T: SpiralCoordinator>(of type: T.Type, with identifier: String? = nil) -> T? {
        for coordinator in childCoordinators {
            if isCorrectCoordinator(coordinator as? T, with: identifier) {
                return coordinator as? T
            }
            
            if !coordinator.childCoordinators.isEmpty {
                if let matchingCoordinator = coordinator.firstChildCoordinatorRecursive(of: type, with: identifier) {
                    return matchingCoordinator
                }
            }
        }
        
        return nil
    }
    
    /// Check if the given coordinator is not nil (wich means that it is from the correct type),
    /// and than check if the identifier is the correct one
    private func isCorrectCoordinator(_ coordinator: SpiralCoordinator?, with identifier: String?) -> Bool {
        guard let coordinator = coordinator else { return false }
        
        return identifier == nil || coordinator.identifier == identifier
    }
    
    public static func == (lhs: SpiralCoordinator, rhs: SpiralCoordinator) -> Bool {
        return lhs === rhs
    }
}
