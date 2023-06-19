//
//  HomeController.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//

import UIKit
import PullToRefresh

class HomeController: BaseTableController {

    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var products : [ProductModel?] = []
    private weak var headerView : HomeHeaderView!
    
    private var userInfo : UserInfoModel?
}

extension HomeController {
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
    
    override func loadData() {
        if Constants.isLogin {
            APIService.standered.fetchModel(api: API.Me.userInfo, type: UserInfoModel.self) { [weak self] userInfo in
                self?.products = userInfo.loanProductList
                self?.tableView.reloadData()
                self?.tableView.endRefreshing(at: .top)
            }
        } else {
            APIService.standered.fetchList(api: API.Home.productList, type: ProductModel(), listPath: "loanProductList") { [weak self] products in
                self?.products = products
                self?.tableView.reloadData()
                self?.tableView.endRefreshing(at: .top)
            }
        }
    }
    
    @objc func didReceiveLoginSuccessNotification(_ not: Notification) {
        loadData()
        headerView.reloadBanner()
    }
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
        ADJustTrackTool.point(name: "wu4ut2")
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
        if userInfo?.userStatus == 1{
            ADJustTrackTool.point(name: "qrf7g3")
        }
        navigationController?.pushViewController(PersonalCenterController(), animated: true)
    }
    
    
}

extension HomeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {products.count}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! HomeProductCell
        cell.product = products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !Constants.isLogin {
            let loginView = LoginController()
            loginView.pattern = .present
            loginView.modalPresentationStyle = .fullScreen
            present(loginView, animated: true)
            return
        }
        
        let product = products[indexPath.row]
        
        APIService.standered.fetchModel(api: API.Product.spaceDetail, parameters: ["productId" : product?.id ?? ""], type: UserInfoModel.self) { userInfo in
            self.userInfo = userInfo
            if userInfo.userStatus != 1 {
                ADJustTrackTool.point(name: "e5out2")
            }
            switch userInfo.userStatus {
            case 1:
                ADJustTrackTool.point(name: "tijhtx")
                let kycController = KYCInfoController()
                kycController.pattern = .present
                let nav = UINavigationController(rootViewController: kycController)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            case 2:
                let purchaseVC = PurchaseController()
                purchaseVC.productDetail = userInfo.loanProductVo
                self.navigationController?.pushViewController(purchaseVC, animated: true)
            case 3, 4, 5:
                let productDetailVC = ProductDetailController()
                if userInfo.userStatus == 5 {
                    productDetailVC.frozenDays = userInfo.frozenDays
                }
                productDetailVC.orderType = OrderType(rawValue: userInfo.userStatus) ?? .pending
                productDetailVC.product = product
                productDetailVC.orderDetail = userInfo.loanAuditOrderVo
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            default:
                let vc = ProductRepaidAndOverdueController()
                vc.orderType = OrderType(rawValue: userInfo.userStatus) ?? .repaid
                vc.product = product
                vc.orderDetail = userInfo.loanAuditOrderVo
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? HomeProductHeaderView
        header?.title = "Top recommendation"
        return header
    }
}
