//
//  GoodsListView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct CommodityListView: View {
    @EnvironmentObject var navigator: Navigator
    
    @StateObject var viewModel = CommodityListViewModel()
    @State var showDetailView: Bool = false
    @State var showAddView: Bool = false
    
    var body: some View {
        VStack {
            Header(title: "底値リスト")
                
            // 検索欄
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.blue).padding(8)
                TextField("商品名を入力", text: $viewModel.searchWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding(.horizontal, 8)
            
            ScrollView(.vertical) {
                ForEach(viewModel.filteredCommodityList) { commodityListRow in
                    CommodityRowView(commodityListRow: commodityListRow)
                        .onTapGesture {
                            navigator.navigate(to: .commodityDetail(commodityListRow.commodity), direction: .next)
                        }
                        .padding(.horizontal).padding(.top)
                }
            }
                
            SubmitButton(text: "買い物登録") {
                navigator.navigate(to: .addPurchaseResult(nil), direction: .next)
            }.padding()
        }.onAppear {
            viewModel.getCommodities()
        }
    }
}

struct CommodityListView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        
        return CommodityListView().environment(\.colorScheme, .light)
    }
}
