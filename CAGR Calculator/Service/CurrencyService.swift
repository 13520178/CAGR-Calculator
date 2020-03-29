//
//  CurrencyService.swift
//  NPVCalculator
//
//  Created by Phan Đăng on 1/23/20.
//  Copyright © 2020 Phan Nhat Dang. All rights reserved.
//

import Foundation
 
class CurrencyService {
    static func changeToCurrency(moneyStr:String) ->String? {
        let number:Double? = Double(moneyStr)
        if let number = number {
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            return formatter.string(from: NSNumber(value: number))
        }
        return ""
    }
    
    static func replaceSpace(string:String) -> String {
        let newString = string.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        return newString
    }
    
    static func removeDolar(string:String) -> String {
        let newString = string.replacingOccurrences(of: "$", with: "", options: .literal, range: nil)
        return newString
    }
//  
}
