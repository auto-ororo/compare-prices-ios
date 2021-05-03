//
//  Commodity.swift

//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/07.
//

import Foundation

struct Commodity: Identifiable, Equatable, Codable {
    var id = UUID()
    var name: String
    var createdAt = Date()
    var updatedAt = Date()
    
    static func == (lhs: Commodity, rhs: Commodity) -> Bool {
        lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.createdAt == rhs.createdAt &&
            lhs.updatedAt == lhs.updatedAt
    }
}
