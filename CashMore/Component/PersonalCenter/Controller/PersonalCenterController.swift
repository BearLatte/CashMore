//
//  PersonalCenterController.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import UIKit

class PersonalCenterController: BaseTableController {

    override func configUI() {
        super.configUI()
        view.backgroundColor = Constants.pureWhite
        title = "Personal center"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        let headerView = UIView()
        tableView.tableHeaderView = headerView
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().priority(.high)
        }
        
        let headImg = UIImageView(image: R.image.personal_head())
        headerView.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(Constants.screenWidth - 20)
        }
        
        headerView.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.top.equalTo(headImg.snp.bottom).offset(40)
            make.size.equalTo(CGSize(width: 66, height: 66))
            make.centerX.equalToSuperview()
        }
        
        headerView.addSubview(uidLabel)
        uidLabel.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(6)
            make.centerX.equalTo(logoView)
            make.bottom.equalToSuperview().offset(-25).priority(.high)
        }

        let footerView = UIView()
        footerView.backgroundColor = Constants.random
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
    }
    
    private lazy var logoView = {
        let logo = UIImageView(image: R.image.logo())
        logo.alpha = 0.3
        logo.layer.cornerRadius = 33
        logo.layer.masksToBounds = true
        return logo
    }()
    
    private lazy var uidLabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCSemiboldFont(20)
        lb.text = "Please log in"
        return lb
    }()
    
    private lazy var logoutBtn = {
        let btn = UIButton(type: .custom)
        btn.isHidden = true
        btn.setTitle("Logout", for: .normal)
        btn.backgroundColor = Constants.darkBtnBgColor
        btn.setTitleColor(Constants.pureWhite, for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCMediumFont(18)
        return btn
    }()
    
    private var isLogin = UserDefaults.standard.bool(forKey: Constants.IS_LOGIN) {
        didSet {
            logoView.alpha = isLogin ? 1 : 0.3
            uidLabel.text  = isLogin ? "" : "Please log in"
            logoutBtn.isHidden = !isLogin
        }
    }
    
}

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
        case 0: break
        case 1:
            navigationController?.pushViewController(AboutUsController(), animated: true)
        case 2: break
        case 3: break
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {55.0}
}
