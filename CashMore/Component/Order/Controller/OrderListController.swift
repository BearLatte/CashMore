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
    
    let orders : [OrderModel] = [
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "disbursing"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "unrepaid"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "denied"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "repied"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "overdue"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "pending"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "disbursing"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "unrepaid"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "denied"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "repied"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "overdue"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "pending"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "disbursing"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "unrepaid"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "denied"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "repied"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "overdue"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "pending"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "disbursing"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "unrepaid"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "denied"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "repied"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "overdue"),
        OrderModel(orderNumber: "JKD1232312312312312312", productName: "Freecash", date: "30-12-2020", amount: "2000", orderType: "pending")
    ]
    
    init(type: OrderListType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private var type : OrderListType
}

extension OrderListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.order = orders[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var detail : OrderDetailController
//        if indexPath.row == 0 {
//
//        }
//        navigationController?.pushViewController(PendingOrderDetailController(), animated: true)
    }
}
