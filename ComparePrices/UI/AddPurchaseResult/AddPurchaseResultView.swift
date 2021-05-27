//
//  AddPurchaseResultView.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/15.
//

import SwiftUI

struct AddPurchaseResultView: View {
    @EnvironmentObject var navigation: Navigator

    @StateObject var viewModel = AddPurchaseResultViewModel()
    
    let commodity: Commodity?
    
    var body: some View {
        VStack(alignment: .leading) {
            Header(backButtonAction: back, title: "買い物登録")
            
            VStack(alignment: .leading, spacing: 8) {
                Text("商品").font(.headline)
                if let commodity = self.commodity {
                    Text(commodity.name).padding(.top, 4)
                } else {
                    Button(action: { viewModel.showSelectCommoditySheet() }, label: {
                        Text(viewModel.selectedCommodity?.name ?? "選択して下さい")
                            .foregroundColor(viewModel.selectedCommodity != nil ? .primary : .gray)
                    }).padding(.top, 4)
                }
                Divider()
            }.padding()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("店舗").font(.headline)
                Button(action: { viewModel.showSelectShopSheet() }, label: {
                    Text(viewModel.selectedShop?.name ?? "選択して下さい")
                        .foregroundColor(viewModel.selectedShop != nil ? .primary : .gray)
                }).padding(.top, 4)
                Divider()
            }.padding()
            
            HStack(alignment: .center) {
                Text("価格").font(.headline)
                VStack {
                    HStack(alignment: .bottom) {
                        TextField("0", text: $viewModel.priceString).multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad).font(.title3)
                        Text("円").font(.subheadline)
                    }
                    Divider().padding(-2)
                }
            }.padding()

            HStack(alignment: .center, spacing: 8) {
                Text("購入日").font(.headline)
                Spacer()
                DatePicker("", selection: $viewModel.purchaseDate, displayedComponents: [.date]).labelsHidden()
            }.padding()
            
            Spacer()
            
            SubmitButton(text: "登録", action: { viewModel.addPurchaseResult() }, isActive: viewModel.isButtonEnabled).padding()
            
        }.onReceive(viewModel.finishedAddShopPrice) {
            back()
        }
        .onAppear {
            viewModel.setSelectedCommodityIfParamExists(commodity: commodity)
        }
        .fullScreenCover(isPresented: $viewModel.sheet.isShown) {
            switch viewModel.sheet.targetItem {
            case .commodity:
                SelectCommoditySheetView(isPresent: $viewModel.sheet.isShown, selectedCommodity: $viewModel.selectedCommodity)
            case .shop:
                SelectShopSheetView(isPresent: $viewModel.sheet.isShown, selectedShop: $viewModel.selectedShop)
            }
        }
        // 画面全体をタップ検知可能にする
        .contentShape(Rectangle())
        // 画面タップ時にキーボードを閉じる
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private func back() {
        if let commodity = self.commodity {
            navigation.navigate(to: .commodityDetail(commodity), direction: .back)
        } else {
            navigation.navigate(to: .commodityList, direction: .back)
        }
    }
}

struct AddPurchaseResultView_Previews: PreviewProvider {
    init() {
        MockModuleInjector().inject()
    }
    
    static var previews: some View {
        AddPurchaseResultView(commodity: nil)
    }
}
