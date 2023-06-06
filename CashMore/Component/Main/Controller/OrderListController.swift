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
    init(type: OrderListType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configUI() {
        super.configUI()
        view.backgroundColor = Constants.random
        switch type {
        case .all:
            title = "All Orders"
        case .disbursing:
            title = "Disbursing"
        case .unrepaid:
            title = "To be Repaid"
        case .denied:
            title = "Denied"
        case .repied:
            title = "Repaid"
        case .overdue:
            title = "Overdue"
        case .pending:
            title = "Pending"
        }
    }
    
    private var type : OrderListType
}
