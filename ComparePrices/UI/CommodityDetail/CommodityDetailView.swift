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
    
    var body: some View {
        VStack(alignment: .leading) {
            Header(backButtonAction: {
                navigator.navigate(to: .commodityList, direction: .back)
            }, title: commodity.name)
                
            // 購買履歴
            List(viewModel.shopPriceList) { shopPrice in
                ShopPriceRowView(shopPrice: shopPrice)
            }
                
            SubmitButton(text: "買い物登録") {
                navigator.navigate(to: .addPurchaseResult(commodity), direction: .next)
            }.padding()
        }.onAppear {
            viewModel.getShopPrices(commodityId: commodity.id)
        }
    }
}

struct CommodityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        return CommodityDetailView(commodity: Commodity(id: MockCommodityRepository.asparaUUID, name: "もやし"))
    }
}
