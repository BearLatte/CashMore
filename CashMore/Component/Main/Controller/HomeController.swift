//
//  HomeController.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//

import UIKit
import PullToRefresh

class HomeController: BaseTableController {

    override func configUI() {
        super.configUI()
        title = "Home Page"
        isHiddenBackBtn = true
        tableView.register(HomeProductHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        tableView.register(HomeProductCell.self, forCellReuseIdentifier: "ProductCell")
//        view.addSubview(tableView)
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(10)
//            make.left.right.bottom.equalToSuperview()
//        }
//
        let headerView = HomeHeaderView()
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        headerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(Constants.screenWidth)
            make.bottom.equalToSuperview().priority(.high)
        }
        tableView.layoutIfNeeded()
        
        let refresher = PullToRefresh()
        refresher.setEnable(isEnabled: true)
        tableView.addPullToRefresh(refresher) { [weak self] in
            self?.loadData()
        }
    }
    
    override func loadData() {
        APIService.standered.fetchList(api: API.Home.productList, type: ProductModel(), listPath: "loanProductList") { [weak self] products in
            self?.products = products
            self?.tableView.reloadData()
            self?.tableView.endRefreshing(at: .top)
        }
    }
    
//    private lazy var tableView : UITableView = { [weak self] in
//        let table = UITableView(frame: .zero, style: .grouped)
//        table.showsVerticalScrollIndicator = false
//        table.backgroundColor = .clear
//        table.delegate = self
//        table.dataSource = self
//        table.separatorStyle = .none
//        table.register(HomeProductHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
//        table.register(HomeProductCell.self, forCellReuseIdentifier: "ProductCell")
//        return table
//    }()
    
    var products : [ProductModel?] = []
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

extension HomeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {products.count}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? HomeProductHeaderView
        header?.title = "Top recommendation"
        return header
    }
}
