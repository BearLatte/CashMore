//
//  BaseModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/8.
//

@_exported import HandyJSON

struct BaseModel : HandyJSON {
    var code : Int = 0
    var msg  : String = ""
    var response : BaseResponseContent = BaseResponseContent()
}


struct BaseResponseContent : HandyJSON {
    var cont : [String : Any]?
}
