//
//  RepaidOrderDetailController.swift
//  CashMore
//
//  Created by Tim on 2023/6/19.
//

import UIKit


class RepaidOrderDetailController: BaseTableController {
    
    var order : OrderModel? {
        didSet {
            productIcon.kf.setImage(with: URL(string: order?.logo ?? ""))
            productNameLabel.text = order?.loanName
            orderNumView.subtitle = order?.loanOrderNo
            applyDateView.subtitle = order?.applyDateStr
            loanAmountView.subtitle = order?.loanAmountStr
            receivedDateView.subtitle = order?.receiveDateStr
            receivedAmountView.subtitle = order?.receiveAmountStr
            repaymentDateView.subtitle = order?.repayDateStr
            repaymentAmountView.subtitle = order?.repayAmountStr
            overdueDaysView.subtitle = order?.overDueDays
            overdueChargeView.subtitle = order?.overDueFeeStr
        }
    }
    
    private lazy var productIcon = {
        let iconView = UIImageView()
        iconView.layer.cornerRadius = 25
        iconView.layer.masksToBounds = true
        iconView.contentMode = .scaleAspectFill
        return iconView
    }()
    
    private lazy var productNameLabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCRegularFont(20)
        return lb
    }()
    
    private lazy var orderNumView = ProductDetailItemView(title: "Order Number")
    private lazy var applyDateView = ProductDetailItemView(title: "Apply date")
    private lazy var loanAmountView = ProductDetailItemView(title: "Loan Amount")
    private lazy var receivedDateView = ProductDetailItemView(title: "Date of loan receive")
    private lazy var receivedAmountView = ProductDetailItemView(title: "Received Amount")
    private lazy var overdueDaysView = ProductDetailItemView(title: "Overdue Days")
    private lazy var overdueChargeView = ProductDetailItemView(title: "Overdue Charge")
    private lazy var repaymentDateView = ProductDetailItemView(title: "Repayment Date")
    private lazy var repaymentAmountView = ProductDetailItemView(title: "Repayment Amount", subtitleColor: Constants.themeColor)
    private var products : [ProductModel?]?
}

extension RepaidOrderDetailController {
    override func configUI() {
        super.configUI()
        title = "Repaid"
        let productBgView = UIView()
        view.addSubview(productBgView)
        productBgView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        productBgView.addSubview(productIcon)
        productIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.bottom.equalToSuperview().priority(.high)
        }
        
        productBgView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(productIcon.snp.right).offset(15)
        }
        
        view.addSubview(orderNumView)
        view.addSubview(applyDateView)
        view.addSubview(loanAmountView)
        view.addSubview(receivedDateView)
        view.addSubview(receivedAmountView)
        if order?.status == 9 {
            view.addSubview(overdueDaysView)
            view.addSubview(overdueChargeView)
        }
        view.addSubview(repaymentDateView)
        view.addSubview(repaymentAmountView)
        
        orderNumView.snp.makeConstraints { make in
            make.top.equalTo(productBgView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        applyDateView.snp.makeConstraints { make in
            make.top.equalTo(orderNumView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        loanAmountView.snp.makeConstraints { make in
            make.top.equalTo(applyDateView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        receivedDateView.snp.makeConstraints { make in
            make.top.equalTo(loanAmountView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        receivedAmountView.snp.makeConstraints { make in
            make.top.equalTo(receivedDateView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        if order?.status == 9 {
            overdueDaysView.snp.makeConstraints { make in
                make.top.equalTo(receivedAmountView.snp.bottom)
                make.left.right.equalTo(orderNumView)
            }
            
            overdueChargeView.snp.makeConstraints { make in
                make.top.equalTo(overdueDaysView.snp.bottom)
                make.left.right.equalTo(orderNumView)
            }
        }
        
        repaymentDateView.snp.makeConstraints { make in
            make.top.equalTo(order?.status == 9 ? overdueChargeView.snp.bottom : receivedAmountView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        repaymentAmountView.snp.makeConstraints { make in
            make.top.equalTo(repaymentDateView.snp.bottom)
            make.left.right.equalTo(orderNumView)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(repaymentAmountView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.register(HomeProductCell.self, forCellReuseIdentifier: "RecommendCell")
        tableView.register(HomeProductHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
    }
    
    override func loadData() {
        APIService.standered.fetchResponseList(api: API.Order.orderDetail, parameters: ["auditOrderNo" : order?.loanOrderNo ?? ""]) { model in
            self.products = [ProductModel].deserialize(from: model.list)
            self.tableView.reloadData()
            self.tableView.endRefreshing(at: .top)
        }
    }
}

extension RepaidOrderDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendCell", for: indexPath) as! HomeProductCell
        cell.product = products?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as! HomeProductHeaderView
        header.title = "Top recommendation"
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = products?[indexPath.row]
        APIService.standered.fetchModel(api: API.Product.spaceDetail, parameters: ["productId" : product?.id ?? ""], type: UserInfoModel.self) { userInfo in
            switch userInfo.userStatus {
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
                break
            }
        }
    }
}


