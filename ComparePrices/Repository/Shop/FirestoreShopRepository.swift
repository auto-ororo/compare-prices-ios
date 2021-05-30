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
        setShop(shop)
    }
    
    func updateShop(_ shop: Shop) -> Future<Void, Error> {
        setShop(shop)
    }
    
    func deleteShop(_ shop: Shop) -> Future<Void, Error> {
        var target = shop
        target.isEnabled = false
        return setShop(target)
    }
    
    private func setShop(_ shop: Shop) -> Future<Void, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.shopDocRef(userId: userId, shipId: shop.id.uuidString).setData(document: shop)
    }
    
    func getShop(_ shopId: UUID) -> Future<Shop, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.shopDocRef(userId: userId, shipId: shopId.uuidString).getDocument()
    }
    
    func getShop(_ name: String) -> Future<Shop?, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.shopColRef(userId: userId)
            .whereField("isEnabled", isEqualTo: true)
            .whereField("name", isEqualTo: name).getDocument()
    }

    func getAllShops() -> Future<[Shop], Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.shopColRef(userId: userId).getDocuments()
    }
    
    func observeAllShops() -> AnyPublisher<[Shop], Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.shopColRef(userId: userId).observeDocuments()
    }
    
    func observeShops() -> AnyPublisher<[Shop], Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.shopColRef(userId: userId)
            .whereField("isEnabled", isEqualTo: true)
            .observeDocuments()
    }
}
