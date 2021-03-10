//
//  CommodityDetailView.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/01.
//

import Foundation
import SwiftUI

struct CommodityDetailView: View {
    
    var commodity: CommodityListRow

    var body: some View {
        VStack(alignment: .leading) {
            DetailTextLayout(label: "商品名", text: commodity.name).padding(8)
            DetailTextLayout(label: "店名", text: commodity.mostInexpensiveStore).padding(8)
            DetailTextLayout(label: "価格", text: commodity.lowestPrice.description).padding(8)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("詳細")
            }
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationBackButton()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private struct DetailTextLayout: View {
        
        var label : String
        
        var text : String
        
        var body: some View {
            
            HStack {
                Text(label).font(.headline).frame(width: 70, alignment: .trailing)
                Text(text)
                Spacer()
            }
        }
    }
}

struct CommodityDetailView_Previews: PreviewProvider {

    static var previews: some View {
        CommodityDetailView(commodity: CommodityListRow(name: "もやし", lowestPrice: 19, mostInexpensiveStore: "ビッグ・エー"))
    }
}
