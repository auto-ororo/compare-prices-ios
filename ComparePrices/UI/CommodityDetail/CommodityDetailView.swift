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
        ZStack {
            VStack(alignment: .leading) {
                Header(backButtonAction: {
                    navigator.navigate(to: .commodityList, direction: .back)
                }, title: "詳細")
                
                HStack {
                    Spacer()
                    Text(commodity.name).padding().font(.title)
                    Spacer()
                }
                
                // 品物リスト
                List(viewModel.shopPriceList) { shopPrice in
                    HStack {
                        Text(shopPrice.rank.description)
                        Text(shopPrice.shop.name)
                            .foregroundColor(shopPrice.shop.isEnabled ? .black : .gray)
                        Spacer()
                        Text(shopPrice.price.descriptionWithCurrency())
                    }
                }.listStyle(PlainListStyle())
            }
            
            // Floating Button
            VStack(alignment: .center) {
                Spacer()
                HStack {
                    Spacer()
                    AddCircleButton(action: {
                        navigator.navigate(to: .addPurchaseResult(commodity), direction: .next)
                    })
                }
            }
            
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
