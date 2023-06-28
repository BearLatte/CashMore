//
//  OverFreezonOrderController.swift
//  CashMore
//
//  Created by Tim on 2023/6/19.
//

import UIKit

class OverFreezonOrderController: BaseTableController {
    var auditOrderNo : String?
    private var products : [ProductModel?]?
}

extension OverFreezonOrderController {
    override func configUI() {
        super.configUI()
        title = "Detail"
        
        let indicatorLabel = UILabel()
        indicatorLabel.text = "Congratulations! You can apply\n for a loan right away."
        indicatorLabel.backgroundColor = Constants.themeColor
        indicatorLabel.numberOfLines = 0
        indicatorLabel.font = Constants.pingFangSCSemiboldFont(20)
        indicatorLabel.textColor = Constants.pureWhite
        indicatorLabel.textAlignment = .center
        indicatorLabel.layer.cornerRadius = 10
        indicatorLabel.layer.masksToBounds = true
        view.addSubview(indicatorLabel)
        indicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(indicatorLabel.snp.width).multipliedBy(0.3)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(indicatorLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.register(HomeProductCell.self, forCellReuseIdentifier: "RecommendCell")
        tableView.register(HomeProductHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
    }
}

extension OverFreezonOrderController {
    override func loadData() {
        APIService.standered.fetchResponseList(api: API.Order.orderDetail, parameters: ["auditOrderNo" : auditOrderNo ?? ""]) { model in
            self.products = [ProductModel].deserialize(from: model.list)
            self.tableView.reloadData()
            self.tableView.endRefreshing(at: .top)
        }
    }
}


// MARK: - UITableViewDataSource UITableViewDelegate
extension OverFreezonOrderController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendCell", for: indexPath) as! HomeProductCell
        cell.product = products?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ADJustTrackTool.point(name: "5wz5xn")
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? HomeProductHeaderView
        header?.title = "Top recommendation"
        return header
    }
}
