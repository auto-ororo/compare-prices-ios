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
    
    @State private var targetCommodity: Commodity?

    var body: some View {
        VStack {
            SheetHeader(title: R.string.localizable.selectCommoditySheetTitle())
            // 検索欄
            HStack {
                TextField(R.string.localizable.selectCommoditySheetInputHint(), text: $viewModel.searchWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.leading, 8)
                Button(
                    action: {
                        viewModel.addCommodity()
                    },
                    label: {
                        Text(R.string.localizable.commonAdd()).foregroundColor(R.color.primary.color).font(.headline)
                    }
                ).disabled(!viewModel.isEnabledAddButton).padding(8).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(R.color.primary.color, lineWidth: 2)
                ).padding(.trailing, 8).opacity(viewModel.isEnabledAddButton ? 1.0 : 0.7)
            }
            
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    ForEach(viewModel.filteredCommodityList) { commodity in
                        SelectItemRowView(
                            itemName: commodity.name,
                            onTapItem: {
                                viewModel.selectCommodity(commodity: commodity)
                            },
                            onTapOption: {
                                targetCommodity = commodity
                            }
                        )
                    }
                }
            }
        }.onAppear {
            viewModel.observeCommodities()
        }.onReceive(viewModel.commoditySelected) { result in
            self.selectedCommodity = result
            isPresent = false
        }.actionSheet(item: $targetCommodity) { commodity in
            ActionSheet(title: Text(commodity.name), message: nil, buttons: [
                .destructive(Text(R.string.localizable.commonDelete())) {
                    viewModel.deleteCommodity(commodity: commodity)
                },
                .cancel()
            ])
        }
    }
}

struct SelectCommodityView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        
        return SelectCommoditySheetView(isPresent: .constant(false), selectedCommodity: .constant(nil))
    }
}
