//
//  SelectDateSheetView.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/30.
//

import SwiftUI

struct SelectDateSheetView: View {
    var title: String
    @Binding var isPresent: Bool
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title).font(.title)
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            
            SubmitButton(text: "選択", action: {
                isPresent = false
            }).padding()
        }
    }
}

struct SelectDateSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDateSheetView(
            title: "購入日",
            isPresent: .constant(false),
            selectedDate: .constant(Date())
        )
    }
}
