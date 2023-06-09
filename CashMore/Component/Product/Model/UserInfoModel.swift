//
//  UserInfoModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/12.
//

struct UserInfoModel : HandyJSON {
    var phone            : String = ""
    /// //用户状态 1未认证   2可借款（金融产品信息）  3待审核  4待放款  5被拒绝  6待还款  7已逾期
    var userStatus       : Int = 0
    /// 解冻天数
    var frozenDays       : Int = 0
    var gpsContent       : String = ""
    var photoContent     : String = ""
    /// 通讯录
    var phoneContent     : String = ""
    /// 调用哪家三方做活体 (枚举 ： accuauth)
    var thirdLiveness    : String = ""
    /// 用户是否做完活体  0否 1是  (0的时候下单前需要做活体)
    var userLiveness     : Bool = false
    /// 用户是否放款失败  0否 1是 (1的时候 需要弹放款失败的弹窗)
    var userPayFail      : Bool = false
    /// 失败的弹窗详情信息
    var userPayFailInfo  : PayFailInfo?
    /// 借款单信息
    var loanAuditOrderVo : OrderModel = OrderModel()
    /// 推荐产品详情信息
    var loanProductVo    : ProductDetailModel?
    /// 产品列表
    var loanProductList  : [ProductModel] = []
    /// 是否是谷歌审核配置的手机号，1是，0不是
    var googleAuditPhone : Bool = false
    /// 谷歌审计产品列表
    var loanGoogleAuditProductList : [LoanGoogleAuditProduct] = []
}

struct PayFailInfo : HandyJSON { //失败的弹窗详情信息
    var logo    : String = ""
    /// 文案
    var content : String = ""
    var loanName: String = ""
    /// 借款单号
    var loanOrderNo : String = ""
}

class ProductModel : HandyJSON, Selectionable {
    var isSelected: Bool = false
    
    var displayText: String {
        loanName
    }
    var id            : String = ""
    var logo          : String?
    /// 7借款天数
    var loanDate      : Int = 0
    /// 产品利率
    var loanRate      : String = ""
    /// 产品名称
    var loanName      : String = ""
    /// 库名(space)
    var spaceName     : String?
    /// 3000.00借款金额
    var loanAmount    : Double = 0
    var newUserState  : Int?
    var oldUserState  : Int?
    var dailyApplyNum : Int = 0
    
    required init() {}
}

struct ProductDetailModel : HandyJSON {
    // 产品图片
    var logo               : String = ""
    /// 产品名称
    var loanName           : String = ""
    /// 7借款天数
    var loanDate           : String = ""
    /// 产品id
    var productId          : String = ""
    var gstFeeStr          : String = ""
    /// 库名
    var spaceName          : String = ""
    /// 手续费
    var feeAmountStr       : String = ""
    /// 借款金额
    var loanAmountStr      : String = ""
    /// 应还金额
    var repayAmountStr     : String = ""
    /// 到账金额
    var receiveAmountStr   : String = ""
    /// 逾期费率
    var overdueChargeStr   : String = ""
    /// 利息
    var interestAmountStr  : String = ""
    var verificationFeeStr : String = ""
}

struct LoanGoogleAuditProduct : HandyJSON {
    var id        : String = ""
    var logo      : String = ""
    var phone     : String = ""
    var spaceName : String = ""
    var loanName  : String = ""
    /// 最小借款额度
    var loanAmountMin : String = ""
    /// 最大借款额度
    var loanAmountMax : String = ""
    /// 最小借款周期
    var loanDateMin   : String = ""
    /// 最大借款周期
    var loanDateMax   : String = ""
    /// 最小借款利率
    var loanRateMin   : String = ""
    /// 最大借款利率/
    var loanRateMax   : String = ""
}
