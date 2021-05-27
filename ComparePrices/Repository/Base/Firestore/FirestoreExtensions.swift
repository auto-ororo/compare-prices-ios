//
//  FirestoreExtensions.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import FirebaseFirestore
import Foundation

extension Firestore {
    private static let versionCode = "v1"
    
    private static var db: Firestore {
        firestore()
    }
    
    static func versionRef() -> DocumentReference {
        db.collection(FirestoreCollections.versions.rawValue).document(versionCode)
    }
    
    static func userDocRef(userId: String) -> DocumentReference {
        versionRef().collection(FirestoreCollections.users.rawValue).document(userId)
    }
    
    static func commodityColRef(userId: String) -> CollectionReference {
        userDocRef(userId: userId).collection(FirestoreCollections.commodities.rawValue)
    }
    
    static func commodityDocRef(userId: String, commodityId: String) -> DocumentReference {
        commodityColRef(userId: userId).document(commodityId)
    }
    
    static func shopColRef(userId: String) -> CollectionReference {
        userDocRef(userId: userId).collection(FirestoreCollections.shops.rawValue)
    }
    
    static func shopDocRef(userId: String, shipId: String) -> DocumentReference {
        shopColRef(userId: userId).document(shipId)
    }
    
    static func purchaseResultColRef(userId: String) -> CollectionReference {
        userDocRef(userId: userId).collection(FirestoreCollections.purchaseResults.rawValue)
    }
    
    static func purchaseResultDocRef(userId: String, purchaseResultId: String) -> DocumentReference {
        purchaseResultColRef(userId: userId).document(purchaseResultId)
    }
}
