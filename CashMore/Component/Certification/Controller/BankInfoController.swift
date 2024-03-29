//
//  BankInfoController.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit

class BankInfoController: BaseScrollController {
    var isModify = false
    var certificationModel : CertificationInfoModel?
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
    private lazy var accountInputView  = FormInputView(title: "Account Number", placeholder: "Account Number", keyboardType: .numberPad)
    private lazy var ifscInputView     = FormInputView(title: "IFSC Code", placeholder: "IFSC Code")
    private lazy var submitBtn         = Constants.themeBtn(with: "Submit")
    
    
}

extension BankInfoController {
    override func loadData() {
        if isModify {
            APIService.standered.fetchModel(api: API.Certification.info, parameters: ["type" : "2", "step" : "loanapiUserBankCard"], type: CertificationBankInfoModel.self) { bankInfo in
                self.bankNameInputView.inputText = bankInfo.bankName
                self.accountInputView.inputText = bankInfo.bankCardNo
                self.ifscInputView.inputText = bankInfo.ifscCode
            }
        }
    }
    
    @objc func submitBtnClicked() {
        if(!isModify) {
            ADJustTrackTool.point(name: "w8lxuy")
        }
        
        guard let bankName = bankNameInputView.inputText, !bankName.tm.isBlank else {
            return HUD.flash(.label("Bank Name cannot be empty"), delay: 2.0)
        }
        guard let bankAccount = accountInputView.inputText, !bankAccount.tm.isBlank else {
            return HUD.flash(.label("Account Number cannot be empty"), delay: 2.0)
        }
        guard let ifscCode = ifscInputView.inputText, !ifscCode.tm.isBlank else {
            return HUD.flash(.label("IFSC should be in 11 digit numbers or letters"), delay: 2.0)
        }
        let params = ["bankName": bankName, "bankCardNo" : bankAccount, "bankCardNoPaste" : "0", "ifscCode" : ifscCode]
        
        if(isModify) {
            APIService.standered.normalRequest(api: API.Me.changeBankCard, parameters: params) {
                HUD.flash(.labeledSuccess(title: nil, subtitle: "Success"), delay: 2.0)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            TipsSheet.show(isHiddenTitle: false, message: "The information cannot be changed after submission. Please fill in the correct information.", confirmAction:  {
                APIService.standered.normalRequest(api: API.Certification.bankAuth, parameters: params) {
                    self.getRecommendProduct()
                }
            })
        }
        
    }
    
    // 获取推荐产品
    private func getRecommendProduct() {
        APIService.standered.fetchModel(api: API.Me.userInfo, parameters: ["isRecommend" : "1"], type: UserInfoModel.self) { userInfo in
            if (userInfo.loanProductVo?.productId ?? "").tm.isBlank {
                self.dismiss(animated: true)
            } else {
                let purchaseVC = PurchaseController()
                purchaseVC.isRecommend = true
                purchaseVC.productDetail = userInfo.loanProductVo
                self.navigationController?.pushViewController(purchaseVC, animated: true)
            }
        }
    }
}
