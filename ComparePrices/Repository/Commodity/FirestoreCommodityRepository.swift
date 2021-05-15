//
//  FirestoreCommodityRepository.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class FirestoreCommodityRepository: CommodityRepository {
    func addCommodity(_ commodity: Commodity) -> Future<Void, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.commodityDocRef(userId: userId, commodityId: commodity.id.uuidString).setData(document: commodity)
    }
    
    func removeCommodity(_ commodity: Commodity) -> Future<Void, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.commodityDocRef(userId: userId, commodityId: commodity.id.uuidString).delete()
    }
    
    func getCommodities() -> Future<[Commodity], Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.commodityColRef(userId: userId).getDocuments()
    }
    
    func getCommodity(id: UUID) -> Future<Commodity?, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.commodityColRef(userId: userId).whereField("id", isEqualTo: id.uuidString).getDocument()
    }
    
    func getCommodity(name: String) -> Future<Commodity?, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.commodityColRef(userId: userId).whereField("name", isEqualTo: name).getDocument()
    }
}
