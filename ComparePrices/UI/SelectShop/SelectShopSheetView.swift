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
    
    @State private var targetShop: Shop?

    var body: some View {
        VStack {
            SheetHeader(title: "店舗選択")
            // 検索欄
            HStack {
                TextField("店舗名を入力", text: $viewModel.searchWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.leading, 8)
                Button(
                    action: {
                        viewModel.addShop()
                    },
                    label: {
                        Text("追加").foregroundColor(R.color.primary.color).font(.headline)
                    }
                ).disabled(!viewModel.isEnabledAddButton).padding(8).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(R.color.primary.color, lineWidth: 2)
                ).padding(.trailing, 8).opacity(viewModel.isEnabledAddButton ? 1.0 : 0.7)
                    
            }
            
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    ForEach(viewModel.filteredShopList) { shop in
                        SelectItemRowView(
                            itemName: shop.name,
                            onTapItem: {
                                viewModel.selectShop(shop: shop)
                            },
                            onTapOption: {
                                targetShop = shop
                            }
                        )
                    }
                }
            }
        }.onAppear {
            viewModel.observeShops()
        }.onReceive(viewModel.shopSelected) { result in
            self.selectedShop = result
            isPresent = false
        }.actionSheet(item: $targetShop) { shop in
            ActionSheet(title: Text(shop.name), message: nil, buttons: [
                .destructive(Text("削除")) {
                    viewModel.deleteShop(shop: shop)
                },
                .cancel()
            ])
        }
    }
}

struct SelectShopView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        
        return SelectShopSheetView(isPresent: .constant(false), selectedShop: .constant(nil))
    }
}
