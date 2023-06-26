//
//  DisbursingFailDetailController.swift
//  CashMore
//
//  Created by Tim on 2023/6/15.
//

import UIKit

class DisbursingFailDetailController: BaseViewController {
    /// 订单编号
    var orderNumber : String = ""
    
    private lazy var productIconView = UIImageView()
    private lazy var productNameLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(20)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    private lazy var orderNumView   = OrderDetailItemView(title: "Order Number")
    private lazy var applyDateView  = OrderDetailItemView(title: "Apply date")
    private lazy var loanAmountView = OrderDetailItemView(title: "Loan Amount", subtitleColor: Constants.themeColor)
    
    private var detailModel : OrderDetailModel! {
        didSet {
            productIconView.kf.setImage(with: URL(string: detailModel.loanAuditOrderVo?.logo ?? "")!)
            productNameLabel.text = detailModel.loanAuditOrderVo?.loanName
            orderNumView.subtitle = detailModel.loanAuditOrderVo?.loanOrderNo
            applyDateView.subtitle = detailModel.loanAuditOrderVo?.applyDateStr
            loanAmountView.subtitle = "₹ " + (detailModel.loanAuditOrderVo?.loanAmountStr ?? "")
        }
    }
}

extension DisbursingFailDetailController {
    override func configUI() {
        super.configUI()
        title = "Disbursing Fail"
        
        view.addSubview(productIconView)
        productIconView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.right.equalTo(view.snp.centerX).offset(-7)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        productIconView.tm.setCorner(25)
        
        view.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(7)
            make.centerY.equalTo(productIconView)
        }
        
        view.addSubview(orderNumView)
        orderNumView.snp.makeConstraints { make in
            make.top.equalTo(productIconView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(applyDateView)
        applyDateView.snp.makeConstraints { make in
            make.top.equalTo(orderNumView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        view.addSubview(loanAmountView)
        loanAmountView.snp.makeConstraints { make in
            make.top.equalTo(applyDateView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
    }
    
    
    override func loadData() {
        APIService.standered.fetchModel(api: API.Order.orderDetail, parameters: ["auditOrderNo" : orderNumber], type: OrderDetailModel.self) { detail in
            self.detailModel = detail
        }
    }
}
