//
//  KYCInfoController.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit
import AVFoundation

class KYCInfoController: BaseScrollController {

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
    
    private lazy var cardFrontActionView = OCRInputActionView(title: "Aadhaar Card Front", image: R.image.camera_small()) { [weak self] in
        self?.ocrType = .cardFront
        PhotoTipSheet.showTipSheet {
            Constants.checkoutCameraPrivary(target: self)
        }
    }
    
    private lazy var cardBackActionView = OCRInputActionView(title: "Aadhaar Card Back", image: R.image.camera_small()) { [weak self] in
        self?.ocrType = .cardBack
        Constants.checkoutCameraPrivary(target: self)
    }
    
    private lazy var adhaarNameInputView  = FormInputView(title: "Aadhaar Name", placeholder: "Aadhaar Name")
    private lazy var adhaarNumInputView   = FormInputView(title: "Aadhaar Number", placeholder: "Aadhaar Number", keyboardType: .numberPad)
    private lazy var genderChooseView     = GenderChooseView()
    private lazy var dateOfBirthInputView = FormInputView(title: "Date of Birth", placeholder: "Date of Birth", showsRightView: true) { [weak self] in
        self?.showDatePicker()
    }
    
    private lazy var addressInputView     = FormMultipleTextInputView(title: "Detail Address", placeholder: "Detail Address")
    private lazy var marriageStatusInputView = FormInputView(title: "Marriage Status", placeholder: "Marriage Status",showsRightView: true) { [weak self] in
        self?.showMarriageStatusPicker()
    }
    private lazy var educationInputView = FormInputView(title: "Education", placeholder: "Education", showsRightView: true) {  [weak self] in
        self?.showEducationPicker()
    }
    
    private lazy var nextBtn = Constants.themeBtn(with: "Next")
    private var ocrType = OCRType.cardFront
    
    
    @objc func nextBtnTapAction() {
        guard let name = adhaarNameInputView.inputText, !name.tm.isBlank else {
            HUD.flash(.label("Aadhaar Name cannot be empty"), delay: 1.0)
            return
        }
        
        guard let number = adhaarNumInputView.inputText, !number.tm.isBlank else {
            HUD.flash(.label("Adhaar Number cannot be empty"), delay: 1.0)
            return
        }
        
        guard let gender = genderChooseView.selectedGender, !gender.tm.isBlank else {
            HUD.flash(.label("Please choose your gender"), delay: 1.0)
            return
        }
        
        guard let birth = dateOfBirthInputView.inputText, !birth.tm.isBlank else {
            HUD.flash(.label("Please choose your birth"), delay: 1.0)
            return
        }
        
        guard let adress = addressInputView.inputText, !adress.tm.isBlank else {
            HUD.flash(.label("Detail Address cannot be empty"), delay: 1.0)
            return
        }
        
        guard let marriageStatus = marriageStatusInputView.inputText, !marriageStatus.tm.isBlank else {
            HUD.flash(.label("Please choose your Marriage Status"), delay: 1.0)
            return
        }
        
        guard let education = educationInputView.inputText, !education.tm.isBlank else {
            HUD.flash(.label("Please choose your Education Background"), delay: 1.0)
            return
        }
        
        navigationController?.pushViewController(PersonalnfoController(), animated: true)
    }
    

    
    private func openCamera() {
        
    }
}

// update the formdate in page
extension KYCInfoController {
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
        alert.addButton(backgroundImage: UIImage.tm.createImage(Constants.themeColor), "select") { [weak self] in
            self?.dateOfBirthInputView.inputText = Date.tm.date2string(date: picker.date, dateFormat: "dd-MM-yyyy")
            alert.hideView()
        }
        alert.addButton(backgroundImage: UIImage.tm.createImage(Constants.themeDisabledColor), "Done") {
            alert.hideView()
        }
        alert.show("Date of Birth", subTitle: "", animationStyle: .bottomToTop)
    }
    
    private func showMarriageStatusPicker() {
        view.endEditing(true)
        let listContent = [
            MarriageModel(isSelected: false, displayText: "married"),
            MarriageModel(isSelected: false, displayText: "unmarried")
        ]
        
        ListSelectionView(title: "Marriage Status", unselectedIndicatorText: "Please choose your Marriage Status", contentList: listContent) { [weak self] model in
            self?.marriageStatusInputView.inputText = (model as! MarriageModel).displayText
        }
    }
    
    private func showEducationPicker() {
        view.endEditing(true)
        let listContent = [
            EducationModel(isSelected: false, displayText: "Primary school education "),
            EducationModel(isSelected: false, displayText: "Junior high school education"),
            EducationModel(isSelected: false, displayText: "Higher school education"),
            EducationModel(isSelected: false, displayText: "technical secondary school"),
            EducationModel(isSelected: false, displayText: "junior college student"),
            EducationModel(isSelected: false, displayText: "undergraduate education"),
            EducationModel(isSelected: false, displayText: "graduate education"),
            EducationModel(isSelected: false, displayText: "graduate education")
        ]
        
        ListSelectionView(title: "Education", unselectedIndicatorText: "Please choose your Education", contentList: listContent) { [weak self] model in
            self?.educationInputView.inputText = model.displayText
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
            cardFrontActionView.backgroundImage = img
        } else {
            cardBackActionView.backgroundImage = img
        }
        
        APIService.standered.ocrService(imgData: img.tm.compressImage(maxLength: 1024 * 200), type: ocrType) { model in
            if self.ocrType == .cardFront {
                let curModel = model as? CardFrontModel
                self.adhaarNameInputView.inputText = curModel?.aadharName
                self.adhaarNumInputView.inputText = curModel?.aadharNumber
                self.dateOfBirthInputView.inputText = curModel?.dateOfBirth
                self.genderChooseView.selectedGender = curModel?.gender
            } else {
                let curModel = model as? CardBackModel
                self.addressInputView.inputText = curModel?.addressAll
            }
            
        }
    }
}
