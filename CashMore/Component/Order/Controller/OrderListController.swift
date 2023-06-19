//
//  OrderListController.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit

enum OrderListType {
    case all
    case disbursing
    case unrepaid
    case denied
    case repied
    case overdue
    case pending
}

class OrderListController: BaseTableController {
    
    var orders : [OrderModel?]?
    
    init(type: OrderListType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var type : OrderListType
}

extension OrderListController {
    override func configUI() {
        super.configUI()
        isHiddenTitleLabel = true
        isHiddenBackBtn    = true
        view.backgroundColor = Constants.themeBgColor
        tableView.register(OrderCell.self, forCellReuseIdentifier: "OrderCell")
        tableView.snp.remakeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    override func loadData() {
        var params : [String : Any] = [:]
        switch type {
        case .pending:
            params["status"] = "1"
        case .disbursing:
            params["status"] = "2"
        case .unrepaid:
            params["status"] = "3"
        case .denied:
            params["status"] = "5"
        case .repied:
            params["status"] = "4"
        case .overdue:
            params["status"] = "6"
        default: break
        }
        
        APIService.standered.fetchResponseList(api: API.Order.orderList, parameters: params) { model in
            self.orders = [OrderModel].deserialize(from: model.list)
            self.tableView.reloadData()
            self.tableView.endRefreshing(at: .top)
        }
    }
}


// MARK: - Table View Data Source & Table View Delegate
extension OrderListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.order = orders?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ADJustTrackTool.point(name: "63kik0")
        let order = orders?[indexPath.row]
        if order?.status == 0 || order?.status == 1 || order?.status == 7 {
            APIService.standered.fetchModel(api: API.Order.orderDetail, parameters: ["auditOrderNo" : order?.loanOrderNo ?? ""], type: OrderDetailModel.self) { detail in
                let product = ProductModel()
                product.logo = detail.loanAuditOrderVo?.logo
                product.id = detail.loanAuditOrderVo?.productId ?? ""
                product.loanName = detail.loanAuditOrderVo?.loanName ?? ""
                
                if order?.status == 7 {
                    if detail.frozenDays > 0 {
                        let productDetailVC = ProductDetailController()
                        productDetailVC.frozenDays = detail.frozenDays
                        productDetailVC.product = product
                        productDetailVC.orderDetail = detail.loanAuditOrderVo
                        self.navigationController?.pushViewController(productDetailVC, animated: true)
                    } else {
                        let overfreezonVC = OverFreezonOrderController()
                        overfreezonVC.auditOrderNo = order?.loanOrderNo
                        self.navigationController?.pushViewController(overfreezonVC, animated: true)
                    }
                } else {
                    let productDetailVC = ProductDetailController()
                    if order?.status == 0 {
                        productDetailVC.orderType = .pending
                    } else if order?.status == 1 {
                        productDetailVC.orderType = .disbursing
                    } else {
                        productDetailVC.orderType = .overdue
                    }
                    productDetailVC.product = product
                    productDetailVC.orderDetail = detail.loanAuditOrderVo
                    self.navigationController?.pushViewController(productDetailVC, animated: true)
                }
                
            }
        }
        
        if order?.status == 6  {
            let detailVC = DisbursingFailDetailController()
            detailVC.orderNumber = order?.loanOrderNo ?? ""
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
        if order?.status == 5 || order?.status == 2 {
            let controller = ProductRepaidAndOverdueController()
            let product = ProductModel()
            product.loanName = order?.loanName ?? ""
            product.logo = order?.logo ?? ""
            controller.orderType = order?.status == 2 ? .repaid : .overdue
            controller.product = product
            controller.orderDetail = order
            navigationController?.pushViewController(controller, animated: true)
        }
        
        if order?.status == 8 || order?.status == 9 {
            let repaidController = RepaidOrderDetailController()
            repaidController.order = order
            navigationController?.pushViewController(repaidController, animated: true)
        }
    }
}
