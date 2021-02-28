//
//  GoodsListView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct CommodityListView: View {
    
    @ObservedObject var viewModel: CommodityListViewModel = CommodityListViewModel()
    @State var showDetailView : Bool = false
    @State var showAddView : Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.blue).padding(.leading, 8)
                TextField("商品名、店名を入力",text: $viewModel.searchWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.trailing, 8)
            }.padding(.top, 8)
            
            List(viewModel.filteredCommodities) { commodity in
                NavigationLink(
                    destination: CommodityDetailView(commodity: commodity),
                    isActive: $showDetailView,
                    label: {
                        CommodityRowView(
                            commodity: commodity,
                            onDeleteButtonTapped: {viewModel.removeCommodity(commodity: commodity)},
                            onRowTapped: {showDetailView = true}
                        )
                    }
                )
            }.listStyle(PlainListStyle())
            
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

struct CommodityListView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView().onAppear {
            DIContainer.shared.register(type: CommodityRepository.self, component: MockCommodityRepository())
        }
    }
}
