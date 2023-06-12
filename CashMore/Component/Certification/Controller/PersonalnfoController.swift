//
//  PersonalnfoController.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit

class PersonalnfoController: BaseScrollController {
    var certificationModel : CertificationInfoModel?
    var opstionsModel : OptionsModel!
    
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
    
    private var personalInfo : CertificationPersonalInfoModel = CertificationPersonalInfoModel() {
        didSet {
            panNumInputView.inputText    = personalInfo.panNumber
            whatsAppInputView.inputText  = personalInfo.bodyImg
            industryInputView.inputText  = personalInfo.industry
            workTitleInputView.inputText = personalInfo.job
            salaryInputView.inputText    = personalInfo.monthlySalary
            emailInputView.inputText     = personalInfo.email
            paytmInputView.inputText     = personalInfo.paytmAccount
            panFrontModel.imageUrl      = personalInfo.panCardImg ?? ""
            panFrontActionView.backgroundImageView.kf.setImage(with: URL(string: personalInfo.panCardImg ?? ""))
        }
    }
    
    private var panFrontModel : PanFrontModel = PanFrontModel() {
        didSet {
            self.panNumInputView.inputText = panFrontModel.panNumber
        }
    }
    
    private lazy var panNumInputView    = FormInputView(title: "Pan Number", placeholder: "Pan Number")
    private lazy var whatsAppInputView  = FormInputView(title: "WhatsApp Account", placeholder: "WhatsApp Account", keyboardType: .numberPad)
    private lazy var industryInputView  = FormInputView(title: "Industry", placeholder: "Industry", showsRightView: true) { [weak self] in
        self?.showOptionPicker(type: .industry)
    }
    private lazy var workTitleInputView = FormInputView(title: "Work Title", placeholder: "Work Title", showsRightView: true) { [weak self] in
        self?.showOptionPicker(type: .workTitle)
    }
    private lazy var salaryInputView    = FormInputView(title: "Monthly Salary", placeholder: "Monthly Salary", showsRightView: true, keyboardType: .numberPad) { [weak self] in
        self?.showOptionPicker(type: .salary)
    }
    private lazy var emailInputView     = FormInputView(title: "E-mail", placeholder: "E-mail", keyboardType: .emailAddress)
    private lazy var paytmInputView     = FormInputView(title: "Paytm Account(Optional)", placeholder: "Paytm Account(Optional)", keyboardType: .numberPad)
    private lazy var nextBtn            = Constants.themeBtn(with: "Next")
    
    
}

extension PersonalnfoController {
    override func loadData() {
        if certificationModel?.loanapiUserBasic == true {
            APIService.standered.fetchModel(api: API.Certification.info, parameters: ["type": "2", "step" : "loanapiUserBasic"], type: CertificationPersonalInfoModel.self) { model in
                self.personalInfo = model
            }
        }
    }
    
    private func showOptionPicker(type: OptionType) {
        view.endEditing(true)
        var options : [OptionModel] = []
        var title : String = ""
        var unselectedIndicatorText : String = ""
        switch type {
        case .industry:
            title = "Industry"
            unselectedIndicatorText = "Please choose your Industry"
            for option in opstionsModel.industryList {
                options.append(OptionModel(isSelected: false, displayText: option))
            }
        case .workTitle:
            title = "Work Title"
            unselectedIndicatorText = "Please choose your Work Title"
            for option in opstionsModel.jobList {
                options.append(OptionModel(isSelected: false, displayText: option))
            }
        default:
            title = "Monthly Salary"
            unselectedIndicatorText = "Please choose your Monthly Salary"
            for option in opstionsModel.monthSalaryList {
                options.append(OptionModel(isSelected: false, displayText: option))
            }
        }
        
        
        ListSelectionView(title: title, unselectedIndicatorText: unselectedIndicatorText, contentList: options) { [weak self] model in
            if type == .industry {
                self?.industryInputView.inputText = (model as! OptionModel).displayText
            } else if type == .workTitle {
                self?.workTitleInputView.inputText = (model as! OptionModel).displayText
            } else {
                self?.salaryInputView.inputText = (model as! OptionModel).displayText
            }
            
        }
    }
    
    @objc func nextBtnAction() {
        guard !panFrontModel.imageUrl.tm.isBlank else {
            HUD.flash(.label("Please upload Pan card photo"), delay: 1.0)
            return
        }
        
        guard let number = panNumInputView.inputText, !number.tm.isBlank else {
            HUD.flash(.label("Pan Number cannot be empty"), delay: 1.0)
            return
        }
        
        guard let appAccount = whatsAppInputView.inputText, appAccount.count == 10, (Int(appAccount) != nil) else {
            HUD.flash(.label("Please enter a 10-digit mobile number"), delay: 1.0)
            return
        }
        
        guard let industry = industryInputView.inputText, !industry.tm.isBlank else {
            HUD.flash(.label("Industry cannot be empty"), delay: 1.0)
            return
        }
        
        guard let title = workTitleInputView.inputText, !title.tm.isBlank else {
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
        
        if let paytmNumber = paytmInputView.inputText, !paytmNumber.tm.isBlank {
            if paytmNumber.count != 10 || Int(paytmNumber) == nil {
                HUD.flash(.label("Paytm Account must enter a 10-digit mobile number"), delay: 1.0)
                return
            }
        }
        
        var paramters : [String : Any] = [:]
        paramters["panCardImg"] = panFrontModel.imageUrl
        paramters["panNumber"] = number
        paramters["panNumberPaste"] = "0"
        paramters["job"] = title
        paramters["email"] = email
        paramters["emailPaste"] = "0"
        paramters["industry"] = industry
        paramters["monthlySalary"] = salary
        let paytmAccount : String? = (paytmInputView.inputText ?? "").tm.isBlank ? nil : paytmInputView.inputText
        paramters["paytmAccount"] = paytmAccount
        
        paramters["bodyImg"] = appAccount
        
        APIService.standered.normalRequest(api: API.Certification.prosonalInfoAuth, parameters: paramters) {
            let contactInfo = ContactInfoController()
            contactInfo.certificationModel = self.certificationModel
            self.navigationController?.pushViewController(contactInfo, animated: true)
        }
        
    }
}

extension PersonalnfoController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        panFrontActionView.backgroundImageView.image = img
        
        APIService.standered.ocrService(imgData: img.tm.compressImage(maxLength: 1024 * 200), type: .panFront) { model in
            self.panFrontModel = model as! PanFrontModel
        }
    }
}
