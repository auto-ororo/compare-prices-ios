//
//  MockPurchaseResultRepository.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import Combine
import Foundation

final class MockPurchaseResultRepository: PurchaseResultRepository {
    private class SingletonPurchaseResults {
        static let shared = SingletonPurchaseResults()
        
        @Published var commoditiyPrices: [PurchaseResult] = [
            PurchaseResult(commodityId: MockCommodityRepository.ninzinUUID, shopId: MockShopRepository.sevenElevenUUID, price: 300),
            PurchaseResult(commodityId: MockCommodityRepository.ninzinUUID, shopId: MockShopRepository.bigAUUID, price: 100),
            PurchaseResult(commodityId: MockCommodityRepository.asparaUUID, shopId: MockShopRepository.bigAUUID, price: 150),
            PurchaseResult(commodityId: MockCommodityRepository.curryUUID, shopId: MockShopRepository.gyomuSuperUUID, price: 170),
            PurchaseResult(commodityId: MockCommodityRepository.hakusaiUUID, shopId: MockShopRepository.gyomuSuperUUID, price: 100),
            PurchaseResult(commodityId: MockCommodityRepository.hakusaiUUID, shopId: MockShopRepository.bigUUID, price: 99),
            PurchaseResult(commodityId: MockCommodityRepository.kyabetsuUUID, shopId: MockShopRepository.bigAUUID, price: 96)
        ]
        
        private init() {}
    }
    
    func addPurchaseResult(_ purchaseResult: PurchaseResult) -> Future<Void, Error> {
        .init { promise in
            SingletonPurchaseResults.shared.commoditiyPrices.append(purchaseResult)
            print("addCommodityPrice Finished")
            promise(.success(()))
        }
    }
    
    func updatePurchaseResult(_ purchaseResult: PurchaseResult) -> Future<Void, Error> {
        .init { promise in
            guard let index = SingletonPurchaseResults.shared.commoditiyPrices.firstIndex(where: { $0.id == purchaseResult.id }) else {
                print("CommodityPrice not found")
                promise(.failure(NSError()))
                return
            }
            
            SingletonPurchaseResults.shared.commoditiyPrices[index] = purchaseResult
            promise(.success(()))
        }
    }
    
    func deletePurchaseResult(_ purchaseResult: PurchaseResult) -> Future<Void, Error> {
        .init { promise in
            guard let index = SingletonPurchaseResults.shared.commoditiyPrices.firstIndex(where: { $0.id == purchaseResult.id }) else {
                print("CommodityPrice not found")
                promise(.failure(NSError()))
                return
            }
            
            var target = purchaseResult
            target.isEnabled = false
            
            SingletonPurchaseResults.shared.commoditiyPrices[index] = target
            promise(.success(()))
        }
    }
    
    func getLowestPricePurchaseResult(_ commodityId: UUID) -> Future<PurchaseResult?, Error> {
        .init { promise in
            let commodityPrice = SingletonPurchaseResults.shared.commoditiyPrices.filter { $0.commodityId == commodityId }.min(by: { $1.price > $0.price })
            promise(.success(commodityPrice))
        }
    }
    
    func getNewestPurchaseResult(_ commodityId: UUID) -> Future<PurchaseResult?, Error> {
        .init { promise in
            let commodityPrice = SingletonPurchaseResults.shared.commoditiyPrices.filter { $0.commodityId == commodityId }.min(by: { $1.purchaseDate < $0.purchaseDate })
            promise(.success(commodityPrice))
        }
    }

    func getPurchaseResults(_ commodityId: UUID) -> Future<[PurchaseResult], Error> {
        .init { promise in
            promise(.success(SingletonPurchaseResults.shared.commoditiyPrices.filter { $0.commodityId == commodityId }))
        }
    }
    
    func observePurchaseResults(_ commodityId: UUID) -> AnyPublisher<[PurchaseResult], Error> {
        SingletonPurchaseResults.shared.$commoditiyPrices.setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getPurchaseResult(_ purchaseResultId: UUID) -> Future<PurchaseResult, Error> {
        .init { promise in
            promise(.success(SingletonPurchaseResults.shared.commoditiyPrices.first { $0.id == purchaseResultId }!))
        }
    }
}
