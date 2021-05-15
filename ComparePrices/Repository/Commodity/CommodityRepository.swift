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
    
    func removeCommodity(_ commodity: Commodity) -> Future<Void, Error>

    func getCommodities() -> Future<[Commodity], Error>
    
    func getCommodity(id: UUID) -> Future<Commodity?, Error>
    
    func getCommodity(name: String) -> Future<Commodity?, Error>
}
