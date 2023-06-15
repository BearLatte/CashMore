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
//        var detail : OrderDetailController
//        if indexPath.row == 0 {
//
//        }
//        navigationController?.pushViewController(PendingOrderDetailController(), animated: true)
    }
}
