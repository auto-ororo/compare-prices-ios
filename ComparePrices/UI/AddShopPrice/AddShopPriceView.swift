//
//  AddShopPriceView.swift
//  ComparePrices
//
//  Created by ororo on 2021/04/25.
//

import SwiftUI

struct AddShopPriceView: View {
    @EnvironmentObject var navigation: Navigator

    var commodity: Commodity
    
    @StateObject var viewModel = AddShopPriceViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Header(backButtonAction:
                back,
                title: "店舗・値段設定")
            
            HStack {
                Spacer()
                Text(commodity.name).padding().font(.title)
                Spacer()
            }
            
            HStack {
                Text("購入店").font(.headline).frame(width: 70, alignment: .trailing)
                Button(action: { viewModel.showStoreSheet.toggle() }, label: {
                    Text(viewModel.selectedShop?.name ?? "選択して下さい").foregroundColor(.gray).padding(8).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }).padding()
            }
            InputPriceLayout(label: "価格", bindingPrice: $viewModel.price)
            Spacer()
            SubmitButton(text: "店舗・値段を追加", action: { viewModel.addShopPrice(commodity: commodity) }, isActive: viewModel.isButtonEnabled).padding()
            
        }.onReceive(viewModel.finishedAddShopPrice) {
            back()
        }
        .sheet(isPresented: $viewModel.showStoreSheet) {
            SelectShopSheetView(isPresent: $viewModel.showStoreSheet, selectedShop: $viewModel.selectedShop)
        }
    }
    
    private func back() {
        let lastView = navigation.getLastStack().moveTo
        
        if lastView != .commodityDetail(commodity) {
            navigation.navigate(to: .commodityList, direction: .back)
        } else {
            navigation.navigate(to: .commodityDetail(commodity), direction: .back)
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

struct AddShopPriceView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        return AddShopPriceView(commodity: Commodity(id: MockCommodityRepository.asparaUUID, name: "アスパラ"))
    }
}
