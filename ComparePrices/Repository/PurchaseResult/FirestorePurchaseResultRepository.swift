//
//  FirestorePurchaseResultRepository.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/04.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class FirestorePurchaseResultRepository: PurchaseResultRepository {
    func addPurchaseResult(_ purchaseResult: PurchaseResult) -> Future<Void, Error> {
        setPurchaseResult(purchaseResult)
    }
    
    func updatePurchaseResult(_ purchaseResult: PurchaseResult) -> Future<Void, Error> {
        setPurchaseResult(purchaseResult)
    }
    
    private func setPurchaseResult(_ purchaseResult: PurchaseResult) -> Future<Void, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.purchaseResultDocRef(userId: userId, purchaseResultId: purchaseResult.id.uuidString).setData(document: purchaseResult)
    }
    
    func getLowestPricePurchaseResult(_ commodityId: UUID) -> Future<PurchaseResult?, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.purchaseResultColRef(userId: userId).whereField("commodityId", isEqualTo: commodityId.uuidString)
            .order(by: "price").limit(to: 1).getDocument()
    }
    
    func getNewestPurchaseResult(_ commodityId: UUID) -> Future<PurchaseResult?, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.purchaseResultColRef(userId: userId).whereField("commodityId", isEqualTo: commodityId.uuidString)
            .order(by: "purchaseDate", descending: true).limit(to: 1).getDocument()
    }
    
    func getPurchaseResults(_ commodityId: UUID) -> Future<[PurchaseResult], Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.purchaseResultColRef(userId: userId).whereField("commodityId", isEqualTo: commodityId.uuidString).getDocuments()
    }
    
    func observePurchaseResults(_ commodityId: UUID) -> AnyPublisher<[PurchaseResult], Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.purchaseResultColRef(userId: userId).whereField("commodityId", isEqualTo: commodityId.uuidString).observeDocuments()
    }
    
    func getPurchaseResult(_ purchaseResultId: UUID) -> Future<PurchaseResult, Error> {
        let userId = Auth.auth().currentUser!.uid
        return Firestore.purchaseResultDocRef(userId: userId, purchaseResultId: purchaseResultId.uuidString).getDocument()
    }
}
