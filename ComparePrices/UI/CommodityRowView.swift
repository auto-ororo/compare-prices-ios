//
//  CommodityRowView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct CommodityRowView: View {
    var commodity: Commodity
    
    var onDeleteButtonTapped: () -> Void
    var onRowTapped: () -> Void

    var body: some View {
        HStack() {
            Button(action: onRowTapped, label: {
                VStack(alignment: .leading) {
                    
                    Text(commodity.name).font(.headline)
                    HStack() {
                        Spacer()
                        Text(commodity.store)
                        Text(commodity.price.descriptionWithCurrency())
                    }
                }
            }).buttonStyle(PlainButtonStyle())
            Button(action: onDeleteButtonTapped, label: {
                Image(systemName: "trash").font(.title2)
            }).buttonStyle(PlainButtonStyle()).padding(8)
        }
        
    }
}

struct CommodityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommodityRowView(commodity: Commodity(
            name: "納豆", price: 100, store: "タイラヤ"
        ), onDeleteButtonTapped: {}, onRowTapped: {})
    }
}
