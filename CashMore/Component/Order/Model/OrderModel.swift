//
//  OrderModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

import Foundation

struct OrderModel : HandyJSON {
    var logo   : String = ""
    var loanName   : String = ""
    var productId  : String = ""
    // 银行卡号码
    var bankCardNo : String = ""
    /// 距离还款日时间
    var daysToRepay : Int = 0
    /// 借款单号
    var loanOrderNo : String = ""
    /// 日期
    var applyDateStr : String = ""
    /// 金额
    var loanAmountStr : String = ""
    var loanDate : Int = 0
    /// 放款时间
    var receiveDateStr : String = ""
    /// 放款金额
    var receiveAmountStr : String = ""
    /// 还款金额
    var repayAmountStr : String = ""
    /// 还款时间
    var repayDateStr : String = ""
    /// 逾期时间
    var overDueDays : String = ""
    /// 逾期费用
    var overDueFeeStr : String = ""
    /// 审核状态 0待审核  1待放款 2待还款 5已逾期  6放款失败 7审核失败 8已还款-未逾期 9已还款-有逾期
    var status : Int = 0
}



