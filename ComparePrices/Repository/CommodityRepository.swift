//
//  CommodityRepository.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/22.
//

import Foundation
import Combine


protocol CommodityRepository{

    func addCommodity(_ commodity:Commodity) -> Future<Void, Error>
    
    func removeCommodity(_ commodity:Commodity) -> Future<Void, Error>

    func observeCommodities() -> AnyPublisher<[Commodity], Error>
    
    func getCommodities() -> Future<[Commodity], Error>
}

final class MockCommodityRepository : CommodityRepository {
    
    private class SingletonCommodities {
        static let shared = SingletonCommodities()
        
        @Published var commodities: [Commodity] = [
            Commodity(name: "にんじん", price: 100, store: "タイラヤ"),
            Commodity(name: "じゃがいも", price: 48, store: "ベルク"),
            Commodity(name: "玉ねぎ", price: 50, store: "ベルク"),
            Commodity(name: "そば", price: 18, store: "業務スーパー"),
            Commodity(name: "りんごジャムりんごジャムりんごジャムりんごジャムりんごジャムりんごジャム", price: 500, store: "成城石井"),
            Commodity(name: "はくさい1/4", price: 98, store: "タイラヤ"),
            Commodity(name: "納豆", price: 80, store: "ビッグ・エー"),
            Commodity(name: "カレー粉", price: 80, store: "カッコー"),
            Commodity(name: "片栗粉", price: 80, store: "タイラヤ"),
            Commodity(name: "小麦粉", price: 200, store: "タイラヤ"),
            Commodity(name: "パン粉", price: 150, store: "タイラヤ"),
            Commodity(name: "そば粉", price: 80, store: "タイラヤ"),
            Commodity(name: "小麦粉", price: 200, store: "タイラヤ"),
            Commodity(name: "酒", price: 200, store: "タイラヤ"),
            Commodity(name: "鮭", price: 200, store: "タイラヤ"),
            Commodity(name: "シチュー", price: 200, store: "タイラヤ"),
        ]
        
        private init() {}
    }

    func observeCommodities() -> AnyPublisher<[Commodity], Error> {
        return SingletonCommodities.shared.$commodities.tryMap{ $0 }.eraseToAnyPublisher()
    }
    
    func addCommodity(_ commodity: Commodity) -> Future<Void, Error> {
        return .init {  promise in
            SingletonCommodities.shared.commodities.append(commodity)
            promise(.success(()))
        }
    }
    
    func removeCommodity(_ commodity: Commodity) -> Future<Void, Error> {
        return Future<Void, Error> {  promise in
            guard let index = SingletonCommodities.shared.commodities.firstIndex(where: { $0.id == commodity.id}) else {
                print("not found")
                promise(.failure(NSError()))
                return
            }

            SingletonCommodities.shared.commodities.remove(at: index)
            promise(.success(()))
        }
    }

    func getCommodities() -> Future<[Commodity], Error> {
        return .init {  promise in
            promise(.success(SingletonCommodities.shared.commodities))
        }
    }
}
