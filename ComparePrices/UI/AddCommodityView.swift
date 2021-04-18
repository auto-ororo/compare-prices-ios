//
//  AddCommodityView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/28.
//

import SwiftUI

struct AddCommodityView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var viewModel = AddCommodityViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            InputTextLayout(label: "商品名", bindingText: $viewModel.commodityName)
            HStack {
                Text("購入店").font(.headline).frame(width: 70, alignment: .trailing)
                Button (action: { viewModel.showStoreSheet.toggle() }) {
                    Text(viewModel.selectedShop?.name ?? "選択して下さい").foregroundColor(.gray).padding(8).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }.padding()
            }
            InputPriceLayout(label: "価格", bindingPrice: $viewModel.price)
            Spacer()
            SubmitButton(text: "追加",action: {viewModel.addCommotity()} , isActive: viewModel.isButtonEnabled).padding()
        }.onReceive(viewModel.finishedAddCommodity) {
            presentationMode.wrappedValue.dismiss()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("追加")
            }
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationBackButton()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showStoreSheet) {
            SelectShopSheetView(isPresent: $viewModel.showStoreSheet,selectedShop: $viewModel.selectedShop)
        }
    }
    
    private struct InputTextLayout: View {
        
        var label : String
        
        var bindingText: Binding<String>
        
        var body: some View {
            
            HStack {
                Text(label).font(.headline).frame(width: 70, alignment: .trailing)
                TextField("", text: bindingText).padding().textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
    
    private struct InputPriceLayout: View {
        
        var label : String
        
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

struct AddCommodityView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        return AddCommodityView()
    }
}
