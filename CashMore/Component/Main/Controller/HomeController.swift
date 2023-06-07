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
        
        
//        NTTool.fetch(API.Home.productList,parameters: [:])
//            .success { JSON in
//                Constants.debugLog("请求成功了\(JSON)")
//            }
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
    
    let products : [ProductModel] = [
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "5.0"),
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "4.7"),
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "4.5"),
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "4.9"),
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "5.0"),
        ProductModel(amount: "20000", amountTip: "Loan amount", desc: "Fee 0.1% / day 200 days", productName: "Freecash", score: "4.5")
    ]
}

extension HomeController : HomeHeaderViewDelegate {
    func headerViewBanerTapAction(headerView: HomeHeaderView) {
        Constants.debugLog(headerView)
    }
    
    func headerViewFeedbackTapAction(headerView: HomeHeaderView) {
        if Constants.isLogin {
            navigationController?.pushViewController(FeedbackController(), animated: true)
        } else {
            let login = LoginController()
            login.pattern = .present
            login.modalPresentationStyle = .fullScreen
            self.present(login, animated: true)
        }
    }
    
    func headerViewOdersTapAction(headerView: HomeHeaderView) {
        if Constants.isLogin {
            navigationController?.pushViewController(OrderPagingController(), animated: true)
        } else {
            let login = LoginController()
            login.pattern = .present
            login.modalPresentationStyle = .fullScreen
            self.present(login, animated: true)
        }
    }
    
    func headerViewMeTapAction(headerView: HomeHeaderView) {
        navigationController?.pushViewController(PersonalCenterController(), animated: true)
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
        cell.loanAction = { [weak self] in
            if Constants.isLogin && Constants.isCertified {
                
            } else if !Constants.isLogin {
                let loginView = LoginController()
                loginView.pattern = .present
                loginView.modalPresentationStyle = .fullScreen
                self?.present(loginView, animated: true)
            } else if !Constants.isCertified {
                self?.navigationController?.pushViewController(KYCInfoController(), animated: true)
            }
        }
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
