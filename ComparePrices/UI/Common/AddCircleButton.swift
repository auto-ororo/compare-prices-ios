//
//  AddCircleButton.swift
//  ComparePrices
//
//  Created by ororo on 2021/04/30.
//

import SwiftUI

struct AddCircleButton: View {
    
    var action : () -> Void
    
    var body: some View {
        Button(action: action
        , label: {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.system(size: 24))
        })
        .frame(width: 60, height: 60)
        .background(Color.pink)
        .cornerRadius(30.0)
        .shadow(color: .gray, radius: 3, x: 3, y: 3)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
    }
}

struct AddCircleButton_Previews: PreviewProvider {
    static var previews: some View {
        AddCircleButton(action: {})
    }
}
