//
//  CommodityPrice.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/07.
//

import Foundation

struct CommodityPrice: Codable {
    var id = UUID()
    var commodityId: UUID
    var shopId: UUID
    var price: Int
    var purchaseDate = Date()
    var createdAt = Date()
    var updatedAt = Date()
}
