//
//  CommodityRepository.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/22.
//

import Combine
import Foundation

protocol CommodityRepository {
    func addCommodity(_ commodity: Commodity) -> Future<Void, Error>
    
    func updateCommodity(_ commodity: Commodity) -> Future<Void, Error>
    
    func deleteCommodity(_ commodity: Commodity) -> Future<Void, Error>

    func getAllCommodities() -> Future<[Commodity], Error>
    
    func getCommodity(id: UUID) -> Future<Commodity?, Error>
    
    func getCommodity(name: String) -> Future<Commodity?, Error>
    
    func observeAllCommodities() -> AnyPublisher<[Commodity], Error>
    
    func observeCommodities() -> AnyPublisher<[Commodity], Error>
}
