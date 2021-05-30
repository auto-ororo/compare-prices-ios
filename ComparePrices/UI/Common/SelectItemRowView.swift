//
//  SelectItemRowView.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/30.
//

import SwiftUI

struct SelectItemRowView: View {
    var itemName: String
    
    var onTapItem: () -> Void
    
    var onTapOption: () -> Void

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(itemName).font(.title3)
                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.leading, 8)
                .contentShape(Rectangle())
                .onTapGesture {
                    onTapItem()
                }
                
                Text("︙")
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .onTapGesture {
                        onTapOption()
                    }
            }
            Divider()
        }
    }
}

struct SelectItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        SelectItemRowView(itemName: "hogehoge", onTapItem: {}, onTapOption: {})
    }
}
