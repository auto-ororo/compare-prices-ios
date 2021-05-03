//
//  AuthRepository.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import Combine
import FirebaseAuth
import Foundation

protocol AuthRepository {
    func signInAnonymously() -> Future<Void, Error>
    func isAuthenticated() -> Bool
}

final class FirebaseAuthRepository: AuthRepository {
    func signInAnonymously() -> Future<Void, Error> {
        Future { promise in
            Auth.auth().signInAnonymously { _, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    func isAuthenticated() -> Bool {
        Auth.auth().currentUser != nil
    }
}

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
