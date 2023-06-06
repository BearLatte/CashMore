//
//  ContactInfoController.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit

class ContactInfoController : BaseScrollController {
    override func configUI() {
        super.configUI()
        title = "Contact info"
        setIndicator(current: 3, count: 4)
        
        contentView.addSubview(parentItem)
        contentView.addSubview(familyItem)
        contentView.addSubview(colleagueItem)
        contentView.addSubview(nextBtn)
        
        parentItem.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        familyItem.snp.makeConstraints { make in
            make.top.equalTo(parentItem.snp.bottom)
            make.left.right.equalTo(parentItem)
        }
        
        colleagueItem.snp.makeConstraints { make in
            make.top.equalTo(familyItem.snp.bottom)
            make.left.right.equalTo(parentItem)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.top.equalTo(colleagueItem.snp.bottom).offset(30)
            make.left.equalTo(55)
            make.right.equalTo(-55)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().priority(.high)
        }
        nextBtn.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
    }
    
    private lazy var parentItem = ContactInfoInputView(title: "Parents Contact"){
        Constants.debugLog("parents Contact")
    }
    
    private lazy var familyItem = ContactInfoInputView(title: "Family Contact") {
        Constants.debugLog("Family Contact")
    }
    
    private lazy var colleagueItem = ContactInfoInputView(title: "Colleague Contact") {
        Constants.debugLog("Colleague Contact")
    }
    
    private var nextBtn = Constants.themeBtn(with: "Next")
    
    @objc func nextBtnAction() {
        navigationController?.pushViewController(BankInfoController(), animated: true)
    }
}
