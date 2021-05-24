//
//  CommodityPriceRepository .swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/07.
//

import Combine
import Foundation

protocol CommodityPriceRepository {
    func addCommodityPrice(_ purchaseResult: CommodityPrice) -> Future<Void, Error>
    
    func removeCommodityPrice(_ purchaseResult: CommodityPrice) -> Future<Void, Error>
    
    func getLowestCommodityPrice(_ commodityId: UUID) -> Future<CommodityPrice?, Error>
    
    func getNewestCommodityPrice(_ commodityId: UUID) -> Future<CommodityPrice?, Error>
    
    func getCommodityPrices(_ commodityId: UUID) -> Future<[CommodityPrice], Error>
}
