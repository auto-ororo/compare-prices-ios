//
//  ComparePricesApp.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import Firebase
import SwiftUI

@main
struct ComparePricesApp: App {
    init() {
        FirebaseApp.configure()
        MockModuleInjector().inject()
    }

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Navigator())
        }
    }
}
