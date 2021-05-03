//
//  AuthRepository.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import Combine
import Foundation

protocol AuthRepository {
    func signInAnonymously() -> Future<Void, Error>
    func isAuthenticated() -> Bool
}
