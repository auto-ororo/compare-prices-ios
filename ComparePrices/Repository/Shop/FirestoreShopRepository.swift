//
//  FirestoreShopRepository.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/04.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class FirestoreShopRepository: ShopRepository {
    func addShop(_ shop: Shop) -> Future<Void, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.shopDocRef(userId: userId, shipId: shop.id.uuidString).setData(document: shop)
    }
    
    func removeShop(_ shop: Shop) -> Future<Void, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.shopDocRef(userId: userId, shipId: shop.id.uuidString).delete()
    }
    
    func getShop(_ shopId: UUID) -> Future<Shop, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.shopDocRef(userId: userId, shipId: shopId.uuidString).getDocument()
    }

    func getShops() -> Future<[Shop], Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.shopColRef(userId: userId).getDocuments()
    }
}