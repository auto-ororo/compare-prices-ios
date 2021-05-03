//
//  SplashView.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var navigator: Navigator
    private var viewModel = SplashViewModel()
    
    var body: some View {
        HStack {
            Spacer()
            Text(R.string.localizable.appName()).font(.title)
            Spacer()
        }
        .onAppear {
            viewModel.startInitialization()
        }
        .onReceive(viewModel.initializationFinished, perform: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                navigator.navigate(to: .commodityList, direction: .first)
            }
            
        })
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
