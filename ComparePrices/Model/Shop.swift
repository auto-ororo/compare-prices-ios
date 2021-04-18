//
//  Shop.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/07.
//

import Foundation

struct Shop: Identifiable {
    var id = UUID()
    var name: String
    var createdAt : Date = Date()
    var updatedAt : Date = Date()
}
