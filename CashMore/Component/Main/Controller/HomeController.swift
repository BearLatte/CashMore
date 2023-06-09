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

        let headerView = HomeHeaderView()
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        headerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(Constants.screenWidth)
            make.bottom.equalToSuperview().priority(.high)
        }
        headerView.reloadBanner()
        tableView.layoutIfNeeded()
        self.headerView = headerView
        
        let refresher = PullToRefresh()
        refresher.setEnable(isEnabled: true)
        tableView.addPullToRefresh(refresher) { [weak self] in
            self?.loadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLoginSuccessNotification), name: Constants.loginSuccessNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadData() {
        APIService.standered.fetchList(api: API.Home.productList, type: ProductModel(), listPath: "loanProductList") { [weak self] products in
            self?.products = products
            self?.tableView.reloadData()
            self?.tableView.endRefreshing(at: .top)
        }
    }
    
    @objc func didReceiveLoginSuccessNotification(_ not: Notification) {
        headerView.reloadBanner()
        tableView.reloadData()
    }
    
    private var products : [ProductModel?] = []
    private weak var headerView : HomeHeaderView!
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
            self?.loanAction()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? HomeProductHeaderView
        header?.title = "Top recommendation"
        return header
    }
}

extension HomeController {
    func loanAction() {
        if !Constants.isLogin {
            let loginView = LoginController()
            loginView.pattern = .present
            loginView.modalPresentationStyle = .fullScreen
            present(loginView, animated: true)
            return
        }
        
        APIService.standered.fetchModel(api: API.Certification.info, parameters: ["type" : "1"], type: CertificationInfoModel.self) { model in
            if !model.authStatus {
                let kycController = KYCInfoController()
                kycController.pattern = .present
                let nav = UINavigationController(rootViewController: kycController)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
}
