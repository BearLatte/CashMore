//
//  OCRModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/9.
//

import Foundation

struct CardFrontModel : HandyJSON {
    var aadharNumber : String = ""
    var aadharName   : String = ""
    var dateOfBirth  : String = ""
    var gender       : String = ""
}

struct CardBackModel : HandyJSON {
    var addressAll : String = ""
}

struct PanFrontModel : HandyJSON {
    var panNumber : String = ""
}
