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
            self?.checkoutCameraPrivary()
        }
    }
    
    private lazy var cardBackActionView = OCRInputActionView(title: "Aadhaar Card Back", image: R.image.camera_small()) { [weak self] in
        self?.ocrType = .cardBack
        self?.checkoutCameraPrivary()
    }
    
    private lazy var adhaarNameInputView  = FormInputView(title: "Aadhaar Name", placeholder: "Aadhaar Name")
    private lazy var adhaarNumInputView   = FormInputView(title: "Aadhaar Number", placeholder: "Aadhaar Number")
    private lazy var genderChooseView     = GenderChooseView()
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
    private var ocrType = OCRType.cardFront
    
    
    @objc func nextBtnTapAction() {
        navigationController?.pushViewController(PersonalnfoController(), animated: true)
    }
    
    private func checkoutCameraPrivary() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
           openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (res) in
                if res {
                    self.openCamera()
                }
            }
        default:
            openPermissions()
        }
    }
    
    
    private func openPermissions(){
        let settingUrl = NSURL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(settingUrl as URL)
        {
            UIApplication.shared.open(settingUrl as URL, options: [:], completionHandler: { (istrue) in
                
            })
        }
    }
    
    private func openCamera() {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = false
        camera.delegate = self
        present(camera, animated: true)
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
