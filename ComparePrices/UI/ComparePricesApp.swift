//
//  ComparePricesApp.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

@main
struct ComparePricesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                registerModules()
            }
        }
    }

    func registerModules() {
        DIContainer.shared.register(type: CommodityRepository.self, component: MockCommodityRepository())
        DIContainer.shared.register(type: CommodityPriceRepository.self, component: MockCommodityPriceRepository())
        DIContainer.shared.register(type: ShopRepository.self, component: MockShopRepository())
    }

}
