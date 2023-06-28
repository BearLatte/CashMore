//
//  OrderDetailController.swift
//  CashMore
//
//  Created by Tim on 2023/6/28.
//

import UIKit
import SafariServices

class OrderDetailController: BaseTableController {
    
    // MARK: - Public Properties
    
    var orderNumber : String = ""
    
    // MARK: - Private Properties
    
    private enum OrderDetailType {
        case disbursingFail             // 放款失败
        case unrepaid                   // 待还款
        case overdue                    // 未还款已逾期
        case repaidNotOverdue           // 已还款未逾期
        case repaidAndOverdue           // 已还款已逾期
    }
    private var orderType : OrderDetailType = .disbursingFail
    private lazy var logoView = UIImageView()
    private lazy var productNameLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(20)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    private lazy var tableHeaderView = UIView()
    private lazy var orderNumView   = OrderDetailItemView(title: "Order Number")
    private lazy var applyDateView  = OrderDetailItemView(title: "Apply date")
    private lazy var loanAmountView = OrderDetailItemView(title: "Loan Amount")
    private lazy var receivedDateView = OrderDetailItemView(title: "Date of loan receive")
    private lazy var receivedAmountView = OrderDetailItemView(title: "Received Amount")
    private lazy var overdueDaysView = OrderDetailItemView(title: "Overdue Days")
    private lazy var overdueChargeView = OrderDetailItemView(title: "Overdue Charge")
    private lazy var repaymentDateView = OrderDetailItemView(title: "Repayment Date")
    private lazy var repaymentAmountView = OrderDetailItemView(title: "Repayment Amount", subtitleColor: Constants.themeColor)
    
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
    
    private var userInfo : UserInfoModel? {
        didSet {
            guard let value = userInfo else { return }
            let order = value.loanAuditOrderVo
            logoView.kf.setImage(with: URL(string: order.logo))
            productNameLabel.text = order.loanName
            orderNumView.subtitle = order.loanOrderNo
            applyDateView.subtitle = order.applyDateStr
            loanAmountView.subtitle = "₹ " + order.loanAmountStr
            receivedDateView.subtitle = order.receiveDateStr
            receivedAmountView.subtitle = "₹ " + order.receiveAmountStr
            overdueDaysView.subtitle = "\(value.frozenDays)"
            overdueChargeView.subtitle = order.overDueFeeStr
            repaymentDateView.subtitle = order.repayDateStr
            repaymentAmountView.subtitle = "₹ " + order.repayAmountStr
            // 审核状态 0待审核  1待放款 2待还款 5已逾期  6放款失败 7审核失败 8已还款-未逾期 9已还款-有逾期
            switch order.status {
            case 2:
                orderType = .unrepaid
            case 5:
                orderType = .overdue
            case 6:
                orderType = .disbursingFail
            case 8:
                orderType = .repaidNotOverdue
            case 9:
                orderType = .repaidAndOverdue
            default: break
            }
            
            reloadUI()
        }
    }
    
    private var recommendProducts : [ProductModel?] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
}


// MARK: - ConfigUI

