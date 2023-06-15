//
//  RepaymentModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/15.
//


struct RepaymentModel : HandyJSON {
    /// 支付跳转地址
    var path : String = ""
    ///支付拦截地址
    var h5 : String = ""
    /// 0 跳转系统浏览器  1 打开原生webview 并且里面可以跳转系统浏览器 2 只能在 webview 里面处理
    var webview : String = ""
}
