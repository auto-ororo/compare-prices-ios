//
//  GoodsListView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct CommodityListView: View {
    
    @StateObject var viewModel: CommodityListViewModel = CommodityListViewModel()
    @State var showDetailView : Bool = false
    @State var showAddView : Bool = false
    
    // offset変数でメニューを表示・非表示するためのオフセットを保持します
    @State private var searchOffset = CGFloat.zero
    private let searchHeight = CGFloat(60)

    var body: some View {
        GeometryReader { geometry in
            let displaySize = geometry.frame(in: .global)
            ZStack(alignment: .topLeading ) {
                VStack {
                    // 検索欄
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.blue).padding(.leading, 8)
                        TextField("商品名、店名を入力",text: $viewModel.searchWord)
                            .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.trailing, 8)
                    }.frame(width: displaySize.width, height: searchHeight, alignment: .center)

                    // 品物リスト
                    List(viewModel.filteredCommodities) { commodity in
                        NavigationLink(
                            destination: CommodityDetailView(commodity: commodity),
                            label: {
                                CommodityRowView(commodity: commodity)
                            }
                        ).onAppear {
                            if (viewModel.filteredCommodities.first?.id == commodity.id) {
                                withAnimation() {
                                    self.searchOffset = 0
                                }
                            }
                        }.onDisappear {
                            if (viewModel.filteredCommodities.first?.id == commodity.id) {
                                withAnimation() {
                                    self.searchOffset = searchHeight * -1
                                }
                            }
                        }
                    }
                    .frame(width: displaySize.width, height: displaySize.height, alignment: .center)
                    .listStyle(PlainListStyle())

                }
                .offset(y: self.searchOffset)

            }.background(
                NavigationLink(
                    destination: AddCommodityView(),
                    isActive: $showAddView,
                    label: {
                        EmptyView()
                    }
                )
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("品物リスト")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddView = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.observeCommodities()
            }
        }
    }
}

struct CommodityListView_Previews: PreviewProvider {

    static var previews: some View {

        ContentView().onAppear {
            DIContainer.shared.register(type: CommodityRepository.self, component: MockCommodityRepository())
        }.environment(\.colorScheme, .light)
        
        ContentView().onAppear {
            DIContainer.shared.register(type: CommodityRepository.self, component: MockCommodityRepository())
        }.environment(\.colorScheme, .dark)
    }
}
