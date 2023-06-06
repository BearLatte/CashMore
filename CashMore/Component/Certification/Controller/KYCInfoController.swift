//
//  KYCInfoController.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit

class KYCInfoController: BaseScrollController {

    override func configUI() {
        super.configUI()
        title = "KYC Info"
        
        setIndicator(current: 1, count: 4)
        contentView.addSubview(cardFrontBtn)
        cardFrontBtn.addTarget(self, action: #selector(frontBtnAction), for: .touchUpInside)
        cardFrontBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 175, height: 95))
            make.centerX.equalToSuperview()
        }
        
        let frontIndicatorLabel = Constants.indicatorLabel
        contentView.addSubview(frontIndicatorLabel)
        frontIndicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(cardFrontBtn.snp.bottom).offset(6)
            make.centerX.equalTo(cardFrontBtn)
        }
        
        contentView.addSubview(adhaarNameInputView)
        adhaarNameInputView.snp.makeConstraints { make in
            make.top.equalTo(frontIndicatorLabel.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(adhaarNumInputView)
        adhaarNumInputView.snp.makeConstraints { make in
            make.top.equalTo(adhaarNameInputView.snp.bottom)
            make.left.right.equalTo(adhaarNameInputView)
        }
        
        
        contentView.addSubview(genderChooseVIew)
        genderChooseVIew.snp.makeConstraints { make in
            make.top.equalTo(adhaarNumInputView.snp.bottom)
            make.left.right.equalTo(adhaarNameInputView)
            
        }
        
        contentView.addSubview(dateOfBirthInputView)
        dateOfBirthInputView.snp.makeConstraints { make in
            make.top.equalTo(genderChooseVIew.snp.bottom)
            make.left.right.equalTo(adhaarNameInputView)
        }
        
        contentView.addSubview(cardBackBtn)
        cardBackBtn.snp.makeConstraints { make in
            make.top.equalTo(dateOfBirthInputView.snp.bottom).offset(30)
            make.size.centerX.equalTo(cardFrontBtn)
        }
        
        let backIndicatorLabel = Constants.indicatorLabel
        contentView.addSubview(backIndicatorLabel)
        backIndicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(cardBackBtn.snp.bottom).offset(6)
            make.centerX.equalTo(frontIndicatorLabel)
        }
        
        contentView.addSubview(addressInputView)
        addressInputView.snp.makeConstraints { make in
            make.top.equalTo(backIndicatorLabel.snp.bottom).offset(15)
            make.left.right.equalTo(adhaarNameInputView)
        }
        
        contentView.addSubview(marriageStatusInputView)
        marriageStatusInputView.snp.makeConstraints { make in
            make.top.equalTo(addressInputView.snp.bottom)
            make.left.right.equalTo(adhaarNameInputView)
        }
        
        contentView.addSubview(educationInputView)
        educationInputView.snp.makeConstraints { make in
            make.top.equalTo(marriageStatusInputView.snp.bottom)
            make.left.right.equalTo(adhaarNameInputView)
        }
        
        contentView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.top.equalTo(educationInputView.snp.bottom).offset(20)
            make.left.equalTo(55)
            make.right.equalTo(-55)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-Constants.bottomSafeArea)
        }
        nextBtn.addTarget(self, action: #selector(nextBtnTapAction), for: .touchUpInside)
    }
    
    private lazy var cardFrontBtn = Constants.imageOnTopBtn(with: R.image.camera_small(), title: "Aadhaar Card Front")
    private lazy var cardBackBtn  = Constants.imageOnTopBtn(with: R.image.camera_small(), title: "Aadhaar Card Back")
    private lazy var adhaarNameInputView  = FormInputView(title: "Aadhaar Name", placeholder: "Aadhaar Name")
    private lazy var adhaarNumInputView   = FormInputView(title: "Aadhaar Number", placeholder: "Aadhaar Number")
    private lazy var genderChooseVIew     = GenderChooseView()
    private lazy var dateOfBirthInputView = FormInputView(title: "Date of Birth", placeholder: "Date of Birth", isInputEnabel: false) {
        Constants.debugLog("choose birth action")
    }
    private lazy var addressInputView     = FormMultipleTextInputView(title: "Detail Address", placeholder: "Detail Address")
    private lazy var marriageStatusInputView = FormInputView(title: "Marriage Status", placeholder: "Marriage Status", isInputEnabel: false) {
        Constants.debugLog("choose marriage status")
    }
    private lazy var educationInputView = FormInputView(title: "Education", placeholder: "Education", isInputEnabel: false) {
        Constants.debugLog("choose Education")
    }
    
    private lazy var nextBtn = Constants.themeBtn(with: "Next")
    
    
    @objc func frontBtnAction() {
        PhotoTipSheet.showTipSheet {
            Constants.debugLog("okBtn Did clicked")
        }
    }
    
    @objc func nextBtnTapAction() {
        navigationController?.pushViewController(PersonalnfoController(), animated: true)
    }
}
