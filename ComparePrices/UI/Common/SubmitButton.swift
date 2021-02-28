//
//  SubmitButton.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/28.
//

import Foundation
import SwiftUI

struct SubmitButton : View {
    
    var text : String
    
    var action : () -> Void
    
    var isActive : Bool
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text).font(.title2).accentColor(.white).padding()
                Spacer()
            }
        }.background(isActive ? Color.pink : Color.gray)
        .cornerRadius(20).disabled(!isActive)
    }
}

