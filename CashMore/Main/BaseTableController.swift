//
//  BaseTableController.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import UIKit

class BaseTableController: BaseViewController {

    lazy var tableView : UITableView = {
        let tb = UITableView(frame: .zero, style: .plain)
        tb.showsVerticalScrollIndicator = false
        tb.showsHorizontalScrollIndicator = false
        tb.backgroundColor = .clear
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate   = self
        return tb
    }()
    
    override func configUI() {
        super.configUI()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension BaseTableController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { UITableViewCell() }
}

extension BaseTableController : UITableViewDelegate {}

