//
//  OrderModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

import Foundation

struct OrderModel : HandyJSON {
    var logo   : String = ""
    /// 0待审核  1待放款 2待还款  5已逾期  6放款失败 7审核失败 8已还款-未逾期 9已还款-有逾期
    var status : Int = 0
    var loanDate   : String = ""
    var loanName   : String = ""
    var productId  : String = ""
    var bankCardNo : String = ""
    var overDueDays  : String = ""
    var loanOrderNo  : String = ""
    var applyDateStr : String = ""
    var repayDateStr : String = ""
    var overDueFeeStr: String = ""
    var loanAmountStr: String = ""
    var repayAmountStr   : String = ""
    var receiveAmountStr : String = ""
}
