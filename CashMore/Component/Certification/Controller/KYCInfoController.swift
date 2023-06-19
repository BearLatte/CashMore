//
//  KYCInfoController.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit
import AVFoundation

enum OptionType {
    case marriage, education, industry, salary, workTitle
}

class KYCInfoController: BaseScrollController {

    var certificationModel : CertificationInfoModel?
    
    private lazy var cardFrontActionView = OCRInputActionView(title: "Aadhaar Card Front", image: R.image.camera_small()) { [weak self] in
        ADJustTrackTool.point(name: "t5n9ey")
        self?.ocrType = .cardFront
        PhotoTipSheet.showTipSheet {
            ADJustTrackTool.point(name: "nir2fu")
            Constants.checkoutCameraPrivary(target: self)
        }
    }
    
    private lazy var cardBackActionView = OCRInputActionView(title: "Aadhaar Card Back", image: R.image.camera_small()) { [weak self] in
        ADJustTrackTool.point(name: "lugddn")
        self?.ocrType = .cardBack
        Constants.checkoutCameraPrivary(target: self)
    }
    
    private lazy var adhaarNameInputView  = FormInputView(title: "Aadhaar Name", placeholder: "Aadhaar Name")
    private lazy var adhaarNumInputView   = FormInputView(title: "Aadhaar Number", placeholder: "Aadhaar Number", keyboardType: .numberPad)
    private lazy var genderChooseView     = GenderChooseView()
    private lazy var dateOfBirthInputView = FormInputView(title: "Date of Birth", placeholder: "Date of Birth", showsRightView: true) { [weak self] in
        ADJustTrackTool.point(name: "6zb03w")
        self?.showDatePicker()
    }
    
    private lazy var addressInputView     = FormMultipleTextInputView(title: "Detail Address", placeholder: "Detail Address")
    private lazy var marriageStatusInputView = FormInputView(title: "Marriage Status", placeholder: "Marriage Status",showsRightView: true) { [weak self] in
        ADJustTrackTool.point(name: "dr16cv")
        self?.showOptionPicker(type: .marriage)
    }
    private lazy var educationInputView = FormInputView(title: "Education", placeholder: "Education", showsRightView: true) {  [weak self] in
        ADJustTrackTool.point(name: "dr16cv")
        self?.showOptionPicker(type: .education)
    }
    
    private lazy var nextBtn = Constants.themeBtn(with: "Next")
    private var ocrType = OCRType.cardFront
    
    private var cardFront : CardFrontModel = CardFrontModel() {
        didSet {
            adhaarNameInputView.inputText   = cardFront.aadharName
            adhaarNumInputView.inputText    = cardFront.aadharNumber
            dateOfBirthInputView.inputText  = cardFront.dateOfBirth
            genderChooseView.selectedGender = cardFront.gender
        }
    }
    
    private var cardBack  : CardBackModel = CardBackModel() {
        didSet {
            addressInputView.inputText = cardBack.addressAll
        }
    }
    
    private var optionsModel : OptionsModel = OptionsModel()
    private var kycModel : CertificationKYCModel? {
        didSet {
            adhaarNameInputView.inputText = kycModel?.firstName
            adhaarNumInputView.inputText  = kycModel?.aadharNumber
            genderChooseView.selectedGender = kycModel?.gender
            dateOfBirthInputView.inputText = kycModel?.dateOfBirth
            addressInputView.inputText = kycModel?.residenceDetailAddress
            marriageStatusInputView.inputText = kycModel?.marriageStatus
            educationInputView.inputText = kycModel?.education
            cardFrontActionView.backgroundImageView.kf.setImage(with: URL(string: kycModel?.frontImg ?? ""))
            cardFront.imageUrl = kycModel?.frontImg ?? ""
            cardBack.imageUrl  = kycModel?.backImg ?? ""
            cardBackActionView.backgroundImageView.kf.setImage(with: URL(string: kycModel?.backImg ?? ""))
        }
    }
    
    private var optionType : OptionType = .marriage
}

