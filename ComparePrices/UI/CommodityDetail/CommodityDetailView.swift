//
//  CommodityDetailView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/01.
//

import Foundation
import SwiftUI

struct CommodityDetailView: View {
    @EnvironmentObject var navigator: Navigator
    
    @StateObject var viewModel = CommodityDetailViewModel()
    
    var commodity: Commodity
    
    @State private var targetShopPrice: ShopPriceListRow?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ScreenHeader(backButtonAction: {
                    navigator.navigate(to: .commodityList, direction: .back)
                }, title: commodity.name)

                // 購買履歴
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(viewModel.shopPriceList) { shopPrice in
                            ShopPriceRowView(shopPrice: shopPrice, onTapOption: {
                                targetShopPrice = shopPrice
                            }).padding(.horizontal)
                        }
                    }
                }
            }
            
            // Floating Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddCircleButton(action: {
                        navigator.navigate(to: .addPurchaseResult(commodity), direction: .next)
                    })
                }
            }

        }.onAppear {
            viewModel.observeShopPrices(commodityId: commodity.id)
        }.actionSheet(item: $targetShopPrice) { shopPrice in
            ActionSheet(title: Text("\(shopPrice.shop.name) - \(shopPrice.price.descriptionWithCurrency())"), message: nil, buttons: [
                .destructive(Text(R.string.localizable.commonDelete())) {
                    viewModel.deletePurchaseResult(shopPriceListRow: shopPrice)
                },
                .cancel()
            ])
        }
    }
}

struct CommodityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        return CommodityDetailView(commodity: Commodity(id: MockCommodityRepository.asparaUUID, name: "もやし"))
    }
}
