//
//  DateExtensions.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/23.
//

import Foundation

extension Date {
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = R.string.localizable.commonDateFormat()
        return formatter.string(from: self)
    }
}
