//
//  CommodityRowView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SFSafeSymbols
import SwiftUI

struct CommodityRowView: View {
    var commodityListRow: CommodityListRow
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(commodityListRow.commodity.name).font(.title3).bold()
                
                HStack(alignment: .bottom, spacing: 0) {
                    Text(commodityListRow.lowestPrice.descriptionWithCurrency())
                        .font(.title3).padding(.trailing, 4)
                    Text(commodityListRow.mostInexpensiveShop.name)
                }.padding(.top, 4)
                
                HStack(alignment: .bottom, spacing: 0) {
                    Spacer()
                    Text("最後に買った日").font(.caption).padding(.trailing, 4)
                    Text(commodityListRow.lastPurchaseDate.dateString())
                        .font(.caption)
                }
            }
            Image(systemSymbol: SFSafeSymbols.SFSymbol.chevronRight)
        }
    }
}

struct CommodityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommodityRowView(commodityListRow: CommodityListRow(
            commodity: Commodity(name: "納豆"), lowestPrice: 100, mostInexpensiveShop: Shop(name: "タイラヤ"), lastPurchaseDate: Date()
        ))
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
