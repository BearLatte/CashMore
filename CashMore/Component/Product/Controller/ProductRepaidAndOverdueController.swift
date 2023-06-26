//
//  ProductRepaidAndOverdueController.swift
//  CashMore
//
//  Created by Tim on 2023/6/14.
//

import UIKit
import SafariServices

class ProductRepaidAndOverdueController: BaseViewController {
    var orderType : OrderType = .repaid {
        didSet {
            if orderType == .repaid {
                overdueDaysView.isHidden = true
                overdueChargeView.isHidden = true
                title = "To be Repaid"
            } else {
                overdueDaysView.isHidden = false
                overdueChargeView.isHidden = false
                title = "Overdue"
            }
        }
    }
    
    var product : ProductModel? {
        didSet {
            productImgView.kf.setImage(with: URL(string: product?.logo ?? "")!)
            productNameLabel.text = product?.loanName
        }
    }
    
    var orderDetail : OrderModel? {
        didSet {
            guard let value = orderDetail else { return }
            orderNumberView.subtitle = value.loanOrderNo
            applyDateView.subtitle = value.applyDateStr
            loanAmountView.subtitle = "₹ " + value.loanAmountStr
            receiveAmountView.subtitle = "₹ " + value.receiveAmountStr
            receiveDateView.subtitle = value.receiveDateStr
            repaymentDateView.subtitle = value.repayDateStr
            repaymentAmountView.subtitle = "₹ " + value.repayAmountStr
            overdueDaysView.subtitle = value.overDueDays
            overdueChargeView.subtitle = "₹ " + value.overDueFeeStr
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private var productImgView = UIImageView()
    private var productNameLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(20)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
   
    private lazy var orderNumberView = OrderDetailItemView(title: "Order Number")
    private lazy var applyDateView   = OrderDetailItemView(title: "Apply date")
    private lazy var loanAmountView  = OrderDetailItemView(title: "Loan Amount")
    private lazy var receiveDateView = OrderDetailItemView(title: "Date of loan receive")
    private lazy var receiveAmountView   = OrderDetailItemView(title: "Received Amount")
    private lazy var repaymentDateView   = OrderDetailItemView(title: "Repayment Date")
    private lazy var repaymentAmountView = OrderDetailItemView(title: "Repayment Amount", subtitleColor: Constants.themeColor)
    
    // Overdue
    private lazy var overdueDaysView = OrderDetailItemView(title: "Overdue Days")
    private lazy var overdueChargeView = OrderDetailItemView(title: "Overdue Charge")
    
    // bottom btn
    private lazy var extensionBtn = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Repay Extension", for: .normal)
        btn.setTitleColor(Constants.pureWhite, for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCMediumFont(18)
        btn.setBackgroundImage(UIImage.tm.createImage(Constants.themeDarkColor), for: .normal)
        return btn
    }()
    
    private lazy var repayBtn = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Repay Now", for: .normal)
        btn.setTitleColor(Constants.pureWhite, for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCMediumFont(18)
        btn.setBackgroundImage(UIImage.tm.createImage(Constants.themeColor), for: .normal)
        return btn
    }()
}

extension ProductRepaidAndOverdueController {
    override func configUI() {
        super.configUI()
        
        let productInfoView = UIView()
        view.addSubview(productInfoView)
        productInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
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
        
        view.addSubview(orderNumberView)
        orderNumberView.snp.makeConstraints { make in
            make.top.equalTo(productInfoView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        view.addSubview(applyDateView)
        applyDateView.snp.makeConstraints { make in
            make.top.equalTo(orderNumberView.snp.bottom)
            make.left.right.equalTo(orderNumberView)
        }
        view.addSubview(loanAmountView)
        loanAmountView.snp.makeConstraints { make in
            make.top.equalTo(applyDateView.snp.bottom)
            make.left.right.equalTo(orderNumberView)
        }
        view.addSubview(receiveDateView)
        receiveDateView.snp.makeConstraints { make in
            make.top.equalTo(loanAmountView.snp.bottom)
            make.left.right.equalTo(orderNumberView)
        }
        view.addSubview(receiveAmountView)
        receiveAmountView.snp.makeConstraints { make in
            make.top.equalTo(receiveDateView.snp.bottom)
            make.left.right.equalTo(orderNumberView)
        }
       
        if orderType == .overdue {
            view.addSubview(overdueDaysView)
            overdueDaysView.snp.makeConstraints { make in
                make.top.equalTo(receiveAmountView.snp.bottom)
                make.left.right.equalTo(orderNumberView)
            }
            view.addSubview(overdueChargeView)
            overdueChargeView.snp.makeConstraints { make in
                make.top.equalTo(overdueDaysView.snp.bottom)
                make.left.right.equalTo(orderNumberView)
            }
        }
        
        
        view.addSubview(repaymentDateView)
        repaymentDateView.snp.makeConstraints { make in
            make.top.equalTo(orderType == .repaid ? receiveAmountView.snp.bottom : overdueChargeView.snp.bottom)
            make.left.right.equalTo(orderNumberView)
        }
        view.addSubview(repaymentAmountView)
        repaymentAmountView.snp.makeConstraints { make in
            make.top.equalTo(repaymentDateView.snp.bottom)
            make.left.right.equalTo(orderNumberView)
        }
        
        view.addSubview(extensionBtn)
        extensionBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(view.snp.centerX).offset(-5)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-(Constants.bottomSafeArea + 10))
        }
        extensionBtn.tm.setCorner(25)
        extensionBtn.addTarget(self, action: #selector(showExtensionAlert), for: .touchUpInside)
        
        view.addSubview(repayBtn)
        repayBtn.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(5)
            make.right.equalTo(-20)
            make.height.bottom.equalTo(extensionBtn)
        }
        repayBtn.tm.setCorner(25)
        repayBtn.addTarget(self, action: #selector(repayAction), for: .touchUpInside)
    }
    
    @objc func showExtensionAlert() {
        TipsSheet.show(isHiddenTitle: true, message: "Paying a small amount admission fee. You can pay the whole bill later.", confirmAction:  {
            self.applyExtensionRepay()
        })
    }
    
    @objc func repayAction() {
        if orderType == .repaid {
            ADJustTrackTool.point(name: "whisev")
        } else {
            ADJustTrackTool.point(name: "4djy8t")
        }
        APIService.standered.fetchModel(api: API.Order.repaymentApply, parameters: ["orderNo":orderDetail?.loanOrderNo ?? "", "repayType":"all"], type: RepaymentModel.self) { repayPath in
            let safari = SFSafariViewController(url: URL(string: repayPath.path)!)
            self.present(safari, animated: true)
        }
    }
    
    private func applyExtensionRepay() {
        if orderType == .repaid {
            ADJustTrackTool.point(name: "qm2i8v")
        } else {
            ADJustTrackTool.point(name: "dh9d6k")
        }
        APIService.standered.fetchModel(api: API.Order.extensionRepayApply, parameters: ["orderNo":orderDetail?.loanOrderNo ?? ""], type: ExtensionRepayModel.self) { extensionRepayModel in
            let controller = RepayExtensionDetailController()
            controller.product = self.product
            controller.extensionRepayDetail = extensionRepayModel
            controller.orderDetail = self.orderDetail
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func loadData() {
        APIService.standered.fetchModel(api: API.Product.spaceDetail, parameters: ["productId" : product?.id ?? ""], type: UserInfoModel.self) { userInfo in
            self.orderDetail = userInfo.loanAuditOrderVo
        }
    }
}
