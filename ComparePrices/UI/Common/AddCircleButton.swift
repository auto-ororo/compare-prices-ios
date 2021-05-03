//
//  AddCircleButton.swift
//  ComparePrices
//
//  Created by ororo on 2021/04/30.
//

import SFSafeSymbols
import SwiftUI

struct AddCircleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action,
               label: {
                   Image(systemSymbol: SFSymbol.plus)
                       .foregroundColor(.white)
                       .font(.system(size: 24))
               })
            .frame(width: 60, height: 60)
            .background(R.color.primary.color)
            .cornerRadius(30.0)
            .shadow(color: R.color.elevation.color, radius: 3, x: 3, y: 3)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
    }
}

struct AddCircleButton_Previews: PreviewProvider {
    static var previews: some View {
        AddCircleButton(action: {})
    }
}
