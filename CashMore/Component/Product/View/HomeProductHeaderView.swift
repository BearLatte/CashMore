//
//  HomeProductHeaderView.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//

import UIKit

class HomeProductHeaderView: UITableViewHeaderFooterView {
    var title : String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let view = UIView()
        view.backgroundColor = Constants.themeBgColor
        backgroundView = view
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(18)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().priority(.high)
        }
        
        contentView.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { make in
            make.right.equalTo(-18)
            make.size.equalTo(CGSize(width: 85, height: 30))
            make.centerY.equalTo(titleLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeProductTitleColor
        lb.textAlignment = .left
        lb.font = Constants.pingFangSCMediumFont(22)
        return lb
    }()
    
    lazy var refreshBtn = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Refresh", for: .normal)
        btn.backgroundColor = Constants.themeColor
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.isHidden = true
        return btn
    }()
}
