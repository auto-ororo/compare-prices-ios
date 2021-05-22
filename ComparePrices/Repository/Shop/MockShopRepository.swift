//
//  MockShopRepository.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import Combine
import Foundation

final class MockShopRepository: ShopRepository {
    static let tairayaUUID = UUID()
    static let gyomuSuperUUID = UUID()
    static let sevenElevenUUID = UUID()
    static let bigUUID = UUID()
    static let bigAUUID = UUID()

    private class SingletonShops {
        static let shared = SingletonShops()
        
        @Published var shops: [Shop] = [
            Shop(id: tairayaUUID, name: "タイラヤ"),
            Shop(id: gyomuSuperUUID, name: "業務スーパー"),
            Shop(id: sevenElevenUUID, name: "セブンイレブン"),
            Shop(id: bigUUID, name: "ビッグ"),
            Shop(id: bigAUUID, name: "ビッグ・エー")
        ]
        
        private init() {}
    }

    func addShop(_ shop: Shop) -> Future<Void, Error> {
        .init { promise in
            SingletonShops.shared.shops.append(shop)
            promise(.success(()))
        }
    }
    
    func updateShop(_ shop: Shop) -> Future<Void, Error> {
        .init { promise in
            guard let index = SingletonShops.shared.shops.firstIndex(where: { $0.id == shop.id }) else {
                print("shop not found")
                promise(.failure(NSError()))
                return
            }

            SingletonShops.shared.shops[index] = shop
            promise(.success(()))
        }
    }
    
    func getShop(_ shopId: UUID) -> Future<Shop, Error> {
        Future<Shop, Error> { promise in
            guard let shop = SingletonShops.shared.shops.first(where: { $0.id == shopId }) else {
                print("shop not found")
                promise(.failure(NSError()))
                return
            }
            promise(.success(shop))
        }
    }

    func getShops() -> Future<[Shop], Error> {
        .init { promise in
            promise(.success(SingletonShops.shared.shops))
        }
    }
    
    func getShop(_ name: String) -> Future<Shop?, Error> {
        .init { promise in
            promise(.success(SingletonShops.shared.shops.first { $0.name == name }))
        }
    }
    
    func observeShops() -> AnyPublisher<[Shop], Error> {
        SingletonShops.shared.$shops.setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
