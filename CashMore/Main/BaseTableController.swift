//
//  BaseTableController.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import UIKit
import PullToRefresh

class BaseTableController: BaseViewController {

    lazy var tableView : UITableView = {
        let tb = UITableView(frame: .zero, style: .plain)
        tb.showsVerticalScrollIndicator = false
        tb.showsHorizontalScrollIndicator = false
        tb.backgroundColor = .clear
        tb.separatorStyle = .none
        return tb
    }()
    
    override func configUI() {
        super.configUI()
        let pull2refresh = PullToRefresh()
        pull2refresh.setEnable(isEnabled: true)
        tableView.addPullToRefresh(pull2refresh) {
            self.loadData()
        }
        
        tableView.dataSource = self
        tableView.delegate   = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    deinit {
        tableView.removeAllPullToRefresh()
    }
}

extension BaseTableController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { UITableViewCell() }
}

extension BaseTableController : UITableViewDelegate {}

