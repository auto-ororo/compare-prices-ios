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
    func getDocuments<T: Codable>(_ source: FirestoreSource = .cache) -> Future<[T], Error> {
        .init { [weak self] promise in
            self?.getDocuments(source: source) { snapshot, error in
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
    
    func getDocument<T: Codable>(_ source: FirestoreSource = .cache) -> Future<T?, Error> {
        .init { [weak self] promise in
            self?.getDocuments(source: source) { snapshot, error in
                if let err = error {
                    promise(.failure(err))
                }
                if let snapshot = snapshot, !snapshot.isEmpty {
                    let entities: [T] = snapshot.documents.compactMap { document in
                        try? Firestore.Decoder().decode(T.self, from: document.data())
                    }
                    promise(.success(entities.first))
                } else {
                    promise(.success(nil))
                }
            }
        }
    }
    
    func observeDocuments<T: Codable>(_ source: FirestoreSource = .cache) -> AnyPublisher<[T], Error> {
        QuerySnapshotPublisher(self, includeMetadataChanges: false).map { snapshot -> [T] in
            snapshot.documents.compactMap { document in
                try? Firestore.Decoder().decode(T.self, from: document.data())
            }
        }.eraseToAnyPublisher()
    }
}

private struct QuerySnapshotPublisher: Combine.Publisher {
    typealias Output = QuerySnapshot
    typealias Failure = Error

    private let query: Query
    private let includeMetadataChanges: Bool

    init(_ query: Query, includeMetadataChanges: Bool) {
        self.query = query
        self.includeMetadataChanges = includeMetadataChanges
    }

    func receive<S>(subscriber: S) where S: Subscriber, QuerySnapshotPublisher.Failure == S.Failure, QuerySnapshotPublisher.Output == S.Input {
        let subscription = QuerySnapshot.Subscription(subscriber: subscriber, query: query, includeMetadataChanges: includeMetadataChanges)
        subscriber.receive(subscription: subscription)
    }
}

extension QuerySnapshot {
    fileprivate final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == QuerySnapshot, SubscriberType.Failure == Error {
        private var registration: ListenerRegistration?

        init(subscriber: SubscriberType, query: Query, includeMetadataChanges: Bool) {
            registration = query.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
                if let error = error {
                    subscriber.receive(completion: .failure(error))
                } else if let snapshot = snapshot {
                    _ = subscriber.receive(snapshot)
                } else {}
            }
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            registration?.remove()
            registration = nil
        }
    }
    
    public static func defaultMapper<D: Decodable>() -> (DocumentSnapshot) throws -> D? {
        { try $0.data(as: D.self) }
    }
}
