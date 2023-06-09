//
//  PersonalCenterHeaderView.swift
//  CashMore
//
//  Created by Tim on 2023/6/9.
//

import UIKit

class PersonalCenterHeaderView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headImgView)
        addSubview(logoView)
        addSubview(uidLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headImgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(headImgView.snp.bottom).offset(40)
            make.size.equalTo(CGSize(width: 66, height: 66))
            make.centerX.equalToSuperview()
        }
        
        uidLabel.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(6)
            make.centerX.equalTo(logoView)
            make.bottom.equalToSuperview().offset(-25).priority(.high)
        }
    }
    
    
    func reloadData() {
        logoView.alpha = Constants.isLogin ? 1 : 0.3
        uidLabel.text = Constants.uid
    }
    
    
    private lazy var headImgView = UIImageView(image: R.image.personal_head())
    
    private lazy var logoView = {
        let logo = UIImageView(image: R.image.logo())
        logo.layer.cornerRadius = 33
        logo.layer.masksToBounds = true
        return logo
    }()
    
    private lazy var uidLabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCSemiboldFont(20)
        return lb
    }()
    
    
}
