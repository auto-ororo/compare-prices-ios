//
//  MockCommodityPriceRepository.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import Combine
import Foundation

final class MockCommodityPriceRepository: CommodityPriceRepository {
    private class SingletonCommodities {
        static let shared = SingletonCommodities()
        
        @Published var commoditiyPrices: [CommodityPrice] = [
            CommodityPrice(commodityId: MockCommodityRepository.ninzinUUID, shopId: MockShopRepository.sevenElevenUUID, price: 300),
            CommodityPrice(commodityId: MockCommodityRepository.ninzinUUID, shopId: MockShopRepository.bigAUUID, price: 100),
            CommodityPrice(commodityId: MockCommodityRepository.asparaUUID, shopId: MockShopRepository.bigAUUID, price: 150),
            CommodityPrice(commodityId: MockCommodityRepository.curryUUID, shopId: MockShopRepository.gyomuSuperUUID, price: 170),
            CommodityPrice(commodityId: MockCommodityRepository.hakusaiUUID, shopId: MockShopRepository.gyomuSuperUUID, price: 100),
            CommodityPrice(commodityId: MockCommodityRepository.hakusaiUUID, shopId: MockShopRepository.bigUUID, price: 99),
            CommodityPrice(commodityId: MockCommodityRepository.kyabetsuUUID, shopId: MockShopRepository.bigAUUID, price: 96)
        ]
        
        private init() {}
    }
    
    func addCommodityPrice(_ purchaseResult: CommodityPrice) -> Future<Void, Error> {
        .init { promise in
            SingletonCommodities.shared.commoditiyPrices.append(purchaseResult)
            print("addCommodityPrice Finished")
            promise(.success(()))
        }
    }
    
    func removeCommodityPrice(_ purchaseResult: CommodityPrice) -> Future<Void, Error> {
        Future<Void, Error> { promise in
            guard let index = SingletonCommodities.shared.commoditiyPrices.firstIndex(where: { $0.id == purchaseResult.id }) else {
                print("CommodityPrice not found")
                promise(.failure(NSError()))
                return
            }
            
            SingletonCommodities.shared.commoditiyPrices.remove(at: index)
            promise(.success(()))
        }
    }
    
    func getLowestCommodityPrice(_ commodityId: UUID) -> Future<CommodityPrice?, Error> {
        Future<CommodityPrice?, Error> { promise in
            let commodityPrice = SingletonCommodities.shared.commoditiyPrices.filter { $0.commodityId == commodityId }.min(by: { $1.price > $0.price })
            promise(.success(commodityPrice))
        }
    }
    
    func getAllCommodityPrices() -> Future<[CommodityPrice], Error> {
        .init { promise in
            promise(.success(SingletonCommodities.shared.commoditiyPrices))
        }
    }
    
    func getCommodityPrices(_ commodityId: UUID) -> Future<[CommodityPrice]?, Error> {
        .init { promise in
            promise(.success(SingletonCommodities.shared.commoditiyPrices.filter { $0.commodityId == commodityId }))
        }
    }
    
    func observeCommodityPrices() -> AnyPublisher<[CommodityPrice], Error> {
        SingletonCommodities.shared.$commoditiyPrices.tryMap { $0 }.eraseToAnyPublisher()
    }
}
