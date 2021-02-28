//
//  ContentView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            CommodityListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().onAppear(perform: {
            DIContainer.shared.register(type: CommodityRepository.self, component: MockCommodityRepository())
        })
    }
}
