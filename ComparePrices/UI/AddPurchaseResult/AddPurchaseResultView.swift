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
            Header(backButtonAction:
                back,
                title: "買い物登録")
            
            HStack {
                Text("商品").font(.headline).frame(width: 70, alignment: .trailing)
                Button(action: { viewModel.showSelectCommoditySheet() }, label: {
                    Text(viewModel.selectedCommodity?.name ?? "選択して下さい").foregroundColor(.gray).padding(8).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }).padding().disabled(commodity != nil)
            }
            
            HStack {
                Text("購入店").font(.headline).frame(width: 70, alignment: .trailing)
                Button(action: { viewModel.showSelectShopSheet() }, label: {
                    Text(viewModel.selectedShop?.name ?? "選択して下さい").foregroundColor(.gray).padding(8).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }).padding()
            }
            
            HStack {
                Text("価格").font(.headline).frame(width: 70, alignment: .trailing)
                TextField("価格", text: $viewModel.priceString)
                    .keyboardType(.numberPad).padding().textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Text("購入日時").font(.headline).frame(width: 70, alignment: .trailing)
                DatePicker("", selection: $viewModel.purchaseDate).labelsHidden().padding()
            }
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
