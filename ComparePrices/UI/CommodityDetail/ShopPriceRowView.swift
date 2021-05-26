//
//  ShopPriceRowView.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/24.
//

import SFSafeSymbols
import SwiftUI

struct ShopPriceRowView: View {
    var shopPrice: ShopPriceListRow
    
    var body: some View {
        HStack {
            Image(systemSymbol: SFSafeSymbols.SFSymbol.crownFill)
                .foregroundColor(getCrownColor()).font(.title3)

            VStack {
                HStack(alignment: .bottom) {
                    Text(shopPrice.shop.name)
                        .foregroundColor(shopPrice.shop.isEnabled ? .primary : .gray)
                        .bold()
                    
                    if !shopPrice.shop.isEnabled {
                        Text("(削除済)").font(.footnote).foregroundColor(.gray)
                    }
                    Spacer()
                }.padding(.bottom, 4)
                HStack(alignment: .bottom, spacing: 0) {
                    Text(shopPrice.price.descriptionWithCurrency()).font(.title3)
                    Spacer()
                    Text(shopPrice.purchaseDate.dateString())
                        .font(.caption)
                }
            }
        }
    }
    
    private func getCrownColor() -> Color {
        switch shopPrice.rank {
        case 1:
            return R.color.gold.color
        case 2:
            return R.color.silver.color
        case 3:
            return R.color.bronze.color
        default:
            return Color.clear
        }
    }
}

struct ShopPriceRowView_Previews: PreviewProvider {
    static var previews: some View {
        ShopPriceRowView(shopPrice: ShopPriceListRow(purchaseResultId: UUID(), rank: 1, shop: Shop(name: "たいらや"), price: 200, purchaseDate: Date()))
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
