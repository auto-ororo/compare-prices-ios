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
    
    static let ninzinUUID = UUID()
    static let zyagaimoUUID = UUID()
    static let tamanegiUUID = UUID()
    static let kyabetsuUUID = UUID()
    static let curryUUID = UUID()
    static let hakusaiUUID = UUID()
    static let naganegiUUID = UUID()
    static let satoimoUUID = UUID()
    static let asparaUUID = UUID()
    static let ringoUUID = UUID()
    static let nattoUUID = UUID()

    private class SingletonCommodities {
        static let shared = SingletonCommodities()
        
        @Published var commodities: [Commodity] = [
            Commodity(id: ninzinUUID,name: "にんじん"),
            Commodity(id: zyagaimoUUID,name: "じゃがいも"),
            Commodity(id: tamanegiUUID,name: "玉ねぎ"),
            Commodity(id: kyabetsuUUID,name: "キャベツ"),
            Commodity(id: curryUUID,name: "カレールー"),
            Commodity(id: hakusaiUUID,name: "白菜"),
            Commodity(id: naganegiUUID,name: "長ネギ"),
            Commodity(id: satoimoUUID,name: "さといも"),
            Commodity(id: asparaUUID,name: "アスパラガス"),
            Commodity(id: ringoUUID, name: "りんご"),
            Commodity(id: nattoUUID, name: "納豆")
        ]
        
        private init() {}
    }

    func observeCommodities() -> AnyPublisher<[Commodity], Error> {
        return SingletonCommodities.shared.$commodities.tryMap{ $0 }.eraseToAnyPublisher()
    }
    
    func addCommodity(_ commodity: Commodity) -> Future<Void, Error> {
        return .init {  promise in
            SingletonCommodities.shared.commodities.append(commodity)
            print("addCommodity finished")
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
