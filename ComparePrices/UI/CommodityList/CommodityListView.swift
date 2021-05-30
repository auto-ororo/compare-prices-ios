//
//  GoodsListView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SFSafeSymbols
import SwiftUI

struct CommodityListView: View {
    @EnvironmentObject var navigator: Navigator
    
    @StateObject var viewModel = CommodityListViewModel()
    @State var showDetailView: Bool = false
    @State var showAddView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                ScreenHeader(title: R.string.localizable.commodityListTitle())
                    
                // 検索欄
                HStack {
                    Image(systemSymbol: SFSafeSymbols.SFSymbol.magnifyingglass).foregroundColor(.blue).padding(8)
                    TextField(R.string.localizable.commodityListInputHint(), text: $viewModel.searchWord)
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
            }
            
            // Floating Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddCircleButton(action: {
                        navigator.navigate(to: .addPurchaseResult(nil), direction: .next)
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
