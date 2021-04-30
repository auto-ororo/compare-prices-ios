//
//  Header.swift
//  ComparePrices
//
//  Created by ororo on 2021/04/30.
//

import SwiftUI

struct Header: View {
    var backButtonAction: (() -> Void)?

    var title: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                if let action = backButtonAction {
                    NavigationBackButton(action: action).frame(width: 50)
                } else {
                    Text("").frame(width: 50)
                }
                
                Spacer()
                
                Text(title).font(.title2)
                
                Spacer()

                Text("").frame(width: 50)
            }.padding(.vertical, 8)
            Divider().padding(0)
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(title: "タイトル")
    }
}
