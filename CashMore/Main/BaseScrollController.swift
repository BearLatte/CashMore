//
//  BaseScrollController.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit

class BaseScrollController: BaseViewController {
    override func configUI() {
        super.configUI()
        view.addSubview(indicatorLabel)
        indicatorLabel.snp.makeConstraints { make in
            make.right.equalTo(-18)
            make.centerY.equalTo(titleLabel)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(Constants.screenWidth)
            make.bottom.equalToSuperview().priority(.high)
        }
    }

    private lazy var scrollView = {
        let v = UIScrollView()
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        return v
    }()
    
    lazy var contentView = UIView()
    
    private lazy var indicatorLabel = {
        let lb = UILabel()
        return lb
    }()
    
    func setIndicator(current: Int, count: Int) {
        let currentStr = NSAttributedString(string: "\(current)", attributes: [.foregroundColor : Constants.themeColor, .font : Constants.pingFangSCMediumFont(18)])
        let countStr   = NSAttributedString(string: "/\(count)", attributes: [.foregroundColor : Constants.themeTitleColor, .font : Constants.pingFangSCRegularFont(14)])
        let indicatorStr = NSMutableAttributedString(attributedString: currentStr)
        indicatorStr.append(countStr)
        indicatorLabel.attributedText = indicatorStr
    }
}
