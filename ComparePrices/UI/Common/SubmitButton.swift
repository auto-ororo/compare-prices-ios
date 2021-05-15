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
                Text(text).font(.title2).accentColor(.white).padding()
                Spacer()
            }
        }.background(isActive ? R.color.primary.color : Color.gray)
            .cornerRadius(8).disabled(!isActive)
    }
}

struct SubmitButton_Previews: PreviewProvider {
    static var previews: some View {
        MockModuleInjector().inject()
        return SubmitButton(text: "登録", action: { print("submitted") })
    }
}
