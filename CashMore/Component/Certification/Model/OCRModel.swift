//
//  OCRModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/9.
//

import Foundation

class CardFrontModel : HandyJSON {
    var imageUrl     : String = ""
    var aadharNumber : String = ""
    var aadharName   : String = ""
    var dateOfBirth  : String = ""
    var gender       : String = ""
    required init() {}
}

class CardBackModel : HandyJSON {
    var imageUrl     : String = ""
    var addressAll : String = ""
    required init() {}
}

class PanFrontModel : HandyJSON {
    var imageUrl     : String = ""
    var panNumber : String = ""
    required init() {}
}
