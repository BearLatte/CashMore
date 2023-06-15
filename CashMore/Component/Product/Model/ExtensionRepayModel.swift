//
//  ExtensionRepayModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/15.
//

struct ExtensionRepayModel : HandyJSON {
    /// 是否申请了展期还款流水 1是  0否
    var isExtendIng : Int = 0
    /// 展期手续费
    var extendFee   : String = ""
    /// 展期天数
    var extendDate  : String = ""
    /// 展期后还款日
    var extendRepayDate : String = ""
    /// 展期后还款金额
    var extendRepayAmount : String = ""
}
