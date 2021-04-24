//
//  CommodityRowView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct CommodityRowView: View {
    var commodityListRow: CommodityListRow
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(commodityListRow.commodity.name).font(.headline)
                HStack() {
                    Spacer()
                    Text(commodityListRow.mostInexpensiveShop.name)
                    Text(commodityListRow.lowestPrice.descriptionWithCurrency())
                }
            }
        }
    }
}

struct CommodityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommodityRowView(commodityListRow: CommodityListRow(
            commodity: Commodity(name: "納豆"), lowestPrice: 100, mostInexpensiveShop: Shop(name: "タイラヤ")
        ))
    }
}
