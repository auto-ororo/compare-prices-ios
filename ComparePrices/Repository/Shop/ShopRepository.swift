//
//  StoreRepository.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/07.
//

import Combine
import Foundation

protocol ShopRepository {
    func addShop(_ shop: Shop) -> Future<Void, Error>
    
    func updateShop(_ shop: Shop) -> Future<Void, Error>
    
    func deleteShop(_ shop: Shop) -> Future<Void, Error>

    func getShop(_ shopId: UUID) -> Future<Shop, Error>
    
    func getShop(_ name: String) -> Future<Shop?, Error>
    
    func getAllShops() -> Future<[Shop], Error>
    
    func observeAllShops() -> AnyPublisher<[Shop], Error>
}
