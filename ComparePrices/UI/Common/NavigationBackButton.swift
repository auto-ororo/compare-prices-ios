//
//  NavigationBackButton.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/14.
//

import SwiftUI

struct NavigationBackButton: View {
    
    var action : () -> Void

    var body: some View {
        Button(action: action, label: {
            HStack {
                Image(systemName: "arrow.left")
            }
        })}
}
