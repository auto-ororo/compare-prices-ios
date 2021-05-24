//
//  CommodityListRow.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/31.
//

import Foundation

struct CommodityListRow: Identifiable {
    var id = UUID()
    var commodity: Commodity
    var lowestPrice: Int
    var mostInexpensiveShop: Shop
    var lastPurchaseDate: Date
}
