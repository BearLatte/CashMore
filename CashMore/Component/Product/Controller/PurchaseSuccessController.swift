//
//  PurchaseSuccessController.swift
//  CashMore
//
//  Created by Tim on 2023/6/14.
//

import UIKit

class PurchaseSuccessController: BaseTableController {
    
    var products : [ProductModel?]?
    
    override func configUI() {
        super.configUI()
        title = "Detail"
        view.backgroundColor = Constants.pureWhite
        tableView.register(HomeProductCell.self, forCellReuseIdentifier: "kProductCell")
        tableView.removePullToRefresh(at: .top)
        
        let headerView = UIView()
        tableView.tableHeaderView = headerView
        headerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(Constants.screenWidth)
            make.right.bottom.equalToSuperview().priority(.high)
        }
        
        let imgView = UIImageView(image: R.image.loan_success_head_img())
        headerView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        let label = UILabel()
        label.font = Constants.pingFangSCRegularFont(14)
        label.textColor = Constants.themeTitleColor
        label.text = "Congratulations! Your application has been\n submitted successfully."
        label.textAlignment = .center
        label.numberOfLines = 0
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        let indicatorLabel = UILabel()
        indicatorLabel.backgroundColor = Constants.themeColor
        indicatorLabel.textColor = Constants.pureWhite
        indicatorLabel.font = Constants.pingFangSCMediumFont(16)
        indicatorLabel.textAlignment = .center
        indicatorLabel.text = "You can apply for a loan for the following\n loans with a high success rate."
        indicatorLabel.numberOfLines = 0
        headerView.addSubview(indicatorLabel)
        indicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(80)
            make.bottom.equalToSuperview().offset(-10).priority(.high)
        }
        indicatorLabel.tm.setCorner(10)
        tableView.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popGestureClose()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        popGestureOpen()
    }
}

extension PurchaseSuccessController {
    override func goBack() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension PurchaseSuccessController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kProductCell", for: indexPath) as! HomeProductCell
        cell.product = products?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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




