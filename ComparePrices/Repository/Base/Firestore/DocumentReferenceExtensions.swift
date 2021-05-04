//
//  DocumentReferenceExtensions.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

extension DocumentReference {
    func getDocument<T: Codable>(_ source: FirestoreSource = .cache) -> Future<T, Error> {
        .init { [weak self] promise in
            self?.getDocument(source: source) { document, error in
                if let err = error {
                    promise(.failure(err))
                }
                
                let decodedDocument: T
                do {
                    try decodedDocument = document!.data(as: T.self)!
                    promise(.success(decodedDocument))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
    
    func setData<T: Codable>(document: T) -> Future<Void, Error> {
        .init { [weak self] promise in
            let encodedItem: [String: Any]
            do {
                encodedItem = try Firestore.Encoder().encode(document)
            } catch {
                promise(.failure(error))
                return
            }
            self?.setData(encodedItem) { error in
                if let err = error {
                    promise(.failure(err))
                    return
                }
                promise(.success(()))
            }
        }
    }
    
    func delete() -> Future<Void, Error> {
        .init { [weak self] promise in
            self?.delete { error in
                if let err = error {
                    promise(.failure(err))
                    return
                }
                promise(.success(()))
            }
        }
    }
}
