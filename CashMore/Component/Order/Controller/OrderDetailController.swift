//
//  OrderDetailController.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

import UIKit

class OrderDetailController: BaseTableController {
    
    init(desc: String) {
        self.desc = desc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configUI() {
        super.configUI()
    }
    
    private var desc : String
}
