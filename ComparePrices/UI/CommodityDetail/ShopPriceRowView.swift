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
    
    var onTapOption: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemSymbol: SFSafeSymbols.SFSymbol.crownFill)
                    .foregroundColor(getCrownColor()).font(.title3)

                VStack {
                    HStack(alignment: .top) {
                        HStack(alignment: .bottom) {
                            Text(shopPrice.shop.name).bold()
                            
                            if !shopPrice.shop.isEnabled {
                                Text(R.string.localizable.commonDeleted()).font(.footnote)
                            }
                        }.foregroundColor(shopPrice.shop.isEnabled ? .primary : R.color.elevation.color)
                        Spacer()
                        Text(R.string.localizable.commonOption()).font(.subheadline)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.bottom, 8)
                            .foregroundColor(R.color.elevation.color)
                            .onTapGesture {
                                onTapOption()
                            }
                    }
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(shopPrice.price.descriptionWithCurrency()).font(.title3)
                        Spacer()
                        Text(shopPrice.purchaseDate.dateString())
                            .font(.caption).foregroundColor(R.color.elevation.color)
                    }
                }
            }
            Divider().padding(.top, 4)
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
        ShopPriceRowView(shopPrice: ShopPriceListRow(purchaseResultId: UUID(), rank: 1, shop: Shop(name: "たいらや"), price: 200, purchaseDate: Date()), onTapOption: {})
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
