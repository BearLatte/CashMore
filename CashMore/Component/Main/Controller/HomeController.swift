//
//  HomeController.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//

import UIKit

class HomeController: BaseViewController {

    override func configUI() {
        super.configUI()
        title = "Home Page"
        isHiddenBackBtn = true
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        let headerView = HomeHeaderView()
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        headerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(Constants.screenWidth)
            make.bottom.equalToSuperview().priority(.high)
        }
        tableView.layoutIfNeeded()
    }
    
    private lazy var tableView : UITableView = { [weak self] in
        let table = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(HomeProductHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        table.register(HomeProductCell.self, forCellReuseIdentifier: "ProductCell")
        return table
    }()
    
    let products = [
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "5.0"),
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "4.7"),
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "4.5"),
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "4.9"),
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "5.0"),
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "4.5"),
    ]
}

extension HomeController : HomeHeaderViewDelegate {
    func headerViewBanerTapAction(headerView: HomeHeaderView) {
        Constants.debugLog(headerView)
    }
    
    func headerViewFeedbackTapAction(headerView: HomeHeaderView) {
        Constants.debugLog(headerView)
    }
    
    func headerViewOdersTapAction(headerView: HomeHeaderView) {
        Constants.debugLog(headerView)
    }
    
    func headerViewMeTapAction(headerView: HomeHeaderView) {
        Constants.debugLog(headerView)
    }
    
    
}

extension HomeController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! HomeProductCell
        cell.product = products[indexPath.row]
        return cell
    }
    
}

extension HomeController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? HomeProductHeaderView
        header?.title = "Top recommendation"
        return header
    }
}
