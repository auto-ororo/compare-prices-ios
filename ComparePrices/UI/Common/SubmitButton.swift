//
//  SubmitButton.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/28.
//

import Foundation
import SwiftUI

struct SubmitButton: View {
    var text: String
    
    var action: () -> Void
    
    var isActive: Bool = true
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text).font(.title2).foregroundColor(.white).padding()
                Spacer()
            }
        }.background(R.color.primary.color)
            .cornerRadius(8).disabled(!isActive)
            .opacity(isActive ? 1.0 : 0.7)
    }
}

struct SubmitButton_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        return SubmitButton(text: R.string.localizable.commonRegister(), action: {})
    }
}
