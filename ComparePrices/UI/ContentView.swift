//
//  ContentView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var navigation: Navigator
    @State private var moveTo : MoveTo = .commodityList
    
    @StateObject var contentViewModel : ContentViewModel = ContentViewModel.shared
    
    var body: some View {
        Group {
            switch moveTo {
            case .commodityList:
                CommodityListView().transition(navigation.getTransitionAnimation())
            case .addCommodity:
                AddCommodityView().transition(navigation.getTransitionAnimation())
            case .commodityDetail(let commodity):
                CommodityDetailView(commodity: commodity).transition(navigation.getTransitionAnimation())
            case .addShopPrice(let commodity):
                AddShopPriceView(commodity: commodity).transition(navigation.getTransitionAnimation())
            default:
                CommodityListView().transition(navigation.getTransitionAnimation())
            }
        }.onReceive(navigation.$request) { request in
            withAnimation {
                moveTo = request.moveTo
            }
        }
        .alert(isPresented: self.$contentViewModel.alert.isShown) {
            
            switch contentViewModel.alert.type {
            case .info:
                return Alert(title: Text(contentViewModel.alert.title),
                             message: Text(contentViewModel.alert.message),
                             dismissButton: .default(Text(contentViewModel.alert.positiveButtonTitle), action: contentViewModel.alert.onOkClick)
                )
            case .confirm:
                return Alert(title: Text(contentViewModel.alert.title),
                             message: Text(contentViewModel.alert.message),
                             primaryButton: .default(Text(contentViewModel.alert.positiveButtonTitle), action: contentViewModel.alert.onOkClick),
                             secondaryButton: .cancel(Text(contentViewModel.alert.negativeButtonTitle))
                )
            case .destructiveConfirm:
                return Alert(title: Text(contentViewModel.alert.title),
                             message: Text(contentViewModel.alert.message),
                             primaryButton: .destructive(Text(contentViewModel.alert.positiveButtonTitle), action: contentViewModel.alert.onOkClick),
                             secondaryButton: .cancel(Text(contentViewModel.alert.negativeButtonTitle))
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        
        return ContentView()
    }
}
