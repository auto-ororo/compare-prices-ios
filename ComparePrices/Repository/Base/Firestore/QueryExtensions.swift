//
//  CollectionReferenceExtensions.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

extension Query {
    func getDocuments<T: Codable>() -> Future<[T], Error> {
        .init { [weak self] promise in
            self?.getDocuments { snapshot, error in
                if let err = error {
                    promise(.failure(err))
                }
                if let snapshot = snapshot, !snapshot.isEmpty {
                    let entities: [T] = snapshot.documents.compactMap { document in
                        try? Firestore.Decoder().decode(T.self, from: document.data())
                    }
                    promise(.success(entities))
                } else {
                    promise(.success([]))
                }
            }
        }
    }
}
