//
//  SelectShopSheetView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/21.
//

import SwiftUI

struct SelectShopSheetView: View {
    @StateObject private var viewModel = SelectShopSheetViewModel()
    
    @Binding var isPresent: Bool
    
    @Binding var selectedShop: Shop?
    
    var body: some View {
        VStack {
            // 検索欄
            HStack {
                TextField("店名を入力", text: $viewModel.searchWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.leading, 8)
                Button(
                    action: {
                        viewModel.addShop()
                    },
                    label: {
                        Text("追加").font(.headline)
                    }
                ).padding(8).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                ).padding(.trailing, 8)
            }.padding(.top, 8)
            
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    ForEach(viewModel.filteredShopList) { shop in
                        HStack {
                            Text(shop.name).font(.title3)
                            Spacer()
                        }.padding(8).contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.selectShop(shop: shop)
                            }
                        Divider()
                    }
                }
            }
        }.onAppear {
            viewModel.getShops()
        }.onReceive(viewModel.shopSelected) { shop in
            self.selectedShop = shop
            isPresent = false
        }
    }
}

struct SelectShopView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        
        return SelectShopSheetView(isPresent: .constant(false), selectedShop: .constant(nil))
    }
}
