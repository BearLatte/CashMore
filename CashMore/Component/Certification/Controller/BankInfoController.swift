//
//  BankInfoController.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit

class BankInfoController: BaseScrollController {
    override func configUI() {
        super.configUI()
        title = "Bank Info"
        setIndicator(current: 4, count: 4)
        let imgView = UIImageView(image: R.image.bank_info_head())
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(bankNameInputView)
        contentView.addSubview(accountInputView)
        contentView.addSubview(ifscInputView)
        contentView.addSubview(submitBtn)
        
        bankNameInputView.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(40)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        accountInputView.snp.makeConstraints { make in
            make.top.equalTo(bankNameInputView.snp.bottom).offset(15)
            make.left.right.equalTo(bankNameInputView)
        }
        
        ifscInputView.snp.makeConstraints { make in
            make.top.equalTo(accountInputView.snp.bottom).offset(15)
            make.left.right.equalTo(bankNameInputView)
        }
        
        submitBtn.snp.makeConstraints { make in
            make.top.equalTo(ifscInputView.snp.bottom).offset(30)
            make.left.equalTo(55)
            make.right.equalTo(-55)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().priority(.high)
        }
        submitBtn.addTarget(self, action: #selector(submitBtnClicked), for: .touchUpInside)
    }
    
    private lazy var bankNameInputView = FormInputView(title: "Bank Name", placeholder: "Bank Name")
    private lazy var accountInputView  = FormInputView(title: "Account Number", placeholder: "Account Number")
    private lazy var ifscInputView     = FormInputView(title: "IFSC Code", placeholder: "IFSC Code")
    private lazy var submitBtn         = Constants.themeBtn(with: "Submit")
    
    @objc func submitBtnClicked() {
        TipsSheet.show(isHiddenTitle: false, message: "The information cannot be changed after submission. Please fill in the correct information.", confirmAction:  {
            Constants.debugLog("Sure action")
        })
    }
}
