//
//  PurchaseResultRepository .swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/07.
//

import Combine
import Foundation

protocol PurchaseResultRepository {
    func addPurchaseResult(_ purchaseResult: PurchaseResult) -> Future<Void, Error>
    
    func updatePurchaseResult(_ purchaseResult: PurchaseResult) -> Future<Void, Error>
    
    func deletePurchaseResult(_ purchaseResult: PurchaseResult) -> Future<Void, Error>
    
    func getLowestPricePurchaseResult(_ commodityId: UUID) -> Future<PurchaseResult?, Error>
    
    func getNewestPurchaseResult(_ commodityId: UUID) -> Future<PurchaseResult?, Error>
    
    func getPurchaseResults(_ commodityId: UUID) -> Future<[PurchaseResult], Error>
    
    func observePurchaseResults(_ commodityId: UUID) -> AnyPublisher<[PurchaseResult], Error>

    func getPurchaseResult(_ purchaseResultId: UUID) -> Future<PurchaseResult, Error>
}
