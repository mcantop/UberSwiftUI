//
//  Double+Extension.swift
//  UberSwiftUI
//
//  Created by Maciej on 15/10/2022.
//

import Foundation

extension Double {
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimum = 2
        formatter.maximum = 2
        return formatter
    }
    
    func toCurrency() -> String {
        return currencyFormatter.string(for: self) ?? ""
    }
}
