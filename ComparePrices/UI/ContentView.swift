//
//  ContentView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/30.
//

import SwiftUI

struct ContentView: View {

    @StateObject var contentViewModel : ContentViewModel = ContentViewModel.shared

    var body: some View {
        NavigationView {
            CommodityListView()
        }.alert(isPresented: self.$contentViewModel.alert.isShown) {
            
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
        ContentView().onAppear(perform: {
            DIContainer.shared.register(type: CommodityRepository.self, component: MockCommodityRepository())
        })
    }
}
