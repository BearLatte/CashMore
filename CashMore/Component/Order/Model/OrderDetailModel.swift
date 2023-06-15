//
//  OrderDetailModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/15.
//

struct OrderDetailModel : HandyJSON {
    /// 3待审核  4待放款  5被拒绝  6代还款  7已逾期  8未逾期已完成  9逾期已完成/
    var userStatus : Int = 0
    /// 解冻天数 userStatus = 5    frozenDays=0 时代表用户解冻
    var frozenDays : Int = 0
    /// 手机号
    var phone : String = ""
    /// 是否是谷歌审核配置的手机号，1是，0不是/
    var googleAuditPhone : Int = 0
    /// 借款单信息
    var loanAuditOrderVo : OrderModel?
}
