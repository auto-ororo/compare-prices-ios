//
//  NavigationBackButton.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/14.
//

import SwiftUI

struct NavigationBackButton: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "arrow.left")
            }
        })}
}
