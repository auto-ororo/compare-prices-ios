//
//  CommodityRowView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct CommodityRowView: View {
    var commodity: Commodity
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                
                Text(commodity.name).font(.headline)
                HStack() {
                    Spacer()
                    Text(commodity.store)
                    Text(commodity.price.descriptionWithCurrency())
                }
            }
        }
    }
}

struct CommodityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommodityRowView(commodity: Commodity(
            name: "納豆", price: 100, store: "タイラヤ"
        ))
    }
}
