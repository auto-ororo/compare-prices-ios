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
            ScreenHeader(backButtonAction: back, title: R.string.localizable.addPurchaseResultTitle())

            InputLayout(
                title: R.string.localizable.commonCommodity(),
                content: {
                    if let commodity = self.commodity {
                        Text(commodity.name).padding(.top, 4)
                    } else {
                        HStack {
                            Text(viewModel.selectedCommodity?.name ?? R.string.localizable.addPurchaseResultSelectHint())
                                .foregroundColor(viewModel.selectedCommodity != nil ? .primary : .gray)
                            Spacer()
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.showSelectCommoditySheet()
                            }
                    }
                }
            )
            
            InputLayout(
                title: R.string.localizable.commonShop(),
                content: {
                    HStack {
                        Text(viewModel.selectedShop?.name ?? R.string.localizable.addPurchaseResultSelectHint())
                            .foregroundColor(viewModel.selectedShop != nil ? .primary : .gray)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.showSelectShopSheet()
                    }
                }
            )
            
            InputLayout(
                title: R.string.localizable.commonPrice(),
                content: {
                    HStack {
                        TextField(R.string.localizable.commonZero(), text: $viewModel.priceString).multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad).font(.title3)
                        Text(R.string.localizable.commonCurrency()).font(.subheadline)
                    }
                }
            )
            
            InputLayout(
                title: R.string.localizable.commonPurchaseDate(),
                content: {
                    HStack {
                        Spacer()
                        Text(viewModel.purchaseDate.dateString())
                    }.padding(.top, 4)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.showSelectDateSheet()
                        }
                }
            )

            Spacer()
            
            SubmitButton(text: R.string.localizable.commonRegister(),
                         action: { viewModel.addPurchaseResult() },
                         isActive: viewModel.isButtonEnabled).padding()
            
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
            case .date:
                SelectDateSheetView(title: R.string.localizable.commonPurchaseDate(), isPresent: $viewModel.sheet.isShown, selectedDate: $viewModel.purchaseDate)
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

private struct InputLayout<Content: View>: View {
    var title: String
    
    var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            content
                .padding(.top, 4)
            Divider()
        }.padding()
    }
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
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
