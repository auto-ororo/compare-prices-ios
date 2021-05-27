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
        VStack(alignment: .leading) {
            Header(backButtonAction: {
                navigator.navigate(to: .commodityList, direction: .back)
            }, title: commodity.name)
                
            // 購買履歴
            List(viewModel.shopPriceList) { shopPrice in
                ShopPriceRowView(shopPrice: shopPrice)
                    .contentShape(Rectangle())
                    .onLongPressGesture {
                        targetShopPrice = shopPrice
                    }
            }
                
            SubmitButton(text: "買い物登録") {
                navigator.navigate(to: .addPurchaseResult(commodity), direction: .next)
            }.padding()
        }.onAppear {
            viewModel.observeShopPrices(commodityId: commodity.id)
        }.actionSheet(item: $targetShopPrice) { shopPrice in
            ActionSheet(title: Text("\(shopPrice.shop.name) - \(shopPrice.price.descriptionWithCurrency())"), message: nil, buttons: [
                .destructive(Text("削除")) {
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
