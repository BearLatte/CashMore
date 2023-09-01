//
//  HomeController.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//

import UIKit
import PullToRefresh
import CoreTelephony

class HomeController: BaseTableController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private var products : [ProductModel?] = []
    private weak var headerView : HomeHeaderView!
    private var userInfo : UserInfoModel?
    private let payFailAlert = PayFailAlertView()
}

extension HomeController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: kNetworkStatusNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Constants.networkStateChangedNotification, object: nil)
    }
    
    override func loadData() {
        if Constants.isLogin {
            APIService.standered.fetchModel(api: API.Me.userInfo, type: UserInfoModel.self) { [weak self] userInfo in
                // save user phone number
                UserDefaults.standard.setValue(userInfo.phone, forKey: Constants.USER_PHONE_NUMBER)
                
                self?.products = userInfo.loanProductList
                self?.tableView.reloadData()
                self?.tableView.endRefreshing(at: .top)
                if userInfo.userPayFail {
                    self?.showPayFailAlert(payFailModel: userInfo.userPayFailInfo)
                }
            }
        } else {
            APIService.standered.fetchList(api: API.Home.productList, type: ProductModel(), listPath: "loanProductList") { [weak self] products in
                self?.products = products
                self?.tableView.reloadData()
                self?.tableView.endRefreshing(at: .top)
            }
        }
    }
    
    
    private func showPayFailAlert(payFailModel: PayFailInfo?) {
        if payFailAlert.isShowing || payFailModel == nil {
            return
        }
        
        payFailAlert.payFailInfo = payFailModel
        payFailAlert.show()
    }
    
    @objc func didReceiveLoginSuccessNotification(_ not: Notification) {
        loadData()
        headerView.reloadBanner()
    }
    
    
    private func loanAction(product: ProductModel?) {
        APIService.standered.fetchModel(api: API.Product.spaceDetail, parameters: ["productId" : product?.id ?? ""], type: UserInfoModel.self) { userInfo in
            self.userInfo = userInfo
            if userInfo.userStatus != 1 {
                ADJustTrackTool.point(name: "e5out2")
            }
            switch userInfo.userStatus {
            case 1:
                break
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
                let orderDetailVC = OrderDetailController()
                orderDetailVC.orderNumber = userInfo.loanAuditOrderVo.loanOrderNo
                self.navigationController?.pushViewController(orderDetailVC, animated: true)
            }
        }
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
            Constants.toLogin()
        }
    }
    
    func headerViewOdersTapAction(headerView: HomeHeaderView) {
        ADJustTrackTool.point(name: "wu4ut2")
        if Constants.isLogin {
            navigationController?.pushViewController(OrderPagingController(), animated: true)
        } else {
            Constants.toLogin()
        }
    }
    
    func headerViewMeTapAction(headerView: HomeHeaderView) {
        if userInfo?.userStatus == 1{
            ADJustTrackTool.point(name: "qrf7g3")
        }
        let vc = PersonalCenterController()
        navigationController?.pushViewController(vc, animated: true)
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
            Constants.toLogin()
            return
        }
        
        let product = products[indexPath.row]
        
        // 查询认证状态
        APIService.standered.fetchModel(api: API.Certification.info, parameters: ["type" : "1"], type: CertificationInfoModel.self) { model in
            if model.authStatus {
                self.loanAction(product: product)
            } else {
                ADJustTrackTool.point(name: "tijhtx")
                let kycController = KYCInfoController()
                kycController.pattern = .present
                kycController.certificationModel = model
                let nav = UINavigationController(rootViewController: kycController)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? HomeProductHeaderView
        header?.title = "Top recommendation"
        header?.refreshBtn.isHidden = Constants.isLogin
        header?.refreshBtn.addTarget(self, action: #selector(loadData), for: .touchUpInside)
        return header
    }
}
