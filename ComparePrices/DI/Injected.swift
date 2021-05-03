//
//  Injected.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/22.
//

import Foundation

@propertyWrapper
struct Injected<Dependency> {
    var dependency: Dependency!

    var wrappedValue: Dependency {
        mutating get {
            if dependency == nil {
                let copy: Dependency = DIContainer.shared.resolve(type: Dependency.self)
                self.dependency = copy
            }
            return dependency
        }
        mutating set {
            dependency = newValue
        }
    }
}
