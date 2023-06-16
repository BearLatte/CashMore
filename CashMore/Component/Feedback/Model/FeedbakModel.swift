//
//  FeedbakModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/16.
//


struct FeedbackModel : HandyJSON {
    /// 手机号
    var phone : String = ""
    var logo  : String = ""
    /// 回复数量
    var replyNum : String = ""
    /// 产品名称
    var loanName : String = ""
    /// 回复时间
    var replyTime : String = ""
    /// 反馈提交时间
    var createTime : String = ""
    /// 反馈图片
    var feedBackImg : String = ""
    /// 反馈类型
    var feedBackType  : String = ""
    /// 反馈回复内容
    var feedBackReply : String = ""
    /// 反馈内容
    var feedBackContent : String = ""
}


struct FeedbackRequiredModel : HandyJSON {
    var phone : String = ""
    var feedBackTypeList : [String] = []
    var loanProductList : [ProductModel] = []
}
