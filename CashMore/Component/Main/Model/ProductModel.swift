//
//  ProductModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//
//@_exported import HandyJSON

class ProductModel : HandyJSON {
    var id            : String = ""
    var dailyApplyNum : Int = 0
    var loanAmount    : Double = 0
    var loanDate      : Int = 0
    var loanRate      : String = ""
    var logo          : String?
    var newUserState  : Int?
    var oldUserState  : Int?
    var spaceName     : String?
    var loanName      : String = ""
    
    required init() {}
}
