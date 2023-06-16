//
//  ProblemChooseView.swift
//  CashMore
//
//  Created by Tim on 2023/6/16.
//

import UIKit

class ProblemChooseView: UIView {
    
    var selectedProblem : String? {
        if repaymentBtn.isSelected {
            return repaymentBtn.titleLabel?.text
        }
        
        if loanBtn.isSelected {
            return loanBtn.titleLabel?.text
        }
        
        if appBtn.isSelected {
            return appBtn.titleLabel?.text
        }
        
        if otherBtn.isSelected {
            return otherBtn.titleLabel?.text
        }
        
        return nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(repaymentBtn)
        repaymentBtn.addTarget(self, action: #selector(repaymentBtnClicked), for: .touchUpInside)
        addSubview(loanBtn)
        loanBtn.addTarget(self, action: #selector(loanBtnClicked), for: .touchUpInside)
        addSubview(appBtn)
        appBtn.addTarget(self, action: #selector(appBtnClicked), for: .touchUpInside)
        addSubview(otherBtn)
        otherBtn.addTarget(self, action: #selector(otherBtnClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(10)
            make.height.equalTo(25)
        }
        
        repaymentBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(self.snp.centerX).offset(-4)
            make.height.equalTo(44)
        }
        
        loanBtn.snp.makeConstraints { make in
            make.top.height.equalTo(repaymentBtn)
            make.left.equalTo(self.snp.centerX).offset(4)
            make.right.equalToSuperview()
        }
        
        appBtn.snp.makeConstraints { make in
            make.top.equalTo(repaymentBtn.snp.bottom).offset(3)
            make.left.right.height.equalTo(repaymentBtn)
        }
        
        otherBtn.snp.makeConstraints { make in
            make.top.equalTo(appBtn)
            make.left.right.height.equalTo(loanBtn)
            make.bottom.equalToSuperview().offset(-20).priority(.high)
        }
    }
    
    private lazy var titleLabel : UILabel = {
        let lb = UILabel()
        lb.text = "Type of problem"
        lb.font = Constants.pingFangSCMediumFont(18)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    // 还款问题按钮
    private lazy var repaymentBtn = createProblemBtn(title: "Repayment problem")
    // 下单问题按钮
    private lazy var loanBtn = createProblemBtn(title: "Loan problem")
    // app 问题按钮
    private lazy var appBtn = createProblemBtn(title: "App problem")
    // 其他问题按钮
    private lazy var otherBtn = createProblemBtn(title: "Other problem")
    
    
    private let bgImgNormal = R.image.gender_bg_normal()?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0), resizingMode: .stretch)
    private let bgImgSelected = R.image.gender_bg_selected()?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0), resizingMode: .stretch)
}

extension ProblemChooseView {
    private func createProblemBtn(title: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCRegularFont(16)
        btn.setTitleColor(Constants.themeColor, for: .selected)
        btn.setTitleColor(Constants.themeDisabledColor, for: .normal)
        btn.setBackgroundImage(bgImgNormal, for: .normal)
        btn.setBackgroundImage(bgImgSelected, for: .selected)
        return btn
    }
    
    @objc func repaymentBtnClicked() {
        repaymentBtn.isSelected = true
        loanBtn.isSelected = false
        appBtn.isSelected = false
        otherBtn.isSelected = false
    }
    
    @objc func loanBtnClicked() {
        repaymentBtn.isSelected = false
        loanBtn.isSelected = true
        appBtn.isSelected = false
        otherBtn.isSelected = false
    }
    
    @objc func appBtnClicked() {
        repaymentBtn.isSelected = false
        loanBtn.isSelected = false
        appBtn.isSelected = true
        otherBtn.isSelected = false
    }
    
    @objc func otherBtnClicked() {
        repaymentBtn.isSelected = false
        loanBtn.isSelected = false
        appBtn.isSelected = false
        otherBtn.isSelected = true
    }
}
