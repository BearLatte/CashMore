//
//  ProductDetailController.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

import UIKit

enum OrderType : Int {
    case pending = 3    // 待审核
    case disbursing = 4 // 待放款
    case denied = 5     // 被拒绝
    case repaid = 6     // 待还款
    case overdue = 7    // 已逾期
}
class ProductDetailController: BaseTableController {
    var frozenDays : Int = 0
    var orderType : OrderType = .pending {
        didSet {
            switch orderType {
            case .pending:
                title = "Pending"
                desc = "The loan is under review, and we will\nnotify you when it is approved."
            case .disbursing:
                title = "Disbursing"
                desc = "Hello user! The loan you applied for is\nbeing disbursed, and we will notify you\nwhen the disbursement is successful."
            case .denied:
                title = "Denied"
                desc = "The loan you applied for cannot be\napproved, please reapply for this product\nafter \(frozenDays) days. You can now also directly\napply for other products."
            default: break
            }
        }
    }
    
    var product : ProductModel? {
        didSet {
            guard let value = product else {
                return
            }
            productLogo.kf.setImage(with: URL(string: value.logo ?? "")!)
            productNameLabel.text = value.loanName
        }
    }
    
    var orderDetail : OrderModel? {
        didSet {
            productAmountLabel.text = "₹ " + (orderDetail?.loanAmountStr ?? "")
            dateLabel.text = "Apply date : " + (orderDetail?.applyDateStr ?? "")
            accountLabel.text = "Account : " + (orderDetail?.bankCardNo ?? "")
        }
    }
    private var desc : String = ""
    private lazy var productLogo = UIImageView()
    private lazy var productNameLabel = itemLabel()
    private lazy var productAmountLabel = itemLabel(font: Constants.pingFangSCMediumFont(20))
    private lazy var dateLabel = itemLabel()
    private lazy var accountLabel = itemLabel()
    private var recmmendProducts : [ProductModel?]?
}

// MARK: - Config UI
extension ProductDetailController {
    override func configUI() {
        super.configUI()
        isLightStyle = true

        let header = UIView()
        header.backgroundColor = Constants.darkBgColor
        view.insertSubview(header, at: 0)
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        let copyWritingLabel = UILabel()
        copyWritingLabel.text = desc
        copyWritingLabel.font = Constants.pingFangSCRegularFont(18)
        copyWritingLabel.numberOfLines = 0
        copyWritingLabel.textColor = Constants.pureWhite
        copyWritingLabel.textAlignment = .center
        header.addSubview(copyWritingLabel)
        copyWritingLabel.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }

        let cardView = UIImageView(image: R.image.order_card())
        header.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.equalTo(copyWritingLabel.snp.bottom).offset(14)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.bottom.equalToSuperview().priority(.high)
        }
        
        header.addSubview(productLogo)
        productLogo.snp.makeConstraints { make in
            make.top.equalTo(cardView).offset(18)
            make.left.equalTo(cardView).offset(16)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        productLogo.tm.setCorner(10)

        header.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(productLogo.snp.right).offset(6)
            make.centerY.equalTo(productLogo)
        }

        header.addSubview(productAmountLabel)
        productAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(productLogo.snp.top).offset(-2)
            make.right.equalTo(cardView).offset(-16)
            make.width.greaterThanOrEqualTo(80)
            make.height.equalTo(28)
        }

        let tipLabel = itemLabel(font: Constants.pingFangSCRegularFont(14), text: "Loan amount")
        header.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(productAmountLabel.snp.bottom)
            make.centerX.equalTo(productAmountLabel)
        }

        header.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(productLogo.snp.bottom).offset(10)
            make.left.equalTo(productLogo)
            make.height.equalTo(22)
        }

        header.addSubview(accountLabel)
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
            make.left.height.equalTo(dateLabel)
        }
    
        tableView.register(HomeProductCell.self, forCellReuseIdentifier: "RecommandCell")
        tableView.register(HomeProductHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func loadData() {
        APIService.standered.fetchResponseList(api: API.Product.spaceDetail, parameters: ["productId" : product?.id ?? ""]) { model in
            self.recmmendProducts = [ProductModel].deserialize(from: model.list)
            self.tableView.reloadData()
            self.tableView.endRefreshing(at: .top)
        }
    }
    
    private func itemLabel(font: UIFont = Constants.pingFangSCMediumFont(16), text: String? = nil) -> UILabel {
        let lb = UILabel()
        lb.textColor = Constants.pureWhite
        lb.font = font
        lb.text = text
        return lb
    }
    
    private func loanAction(at index: Int) {
        let product = recmmendProducts?[index]
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

// MARK: - TableView Data source And delegate
extension ProductDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recmmendProducts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommandCell", for: indexPath) as! HomeProductCell
        cell.product = recmmendProducts?[indexPath.row]
        cell.loanAction = { [weak self] in
            self?.loanAction(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? HomeProductHeaderView
        header?.title = "Top recommendation"
        return header
    }
}


