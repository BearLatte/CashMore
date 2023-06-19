//
//  PersonalCenterController.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import UIKit

class PersonalCenterController: BaseTableController {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var headerView = PersonalCenterHeaderView()
    private lazy var logoutBtn = {
        let btn = UIButton(type: .custom)
        btn.isHidden = !Constants.isLogin
        btn.setTitle("Logout", for: .normal)
        btn.backgroundColor = Constants.darkBtnBgColor
        btn.setTitleColor(Constants.pureWhite, for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCMediumFont(18)
        btn.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        return btn
    }()
}


// MARK: - Config UI
extension PersonalCenterController {
    override func configUI() {
        super.configUI()
        view.backgroundColor = Constants.pureWhite
        title = "Personal center"
        tableView.removePullToRefresh(at: .top)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        tableView.tableHeaderView = headerView
        headerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(Constants.screenWidth)
        }
        headerView.layoutIfNeeded()
        headerView.reloadData()

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 90))
        tableView.tableFooterView = footerView

        footerView.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 160, height: 50))
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().priority(.high)
        }
        logoutBtn.tm.setCorner(25)

        tableView.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLoginSuccessNotification), name: Constants.loginSuccessNotification, object: nil)
    }
}

// MARK: - Private
extension PersonalCenterController {
    @objc func logoutAction() {
        APIService.standered.normalRequest(api: API.Login.logOut) {
            UserDefaults.standard.setValue(false, forKey: Constants.IS_LOGIN)
            UserDefaults.standard.setValue(nil, forKey: Constants.ACCESS_TOKEN)
            UserDefaults.standard.setValue(nil, forKey: Constants.UID_KEY)
            NotificationCenter.default.post(name: Constants.logoutSuccessNotification, object: nil)
            self.headerView.reloadData()
            self.logoutBtn.isHidden = true
        }
    }
    
    @objc func didReceiveLoginSuccessNotification(_ not: Notification) {
        headerView.reloadData()
        logoutBtn.isHidden = false
    }
}


// MARK: - UITableViewDataSource UITableViewDelegate
extension PersonalCenterController {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {4}
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.selectionStyle = .none
        var title : String?, icon : UIImage?, indicator : UIImage? = R.image.arrow_right()
        switch indexPath.row {
        case 0:
            title = "Change Bank Info"
            icon  = R.image.bank_card()
        case 1:
            title = "About Us"
            icon  = R.image.about_us()
        case 2:
            title = "Privacy Policy"
            icon  = R.image.privacy()
        case 3:
            title = "Delete account"
            icon  = R.image.delete()
        default: break
        }
        if #available(iOS 14.0, *) {
            var cellContent = cell.defaultContentConfiguration()
            cellContent.text  = title
            cellContent.image = icon
            cellContent.textProperties.font = Constants.pingFangSCRegularFont(18)
            cellContent.textProperties.color = Constants.themeTitleColor
            cell.contentConfiguration = cellContent
        } else {
            cell.textLabel?.text = title
            cell.textLabel?.textColor = Constants.themeTitleColor
            cell.textLabel?.font = Constants.pingFangSCRegularFont(18)
            cell.imageView?.image = icon
        }
        cell.accessoryView = UIImageView(image: indicator)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            ADJustTrackTool.point(name: "h9gm4g")
            if Constants.isLogin {
                let bankVC = BankInfoController()
                bankVC.isModify = true
                navigationController?.pushViewController(bankVC, animated: true)
            } else {
                Constants.toLogin()
            }
        case 1:
            navigationController?.pushViewController(AboutUsController(), animated: true)
        case 2: break
        case 3:
            logoutAction()
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {55.0}
}
