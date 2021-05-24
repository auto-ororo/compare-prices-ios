//
//  FirestoreCommodityPriceRepository.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/04.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class FirestoreCommodityPriceRepository: CommodityPriceRepository {
    func addCommodityPrice(_ purchaseResult: CommodityPrice) -> Future<Void, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.commodityPriceDocRef(userId: userId, commodityId: purchaseResult.commodityId.uuidString, priceId: purchaseResult.id.uuidString).setData(document: purchaseResult)
    }
    
    func removeCommodityPrice(_ purchaseResult: CommodityPrice) -> Future<Void, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.commodityPriceDocRef(userId: userId, commodityId: purchaseResult.commodityId.uuidString, priceId: purchaseResult.id.uuidString).delete()
    }
    
    func getLowestCommodityPrice(_ commodityId: UUID) -> Future<CommodityPrice?, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.commodityPriceColRef(userId: userId, commodityId: commodityId.uuidString).order(by: "price").limit(to: 1).getDocument()
    }
    
    func getNewestCommodityPrice(_ commodityId: UUID) -> Future<CommodityPrice?, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.commodityPriceColRef(userId: userId, commodityId: commodityId.uuidString).order(by: "purchaseDate", descending: true).limit(to: 1).getDocument()
    }
    
    func getCommodityPrices(_ commodityId: UUID) -> Future<[CommodityPrice], Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.commodityPriceColRef(userId: userId, commodityId: commodityId.uuidString).getDocuments()
    }
}
