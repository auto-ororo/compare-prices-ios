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
        VStack(spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(commodityListRow.commodity.name).font(.title3).bold()
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(commodityListRow.lowestPrice.descriptionWithCurrency())
                                .font(.title2).padding(.trailing, 4)
                            Text(commodityListRow.mostInexpensiveShop.name).font(.subheadline)
                        }

                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("最後購入日").font(.caption)
                            Text(commodityListRow.lastPurchaseDate.dateString())
                                .font(.caption)
                        }.foregroundColor(R.color.elevation.color)
                    }
                }.contentShape(Rectangle())
                Image(systemSymbol: SFSafeSymbols.SFSymbol.chevronRight)
                    .foregroundColor(R.color.elevation.color)
            }
            Divider()
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
