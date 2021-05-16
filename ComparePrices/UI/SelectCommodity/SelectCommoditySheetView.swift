//
//  SelectCommoditySheetView.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/16.
//

import SwiftUI

struct SelectCommoditySheetView: View {
    @StateObject private var viewModel = SelectCommoditySheetViewModel()
    
    @Binding var isPresent: Bool
    @Binding var selectedCommodity: Commodity?
    @Binding var isNew: Bool
    
    var body: some View {
        VStack {
            // 検索欄
            HStack {
                TextField("商品を入力", text: $viewModel.searchWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.leading, 8)
                Button(
                    action: {
                        viewModel.selectNewCommodity()
                    },
                    label: {
                        Text("追加").foregroundColor(R.color.primary.color).font(.headline)
                    }
                ).disabled(!viewModel.isEnabledAddButton).padding(8).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(R.color.primary.color, lineWidth: 2)
                ).padding(.trailing, 8).opacity(viewModel.isEnabledAddButton ? 1.0 : 0.7)
                    
            }.padding(.top, 8)
            
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    ForEach(viewModel.filteredCommodityList) { commodity in
                        HStack {
                            Text(commodity.name).font(.title3)
                            Spacer()
                        }.padding(8).contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.selectCommodity(commodity: commodity)
                            }
                        Divider()
                    }
                }
            }
        }.onAppear {
            viewModel.getCommodities()
        }.onReceive(viewModel.commoditySelected) { result in
            self.selectedCommodity = result.commodity
            self.isNew = result.isNew
            isPresent = false
        }
    }
}

struct SelectCommodityView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        
        return SelectCommoditySheetView(isPresent: .constant(false), selectedCommodity: .constant(nil), isNew: .constant(false))
    }
}
