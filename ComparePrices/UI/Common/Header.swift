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
            Rectangle().frame(width: 0, height: 0, alignment: .center)
            HStack(alignment: .center) {
                if let action = backButtonAction {
                    NavigationBackButton(action: action).frame(width: 50)
                } else {
                    Rectangle().frame(width: 50, height: 0)
                }
                
                Spacer()
                
                Text(title).font(.title3)
                
                Spacer()

                Rectangle().frame(width: 50, height: 0)
            }.padding(.vertical, 4)
            Divider().padding(0)
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(backButtonAction: {}, title: "タイトル")
            .previewLayout(.fixed(width: 400, height: 50))
    }
}
