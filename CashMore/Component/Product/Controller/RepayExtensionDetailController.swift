//
//  RepayExtensionDetailController.swift
//  CashMore
//
//  Created by Tim on 2023/6/15.
//

import UIKit
import SafariServices

class RepayExtensionDetailController: BaseViewController {
    var product   : ProductModel? {
        didSet {
            productImgView.kf.setImage(with: URL(string: product?.logo ?? "")!)
            productNameLabel.text = product?.loanName
        }
    }
    var extensionRepayDetail : ExtensionRepayModel? {
        didSet {
            guard let value = extensionRepayDetail else { return }
            repaymentAmountView.subtitle = value.extendRepayAmount
            nextRepaymentDateView.subtitle = value.extendRepayDate
            extensionTermView.subtitle = value.extendDate
            extensionFeeView.subtitle  = value.extendFee
        }
    }
    
    var orderDetail : OrderModel!
    
    private var productImgView = UIImageView()
    private var productNameLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(20)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    private lazy var repaymentAmountView   = ProductDetailItemView(title: "Repayment Amount")
    private lazy var nextRepaymentDateView = ProductDetailItemView(title: "Next Repayment Date")
    private lazy var extensionTermView     = ProductDetailItemView(title: "Extension Term")
    private lazy var extensionFeeView      = ProductDetailItemView(title: "Extension Fee")
    private lazy var repayBtn = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Repay Extension", for: .normal)
        btn.setBackgroundImage(UIImage.tm.createImage(Constants.themeColor), for: .normal)
        return btn
    }()
}

extension RepayExtensionDetailController {
    override func configUI() {
        super.configUI()
        title = "Repay Extension"
        isLightStyle = true
        
        let darkView = UIView()
        darkView.backgroundColor = Constants.darkBgColor
        view.insertSubview(darkView, at: 0)
        darkView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        let label = UILabel()
        label.textColor = Constants.pureWhite
        label.font = Constants.pingFangSCRegularFont(18)
        label.text = "To extend the loan period, please pay\n the extension fee."
        label.numberOfLines = 0
        label.textAlignment = .center
        darkView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        let productInfoView = UIView()
        view.addSubview(productInfoView)
        productInfoView.snp.makeConstraints { make in
            make.top.equalTo(darkView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        productInfoView.addSubview(productImgView)
        productImgView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        productImgView.tm.setCorner(25)
        
        productInfoView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(productImgView.snp.right).offset(14)
        }
        
        view.addSubview(repaymentAmountView)
        repaymentAmountView.snp.makeConstraints { make in
            make.top.equalTo(productInfoView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(nextRepaymentDateView)
        nextRepaymentDateView.snp.makeConstraints { make in
            make.top.equalTo(repaymentAmountView.snp.bottom)
            make.left.right.equalTo(repaymentAmountView)
        }
        
        view.addSubview(extensionTermView)
        extensionTermView.snp.makeConstraints { make in
            make.top.equalTo(nextRepaymentDateView.snp.bottom)
            make.left.right.equalTo(repaymentAmountView)
        }
        
        view.addSubview(extensionFeeView)
        extensionFeeView.snp.makeConstraints { make in
            make.top.equalTo(extensionTermView.snp.bottom)
            make.left.right.equalTo(repaymentAmountView)
        }
        
        view.addSubview(repayBtn)
        repayBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 265, height: 50))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-(Constants.bottomSafeArea + 10))
        }
        repayBtn.tm.setCorner(25)
        repayBtn.addTarget(self, action: #selector(applyRepayment), for: .touchUpInside)
    }
    
    @objc func applyRepayment() {
        ADJustTrackTool.point(name: "598jqo")
        APIService.standered.fetchModel(api: API.Order.repaymentApply, parameters: ["orderNo":orderDetail.loanOrderNo, "repayType" : "extend"], type: RepaymentModel.self) { repayPath in
            let safari = SFSafariViewController(url: URL(string: repayPath.path)!)
            self.present(safari, animated: true)
        }
    }
}
