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
                title: "購買履歴を登録")
            
            HStack {
                Text("商品").font(.headline).frame(width: 70, alignment: .trailing)
                Button(action: { viewModel.showCommoditySheet.toggle() }, label: {
                    Text(viewModel.selectedCommodity?.name ?? "選択して下さい").foregroundColor(.gray).padding(8).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }).padding().disabled(commodity != nil)
            }
            
            HStack {
                Text("購入店").font(.headline).frame(width: 70, alignment: .trailing)
                Button(action: { viewModel.showShopSheet.toggle() }, label: {
                    Text(viewModel.selectedShop?.name ?? "選択して下さい").foregroundColor(.gray).padding(8).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }).padding()
            }
            InputPriceLayout(label: "価格", bindingPrice: $viewModel.price)
            Spacer()
            SubmitButton(text: "登録", action: { viewModel.addPurchaseResult() }, isActive: viewModel.isButtonEnabled).padding()
            
        }.onReceive(viewModel.finishedAddShopPrice) {
            back()
        }
        .onAppear {
            viewModel.setSelectedCommodityIfParamExists(commodity: commodity)
        }
        .sheet(isPresented: $viewModel.showCommoditySheet) {
            SelectCommoditySheetView(isPresent: $viewModel.showCommoditySheet, selectedCommodity: $viewModel.selectedCommodity, isNew: $viewModel.isNewCommodity)
        }
        .sheet(isPresented: $viewModel.showShopSheet) {
            SelectShopSheetView(isPresent: $viewModel.showShopSheet, selectedShop: $viewModel.selectedShop, isNew: $viewModel.isNewShop)
        }
    }
    
    private func back() {
        if let commodity = self.commodity {
            navigation.navigate(to: .commodityDetail(commodity), direction: .back)
        } else {
            navigation.navigate(to: .commodityList, direction: .back)
        }
    }
    
    private struct InputTextLayout: View {
        var label: String
        
        var bindingText: Binding<String>
        
        var body: some View {
            HStack {
                Text(label).font(.headline).frame(width: 70, alignment: .trailing)
                TextField("", text: bindingText).padding().textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
    
    private struct InputPriceLayout: View {
        var label: String
        
        var bindingPrice: Binding<Int?>
        
        var body: some View {
            HStack {
                Text(label).font(.headline).frame(width: 70, alignment: .trailing)
                TextField("価格", value: bindingPrice, formatter: NumberFormatter())
                    .keyboardType(.numbersAndPunctuation).padding().textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}

struct AddPurchaseResultView_Previews: PreviewProvider {
    static var previews: some View {
        AddPurchaseResultView(commodity: nil)
    }
}
