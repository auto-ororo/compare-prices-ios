//
//  ShopPriceListRow.swift
//  ComparePrices
//
//  Created by ororo on 2021/04/24.
//

import Foundation

struct ShopPriceListRow: Identifiable {
    var id = UUID()
    var rank : Int
    var shop: Shop
    var price: Int
}
