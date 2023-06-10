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
        
        contentView.addSubview(panFrontActionView)
        panFrontActionView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 175, height: 95))
        }
        panFrontActionView.tm.setCorner(10)
        
        let indicatorLb = Constants.indicatorLabel
        contentView.addSubview(indicatorLb)
        indicatorLb.snp.makeConstraints { make in
            make.top.equalTo(panFrontActionView.snp.bottom).offset(6)
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
    
    private lazy var panFrontActionView = OCRInputActionView(title: "Pan card Front", image: R.image.camera_small()) { [weak self] in
        Constants.checkoutCameraPrivary(target: self)
    }
    
    private lazy var panNumInputView    = FormInputView(title: "Pan Number", placeholder: "Pan Number")
    private lazy var whatsAppInputView  = FormInputView(title: "WhatsApp Account", placeholder: "WhatsApp Account")
    private lazy var industryInputView  = FormInputView(title: "Industry", placeholder: "Industry")
    private lazy var workTitleInputView = FormInputView(title: "Work Title", placeholder: "Work Title")
    private lazy var salaryInputView    = FormInputView(title: "Monthly Salary", placeholder: "Monthly Salary", keyboardType: .numberPad)
    private lazy var emailInputView     = FormInputView(title: "E-mail", placeholder: "E-mail", keyboardType: .emailAddress)
    private lazy var paytmInputView     = FormInputView(title: "Paytm Account(Optional)", placeholder: "Paytm Account(Optional)")
    private lazy var nextBtn            = Constants.themeBtn(with: "Next")
    
    @objc func nextBtnAction() {
        guard let number = panNumInputView.inputText, !number.tm.isBlank else {
            HUD.flash(.label("Pan Number cannot be empty"), delay: 1.0)
            return
        }
        
        guard let appAccount = whatsAppInputView.inputText, !appAccount.tm.isBlank else {
            HUD.flash(.label("WhatsApp Account cannot be empty"), delay: 1.0)
            return
        }
        
        guard let industry = industryInputView.inputText, !industry.tm.isBlank else {
            HUD.flash(.label("Industry cannot be empty"), delay: 1.0)
            return
        }
        
        guard let title = industryInputView.inputText, !title.tm.isBlank else {
            HUD.flash(.label("Work Title cannot be empty"), delay: 1.0)
            return
        }
        
        guard let salary = salaryInputView.inputText, !salary.tm.isBlank else {
            HUD.flash(.label("Monthly Salary cannot be empty"), delay: 1.0)
            return
        }
        
        guard let email = emailInputView.inputText, !email.tm.isBlank else {
            HUD.flash(.label("E-mail cannot be empty"), delay: 1.0)
            return
        }
        
        navigationController?.pushViewController(ContactInfoController(), animated: true)
    }
}

extension PersonalnfoController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        panFrontActionView.backgroundImage = img
        
        APIService.standered.ocrService(imgData: img.tm.compressImage(maxLength: 1024 * 200), type: .panFront) { model in
            self.panNumInputView.inputText = (model as! PanFrontModel).panNumber
        }
    }
}