// update the formdate in page
extension KYCInfoController {
    override func configUI() {
        super.configUI()
        title = "KYC Info"
        
        setIndicator(current: 1, count: 4)
        contentView.addSubview(cardFrontActionView)
        cardFrontActionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 175, height: 95))
            make.centerX.equalToSuperview()
        }
        cardFrontActionView.tm.setCorner(10)
        
        let frontIndicatorLabel = Constants.indicatorLabel
        contentView.addSubview(frontIndicatorLabel)
        frontIndicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(cardFrontActionView.snp.bottom).offset(6)
            make.centerX.equalTo(cardFrontActionView)
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
        
        
        contentView.addSubview(genderChooseView)
        genderChooseView.snp.makeConstraints { make in
            make.top.equalTo(adhaarNumInputView.snp.bottom)
            make.left.right.equalTo(adhaarNameInputView)
            
        }
        
        contentView.addSubview(dateOfBirthInputView)
        dateOfBirthInputView.snp.makeConstraints { make in
            make.top.equalTo(genderChooseView.snp.bottom)
            make.left.right.equalTo(adhaarNameInputView)
        }
        
        contentView.addSubview(cardBackActionView)
        cardBackActionView.snp.makeConstraints { make in
            make.top.equalTo(dateOfBirthInputView.snp.bottom).offset(30)
            make.size.centerX.equalTo(cardFrontActionView)
        }
        cardBackActionView.tm.setCorner(10)
        
        let backIndicatorLabel = Constants.indicatorLabel
        contentView.addSubview(backIndicatorLabel)
        backIndicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(cardBackActionView.snp.bottom).offset(6)
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
    
    override func loadData() {
        APIService.standered.fetchModel(api: API.Certification.options, type: OptionsModel.self) { options in
            self.optionsModel = options
        }
        
        APIService.standered.fetchModel(api: API.Certification.info, parameters: ["type" : "1"], type: CertificationInfoModel.self) { model in
            self.certificationModel = model
            if model.loanapiUserIdentity == true {
                APIService.standered.fetchModel(api: API.Certification.info, parameters: ["type": "2", "step" : "loanapiUserIdentity"], type: CertificationKYCModel.self) { model in
                    self.kycModel = model
                }
            }
        }
    }
    
    
    @objc func nextBtnTapAction() {
        ADJustTrackTool.point(name: "o8w4gv")
        
        guard !cardFront.imageUrl.tm.isBlank else {
            HUD.flash(.label("Please upload Aadhaar card photo."), delay: 1.0)
            return
        }
        
        guard let name = adhaarNameInputView.inputText, !name.tm.isBlank else {
            HUD.flash(.label("Please fill in all the information"), delay: 1.0)
            return
        }
        
        guard let number = adhaarNumInputView.inputText, !number.tm.isBlank else {
            HUD.flash(.label("Please fill in all the information"), delay: 1.0)
            return
        }
        
        guard let gender = genderChooseView.selectedGender, !gender.tm.isBlank else {
            HUD.flash(.label("Please fill in all the information"), delay: 1.0)
            return
        }
        
        guard let birth = dateOfBirthInputView.inputText, !birth.tm.isBlank else {
            HUD.flash(.label("Please fill in all the information"), delay: 1.0)
            return
        }
        
        guard !cardBack.imageUrl.tm.isBlank else {
            HUD.flash(.label("Please upload Aadhaar card photo."), delay: 1.0)
            return
        }
        
        guard let adress = addressInputView.inputText, !adress.tm.isBlank else {
            HUD.flash(.label("Please fill in all the information"), delay: 1.0)
            return
        }
        
        guard let marriageStatus = marriageStatusInputView.inputText, !marriageStatus.tm.isBlank else {
            HUD.flash(.label("Please fill in all the information"), delay: 1.0)
            return
        }
        
        guard let education = educationInputView.inputText, !education.tm.isBlank else {
            HUD.flash(.label("Please fill in all the information"), delay: 1.0)
            return
        }
        
        var params : [String : Any] = [:]
        params["frontImg"]  = cardFront.imageUrl
        params["backImg"]   = cardBack.imageUrl
        params["firstName"] = name
        params["aadharNumber"] = number
        params["adNumberPaste"] = "0"
        params["gender"]    = gender
        params["dateOfBirth"] = birth
        params["education"]   = education
        params["marriageStatus"] = marriageStatus
        params["residenceDetailAddress"] = adress
        params["residenceDetailAddressPaste"] = "0"

        APIService.standered.normalRequest(api: API.Certification.kycAuth, parameters: params) {
            let personalInfoVC = PersonalnfoController()
            personalInfoVC.certificationModel = self.certificationModel
            personalInfoVC.opstionsModel = self.optionsModel
            self.navigationController?.pushViewController(personalInfoVC, animated: true)
        }
        
    }
    
    private func showDatePicker() {
        view.endEditing(true)
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth * 0.8, height: 200))
        if #available(iOS 13.0, *) {
            picker.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        picker.date = Date()
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
           
        }
        let appearance = EAAlertView.EAAppearance(
            kTitleHeight: 20,
            kButtonHeight:44,
            kTitleFont: Constants.pingFangSCSemiboldFont(18),
            showCloseButton: false,
            shouldAutoDismiss: false,
            buttonsLayout: .horizontal)
        let alert = EAAlertView(appearance: appearance)
        alert.customSubview = picker
        alert.circleBG.removeFromSuperview()
        alert.addButton(backgroundImage: UIImage.tm.createImage(Constants.themeDisabledColor), "Cancel") {
            alert.hideView()
        }
        
        alert.addButton(backgroundImage: UIImage.tm.createImage(Constants.themeColor), "select") { [weak self] in
            self?.dateOfBirthInputView.inputText = Date.tm.date2string(date: picker.date, dateFormat: "dd-MM-yyyy")
            alert.hideView()
        }
        
        alert.show("Date of Birth", subTitle: "", animationStyle: .bottomToTop)
    }
    
    private func showOptionPicker(type: OptionType) {
        view.endEditing(true)
        var options : [OptionModel] = []
        for option in (type == .marriage ? optionsModel.marryList : optionsModel.eduList) {
            options.append(OptionModel(isSelected: false, displayText: option))
        }
        
        ListSelectionView(title: type == .marriage ? "Marriage Status" : "Education" , unselectedIndicatorText: type == .marriage ? "Please choose your Marriage Status" : "Please choose your Education", contentList: options) { [weak self] model in
            if type == .marriage {
                self?.marriageStatusInputView.inputText = (model as! OptionModel).displayText
            } else {
                self?.educationInputView.inputText = (model as! OptionModel).displayText
            }
            
        }
    }
}

extension KYCInfoController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        if ocrType == .cardFront {
            cardFrontActionView.backgroundImageView.image = img
        } else {
            cardBackActionView.backgroundImageView.image = img
        }
        
        APIService.standered.ocrService(imgData: img.tm.compressImage(maxLength: 1024 * 200), type: ocrType) { model in
            if self.ocrType == .cardFront {
                self.cardFront = model as! CardFrontModel
            } else {
                self.cardBack  = model as! CardBackModel
            }
        }
    }
}
