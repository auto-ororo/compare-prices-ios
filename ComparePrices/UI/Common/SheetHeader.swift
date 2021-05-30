//
//  SheetHeader.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/30.
//

import SwiftUI

struct SheetHeader: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title).font(.title).bold()
            Spacer()
        }.padding(8)
    }
}

struct SheetHeader_Previews: PreviewProvider {
    static var previews: some View {
        SheetHeader(title: "Title")
    }
}
