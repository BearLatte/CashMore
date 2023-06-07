//
//  String+Extension.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

import Foundation

extension String: TMCompatible {}
extension NSString: TMCompatible {}
extension TM where Base: ExpressibleByStringLiteral{
    /// generate a random string
    static func randomString(with count: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var ranStr = ""
        for _ in 0 ..< count {
            let index = Int(arc4random()) % characters.count
            let nsstr = characters as NSString
            ranStr.append(nsstr.substring(with: NSRange(location: index, length: 1)))
        }
        return ranStr
    }
    
    var isBlank : Bool {
        (base as! String).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func sortedDictionary(with parameters: Dictionary<String, String?>) -> String {
        var paramsStr = ""
        let keys = parameters.keys.sorted()
        for index in 0 ..< keys.count {
            let key = keys[index] as String
            if let value = parameters[key], !(value ?? "").tm.isBlank {
                if index != keys.count - 1 {
                    paramsStr += String(format: "%@=%@&", key, value!)
                } else {
                    paramsStr += String(format: "%@=%@", key, value!)
                }
            }
            
        }
        return paramsStr
    }
}

