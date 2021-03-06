//
//  NavigationBackButton.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/14.
//

import SFSafeSymbols
import SwiftUI

struct NavigationBackButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action, label: {
            HStack {
                Image(systemSymbol: SFSymbol.arrowLeft).resizable().frame(width: 20.0, height: 20.0, alignment: .center)
            }
        })
    }
}
