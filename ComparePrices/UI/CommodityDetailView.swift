//
//  CommodityDetailView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/01.
//

import Foundation
import SwiftUI

struct CommodityDetailView: View {
    
    @StateObject var viewModel = CommodityDetailViewModel()
    
    var commodity: Commodity
    
    var body: some View {
        VStack(alignment: .leading) {
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
                    Spacer()
                    Text(shopPrice.price.descriptionWithCurrency())
                }
            }

            Spacer()
        }
        .onAppear{
            viewModel.getShopPrices(commodityId: commodity.id)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("詳細")
            }
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationBackButton()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CommodityDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        MockModuleInjector().inject()
        return CommodityDetailView(commodity: Commodity(id: MockCommodityRepository.asparaUUID,name: "もやし"))
    }
}
