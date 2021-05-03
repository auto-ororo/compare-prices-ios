//
//  MockAuthRepository.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import Combine
import Foundation

final class MockAuthRepository: AuthRepository {
    func signInAnonymously() -> Future<Void, Error> {
        Future { promise in
            promise(.success(()))
        }
    }
    
    func isAuthenticated() -> Bool {
        true
    }
}
