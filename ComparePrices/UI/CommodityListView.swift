//
//  GoodsListView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct CommodityListView: View {
    
    @EnvironmentObject var navigator : Navigator
    
    @StateObject var viewModel: CommodityListViewModel = CommodityListViewModel()
    @State var showDetailView : Bool = false
    @State var showAddView : Bool = false
    
    var body: some View {
        ZStack() {
            VStack {
                Header(title: "商品リスト")
                
                // 検索欄
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.blue).padding(8)
                    TextField("商品名を入力",text: $viewModel.searchWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding(.horizontal, 8)
                
                // 品物リスト
                List(viewModel.filteredCommodityList) { commodityListRow in
                    Button(action: {
                        navigator.navigate(to: .commodityDetail(commodityListRow.commodity), direction: .next)
                    },
                    label: {
                        CommodityRowView(commodityListRow: commodityListRow)
                    })
                }.listStyle(PlainListStyle())
            }
            
            // Floating Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddCircleButton(action: {
                        navigator.navigate(to: .addCommodity, direction: .next)
                    })
                }
            }
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
