//
//  Commodity.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/31.
//

import Foundation

struct Commodity: Identifiable {
    var id = UUID()
    var name: String
    var price: Int
    var store: String
}

