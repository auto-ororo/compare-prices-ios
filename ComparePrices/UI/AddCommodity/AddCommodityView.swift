//
//  AddCommodityView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/28.
//

import SwiftUI

struct AddCommodityView: View {
    @EnvironmentObject var navigator: Navigator

    @StateObject var viewModel = AddCommodityViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Header(backButtonAction: {
                navigator.navigate(to: .commodityList, direction: .back)
            }, title: "追加")

            InputTextLayout(label: "商品名", bindingText: $viewModel.commodityName)
            Spacer()
            SubmitButton(text: "商品を追加", action: { viewModel.selectCommodity() }, isActive: viewModel.isButtonEnabled).padding()
        }.onReceive(viewModel.$selectedCommodity) { commodity in
            commodity.map {
                navigator.navigate(to: .addPurchaseResult($0), direction: .next)
            }
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
}

struct AddCommodityView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        return AddCommodityView()
    }
}
