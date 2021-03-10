//
//  CommodityRowView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct CommodityRowView: View {
    var commodity: CommodityListRow
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                
                Text(commodity.name).font(.headline)
                HStack() {
                    Spacer()
                    Text(commodity.mostInexpensiveStore)
                    Text(commodity.lowestPrice.descriptionWithCurrency())
                }
            }
        }
    }
}

struct CommodityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommodityRowView(commodity: CommodityListRow(
            name: "納豆", lowestPrice: 100, mostInexpensiveStore: "タイラヤ"
        ))
    }
}
