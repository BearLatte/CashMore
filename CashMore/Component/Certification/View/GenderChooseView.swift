//
//  GenderChooseView.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit

class GenderChooseView: UIView {
    
    var selectedGender : String? {
        if maleBtn.isSelected {
            return "male"
        } else if femaleBtn.isSelected {
            return "female"
        } else {
            return nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(maleBtn)
        addSubview(femaleBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.height.equalTo(25)
        }
        
        maleBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(self.snp.centerX).offset(-4)
            make.height.equalTo(35)
        }
        
        femaleBtn.snp.makeConstraints { make in
            make.top.equalTo(maleBtn)
            make.right.equalToSuperview()
            make.height.equalTo(maleBtn)
            make.left.equalTo(self.snp.centerX).offset(4)
            make.bottom.equalToSuperview().priority(.high)
        }
    }
    
    private lazy var titleLabel : UILabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCMediumFont(18)
        lb.textColor = Constants.themeTitleColor
        lb.text = "Gender"
        return lb
    }()
    
    private let bgImgNormal = R.image.gender_bg_normal()?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0), resizingMode: .stretch)
    private let bgImgSelected = R.image.gender_bg_selected()?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0), resizingMode: .stretch)
    
    private lazy var maleBtn = {
        let btn = UIButton(type: .custom)
        btn.setTitle("male", for: .normal)
        btn.setTitleColor(Constants.placeholderTextColor, for: .normal)
        btn.setTitleColor(Constants.themeColor, for: .selected)
        btn.setBackgroundImage(bgImgNormal, for: .normal)
        btn.setBackgroundImage(bgImgSelected, for: .selected)
        btn.addTarget(self, action: #selector(genderBtnClicked), for: .touchUpInside)
        btn.titleLabel?.font = Constants.pingFangSCRegularFont(16)
        return btn
    }()
    
    private lazy var femaleBtn = {
        let btn = UIButton(type: .custom)
        btn.setTitle("female", for: .normal)
        btn.setTitleColor(Constants.placeholderTextColor, for: .normal)
        btn.setTitleColor(Constants.themeColor, for: .selected)
        btn.setBackgroundImage(bgImgNormal, for: .normal)
        btn.setBackgroundImage(bgImgSelected, for: .selected)
        btn.addTarget(self, action: #selector(genderBtnClicked), for: .touchUpInside)
        btn.titleLabel?.font = Constants.pingFangSCRegularFont(16)
        return btn
    }()
    
    @objc func genderBtnClicked(_ btn: UIButton) {
        if btn == maleBtn {
            maleBtn.isSelected = true
            femaleBtn.isSelected = false
        } else {
            maleBtn.isSelected = false
            femaleBtn.isSelected = true
        }
    }
}