extension OrderDetailController {
    override func configUI() {
        super.configUI()
        
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView.addSubview(logoView)
        tableHeaderView.addSubview(productNameLabel)
        tableHeaderView.addSubview(orderNumView)
        tableHeaderView.addSubview(applyDateView)
        tableHeaderView.addSubview(loanAmountView)
        tableHeaderView.addSubview(receivedDateView)
        tableHeaderView.addSubview(receivedAmountView)
        tableHeaderView.addSubview(overdueDaysView)
        tableHeaderView.addSubview(overdueChargeView)
        tableHeaderView.addSubview(repaymentDateView)
        tableHeaderView.addSubview(repaymentAmountView)
        
        view.addSubview(extensionBtn)
        extensionBtn.addTarget(self, action: #selector(showExtensionAlert), for: .touchUpInside)
        view.addSubview(repayBtn)
        repayBtn.addTarget(self, action: #selector(repayAction), for: .touchUpInside)
        
        tableView.register(HomeProductCell.self, forCellReuseIdentifier: "kRecommendCell")
        tableView.register(HomeProductHeaderView.self, forHeaderFooterViewReuseIdentifier: "kSectionHeaderView")
    }
    
    private func reloadUI() {
        
        switch orderType {
        case .disbursingFail:
            title = "Disbursing Fail"
            extensionBtn.isHidden = true
            repayBtn.isHidden = true
            receivedDateView.isHidden = true
            receivedAmountView.isHidden = true
            overdueDaysView.isHidden = true
            overdueChargeView.isHidden = true
            repaymentDateView.isHidden = true
            repaymentAmountView.isHidden = true
            loanAmountView.subtitleColor = Constants.themeColor
        case .unrepaid:
            title = "To be Repaid"
            extensionBtn.isHidden = false
            repayBtn.isHidden = false
            receivedDateView.isHidden = false
            receivedAmountView.isHidden = false
            overdueDaysView.isHidden = true
            overdueChargeView.isHidden = true
            repaymentDateView.isHidden = false
            repaymentAmountView.isHidden = false
        case .overdue:
            title = "Overdue"
            extensionBtn.isHidden = false
            repayBtn.isHidden = false
            receivedDateView.isHidden = false
            receivedAmountView.isHidden = false
            overdueDaysView.isHidden = false
            overdueChargeView.isHidden = false
            repaymentDateView.isHidden = false
            repaymentAmountView.isHidden = false
        case .repaidNotOverdue:
            title = "Repaid"
            extensionBtn.isHidden = true
            repayBtn.isHidden = true
            receivedDateView.isHidden = false
            receivedAmountView.isHidden = false
            overdueDaysView.isHidden = true
            overdueChargeView.isHidden = true
            repaymentDateView.isHidden = false
            repaymentAmountView.isHidden = false
        case .repaidAndOverdue:
            title = "Repaid"
            extensionBtn.isHidden = true
            repayBtn.isHidden = true
            receivedDateView.isHidden = false
            receivedAmountView.isHidden = false
            overdueDaysView.isHidden = false
            overdueChargeView.isHidden = false
            repaymentDateView.isHidden = false
            repaymentAmountView.isHidden = false
        }
        
        tableHeaderView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(Constants.screenWidth)
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalTo(tableHeaderView.snp.centerX).offset(-7)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        logoView.tm.setCorner(25)
        
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(tableHeaderView.snp.centerX).offset(7)
            make.centerY.equalTo(logoView)
        }
        
        orderNumView.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        applyDateView.snp.makeConstraints { make in
            make.top.equalTo(orderNumView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        loanAmountView.snp.makeConstraints { make in
            make.top.equalTo(applyDateView.snp.bottom)
            make.left.right.equalTo(orderNumView)
            if orderType == .disbursingFail {
                make.bottom.equalToSuperview().priority(.high)
            }
        }
        
        receivedDateView.snp.makeConstraints { make in
            make.top.equalTo(loanAmountView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        receivedAmountView.snp.makeConstraints { make in
            make.top.equalTo(receivedDateView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        overdueDaysView.snp.makeConstraints { make in
            make.top.equalTo(receivedAmountView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        overdueChargeView.snp.makeConstraints { make in
            make.top.equalTo(overdueDaysView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        repaymentDateView.snp.makeConstraints { make in
            if orderType == .overdue || orderType == .repaidAndOverdue {
                make.top.equalTo(overdueChargeView.snp.bottom)
            } else {
                make.top.equalTo(receivedAmountView.snp.bottom)
            }
            
            make.left.right.equalTo(orderNumView)
        }
        
        repaymentAmountView.snp.makeConstraints { make in
            make.top.equalTo(repaymentDateView.snp.bottom)
            make.left.right.equalTo(orderNumView)
            make.bottom.equalToSuperview().priority(.high)
        }
        tableHeaderView.layoutIfNeeded()
        
        
        extensionBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(view.snp.centerX).offset(-5)
            make.bottom.equalTo(-(Constants.bottomSafeArea + 20))
            make.height.equalTo(50)
        }
        extensionBtn.tm.setCorner(25)
        
        
        repayBtn.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(5)
            make.right.equalTo(-20)
            make.bottom.height.equalTo(extensionBtn)
        }
        repayBtn.tm.setCorner(25)
    }
}

// MARK: - Helpers

extension OrderDetailController {
    override func loadData() {
        APIService.standered.fetchResponseList(api: API.Order.orderDetail, parameters: ["auditOrderNo" : orderNumber]) { response in
            self.userInfo = UserInfoModel.deserialize(from: response.cont)
            self.recommendProducts = [ProductModel].deserialize(from: response.list) ?? []
            self.tableView.reloadData()
            self.tableView.endRefreshing(at: .top)
        }
    }
    
    @objc func repayAction() {
        if orderType == .unrepaid {
            ADJustTrackTool.point(name: "whisev")
        } else {
            ADJustTrackTool.point(name: "4djy8t")
        }
        APIService.standered.fetchModel(api: API.Order.repaymentApply, parameters: ["orderNo": orderNumber, "repayType":"all"], type: RepaymentModel.self) { repayPath in
            let safari = SFSafariViewController(url: URL(string: repayPath.path)!)
            self.present(safari, animated: true)
        }
    }
    
    @objc func showExtensionAlert() {
        TipsSheet.show(isHiddenTitle: true, message: "Paying a small amount admission fee. You can pay the whole bill later.", confirmAction:  {
            self.applyExtensionRepay()
        })
    }
    
    private func applyExtensionRepay() {
        if orderType == .unrepaid {
            ADJustTrackTool.point(name: "qm2i8v")
        } else {
            ADJustTrackTool.point(name: "dh9d6k")
        }
        APIService.standered.fetchModel(api: API.Order.extensionRepayApply, parameters: ["orderNo": orderNumber], type: ExtensionRepayModel.self) { extensionRepayModel in
            let controller = RepayExtensionDetailController()
            controller.extensionRepayDetail = extensionRepayModel
            controller.orderDetail = self.userInfo?.loanAuditOrderVo
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}


// MARK: - UITableViewDataSource UItableViewDelegate

extension OrderDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderType == .repaidAndOverdue || orderType == .repaidNotOverdue {
            return recommendProducts.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kRecommendCell", for: indexPath) as! HomeProductCell
        cell.product = recommendProducts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = recommendProducts[indexPath.row]
        APIService.standered.fetchModel(api: API.Product.spaceDetail, parameters: ["productId" : product?.id ?? ""], type: UserInfoModel.self) { userInfo in
            switch userInfo.userStatus {
            case 1:
                break
            case 2:
                let purchaseVC = PurchaseController()
                purchaseVC.productDetail = userInfo.loanProductVo
                self.navigationController?.pushViewController(purchaseVC, animated: true)
            case 3, 4, 5:
                let productDetailVC = ProductDetailController()
                if userInfo.userStatus == 5 {
                    productDetailVC.frozenDays = userInfo.frozenDays
                }
                productDetailVC.orderType = OrderType(rawValue: userInfo.userStatus) ?? .pending
                productDetailVC.product = product
                productDetailVC.orderDetail = userInfo.loanAuditOrderVo
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            default:
                let orderDetailVC = OrderDetailController()
                orderDetailVC.orderNumber = userInfo.loanAuditOrderVo.loanOrderNo
                self.navigationController?.pushViewController(orderDetailVC, animated: true)
            }
        }
    }
}
