//
//  Observable.swift
//  TwoWayBondage
//
//

import Foundation

class Observable<ObservedType> {
    typealias Observer = (ObservedType) -> Void
    
    private var observers: [Observer]
    
    var value: ObservedType? {
        didSet {
            if let value = value {
                notifyObservers(value)
            }
        }
    }
    
    init(_ value: ObservedType? = nil) {
        self.value = value
        observers = []
    }
    
    func bind(observer: @escaping Observer) {
        self.observers.append(observer)
    }
    
    func bind<T: AnyObject>(_ object: T, observer: @escaping (T, ObservedType) -> Void) {
        observers.append({ [weak object] value in
            guard let object = object else { return }
            observer(object, value)
        })
    }
    
    func bindAndFire(observer: @escaping Observer) {
        bind(observer: observer)
        if let value = value {
           observer(value)
        }
    }
    
    func bindAndFire<T: AnyObject>(_ object: T, observer: @escaping (T, ObservedType) -> Void) {
        bind(object, observer: observer)
        if let value = value {
            observer(object, value)
        }
    }
    
    func bindAndFireAll(observer: @escaping Observer) {
        bind(observer: observer)
        if let value = value {
            notifyObservers(value)
        }
    }
    
    func bindAndFireAll<T: AnyObject>(_ object: T, observer: @escaping (T, ObservedType) -> Void) {
        bind(object, observer: observer)
        if let value = value {
            notifyObservers(value)
        }
    }
    
    private func notifyObservers(_ value: ObservedType) {
        self.observers.forEach { (observer) in
            observer(value)
        }
    }
}
