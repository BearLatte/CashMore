//
//  PersonalnfoController.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit

class PersonalnfoController: BaseScrollController {
    override func configUI() {
        super.configUI()
        title = "Personal info"
        setIndicator(current: 2, count: 4)
        
        contentView.addSubview(cardFrontBtn)
        cardFrontBtn.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 175, height: 95))
        }
        
        let indicatorLb = Constants.indicatorLabel
        contentView.addSubview(indicatorLb)
        indicatorLb.snp.makeConstraints { make in
            make.top.equalTo(cardFrontBtn.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(panNumInputView)
        contentView.addSubview(whatsAppInputView)
        contentView.addSubview(industryInputView)
        contentView.addSubview(workTitleInputView)
        contentView.addSubview(salaryInputView)
        contentView.addSubview(emailInputView)
        contentView.addSubview(paytmInputView)
        contentView.addSubview(nextBtn)
        nextBtn.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
        
        panNumInputView.snp.makeConstraints { make in
            make.top.equalTo(indicatorLb.snp.bottom).offset(6)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        whatsAppInputView.snp.makeConstraints { make in
            make.top.equalTo(panNumInputView.snp.bottom)
            make.left.right.equalTo(panNumInputView)
        }
        
        industryInputView.snp.makeConstraints { make in
            make.top.equalTo(whatsAppInputView.snp.bottom)
            make.left.right.equalTo(panNumInputView)
        }
        
        workTitleInputView.snp.makeConstraints { make in
            make.top.equalTo(industryInputView.snp.bottom)
            make.left.right.equalTo(panNumInputView)
        }
        
        salaryInputView.snp.makeConstraints { make in
            make.top.equalTo(workTitleInputView.snp.bottom)
            make.left.right.equalTo(panNumInputView)
        }
        
        emailInputView.snp.makeConstraints { make in
            make.top.equalTo(salaryInputView.snp.bottom)
            make.left.right.equalTo(panNumInputView)
        }
        
        paytmInputView.snp.makeConstraints { make in
            make.top.equalTo(emailInputView.snp.bottom)
            make.left.right.equalTo(panNumInputView)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.top.equalTo(paytmInputView.snp.bottom).offset(20)
            make.left.equalTo(55)
            make.right.equalTo(-55)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().priority(.high)
        }
    }
    
    private var cardFrontBtn       = Constants.imageOnTopBtn(with: R.image.camera_small(), title: "Pan card Front")
    private var panNumInputView    = FormInputView(title: "Pan Number", placeholder: "Pan Number")
    private var whatsAppInputView  = FormInputView(title: "WhatsApp Account", placeholder: "WhatsApp Account")
    private var industryInputView  = FormInputView(title: "Industry", placeholder: "Industry")
    private var workTitleInputView = FormInputView(title: "Work Title", placeholder: "Work Title")
    private var salaryInputView    = FormInputView(title: "Monthly Salary", placeholder: "Monthly Salary")
    private var emailInputView     = FormInputView(title: "E-mail", placeholder: "E-mail")
    private var paytmInputView     = FormInputView(title: "Paytm Account(Optional)", placeholder: "Paytm Account(Optional)")
    private var nextBtn            = Constants.themeBtn(with: "Next")
    
    @objc func nextBtnAction() {
        navigationController?.pushViewController(ContactInfoController(), animated: true)
    }
}
