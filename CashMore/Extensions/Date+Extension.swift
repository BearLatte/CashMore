//
//  Date+Extension.swift
//  CashMore
//
//  Created by Tim on 2023/6/10.
//

import Foundation

extension Date : TMCompatible {}
extension TM where Base == Date {
    /// get a DateString fron now
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = format
        return formatter.string(from: base)
    }
    
    /// convert Date to String
    static func date2string(date: Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    /// convert string to Date
    static func string2date(dateStr: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        return formatter.date(from: dateStr)!
    }

}
