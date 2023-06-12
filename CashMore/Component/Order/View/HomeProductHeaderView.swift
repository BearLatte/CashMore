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
        backgroundView = UIView()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(18)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().priority(.high)
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
}
