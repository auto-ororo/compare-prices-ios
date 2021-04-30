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
        MockModuleInjector().inject()
        return WindowGroup {
            ContentView().environmentObject(Navigator())
        }
    }
}
