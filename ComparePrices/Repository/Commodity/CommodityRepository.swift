//
//  CommodityRepository.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/22.
//

import Combine

protocol CommodityRepository {
    func addCommodity(_ commodity: Commodity) -> Future<Void, Error>
    
    func removeCommodity(_ commodity: Commodity) -> Future<Void, Error>

    func getCommodities() -> Future<[Commodity], Error>
}
