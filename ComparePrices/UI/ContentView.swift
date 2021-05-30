//
//  ContentView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigation: Navigator
    @State private var moveTo: MoveTo = .splash
    
    var body: some View {
        Group {
            switch moveTo {
            case .splash:
                SplashView().transition(navigation.getTransitionAnimation())
            case .commodityList:
                CommodityListView().transition(navigation.getTransitionAnimation())
            case let .commodityDetail(commodity):
                CommodityDetailView(commodity: commodity).transition(navigation.getTransitionAnimation())
            case let .addPurchaseResult(commodity):
                AddPurchaseResultView(commodity: commodity).transition(navigation.getTransitionAnimation())
            default:
                SplashView().transition(navigation.getTransitionAnimation())
            }
        }.onReceive(navigation.$request) { request in
            withAnimation {
                moveTo = request.moveTo
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    init() {
        MockModuleInjector().inject()
    }
    
    static var previews: some View {
        ContentView()
    }
}
