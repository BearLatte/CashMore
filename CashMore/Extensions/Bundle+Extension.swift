//
//  Bundle+Extension.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import Foundation

extension Bundle : TMCompatible {}
extension TM where Base : Bundle {
    /// get pruduct version number
    static var productVersion : String {
            (Base.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
    }
}
