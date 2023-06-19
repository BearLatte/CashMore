//
//  LoginController.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import UIKit
import IQKeyboardManagerSwift
@_exported import PKHUD


class LoginController: BaseViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private weak var phoneInputField : UITextField!
    private weak var sendOtpBtn : CaptchaButton!
    private lazy var boxField  = {
        let field = VerifyBoxField(style: .border, allowInputCount: 4)
        field.borderLineViews.forEach { view in
            view.isHidden = true
        }
        field.itemSpace    = 10
        field.tintColor    = Constants.borderColor
        field.cursorColor  = Constants.borderColor
        field.borderWidth  = 1
        field.borderRadius = 8
        field.textFont     = Constants.pingFangSCMediumFont(20)
        field.textColor    = Constants.themeTitleColor
        field.trackTintColor = Constants.themeColor
        field.autoResignFirstResponseWhenInputFinished = true
        return field
    }()
    
    private lazy var checkBox = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.check_box(), for: .normal)
        btn.setImage(R.image.check_box_full(), for: .selected)
        return btn
    }()
    
    private lazy var loginBtn = Constants.themeBtn(with: "Login Now")
}

// MARK: - UI
extension LoginController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func configUI() {
        super.configUI()
        isLightStyle = true
        view.layer.contents = R.image.login_bg()?.cgImage
        let card = UIView()
        card.backgroundColor = Constants.pureWhite
        view.insertSubview(card, at: 0)
        card.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335, height: 600))
            make.center.equalToSuperview()
        }
        card.tm.setCorner(20)
        
        let cardHead = UIImageView(image: R.image.card_head())
        card.addSubview(cardHead)
        cardHead.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.right.equalTo(1)
        }
        
        let indicatorLabel = UILabel()
        indicatorLabel.text = "Mobile number"
        indicatorLabel.textColor = Constants.themeTitleColor
        indicatorLabel.font = Constants.pingFangSCMediumFont(20)
        card.addSubview(indicatorLabel)
        indicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(cardHead.snp.bottom).offset(17)
            make.left.equalTo(24)
        }
        
        let phoneInput = UITextField()
        phoneInput.attributedPlaceholder = NSAttributedString(string: "Mobile number", attributes: [.foregroundColor : Constants.themeDisabledColor])
        phoneInput.textColor = Constants.themeTitleColor
        phoneInput.font = Constants.pingFangSCRegularFont(20)
        phoneInput.borderStyle = .none
        phoneInput.keyboardType = .numberPad
        card.addSubview(phoneInput)
        phoneInput.snp.makeConstraints { make in
            make.top.equalTo(indicatorLabel.snp.bottom).offset(5)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(56)
        }
        phoneInput.tm.bottomBorder(width: 1, borderColor: Constants.borderColor)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 56))
        phoneInput.leftView = leftView
        phoneInput.leftViewMode = .always
        let areaCodeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 56))
        areaCodeLabel.text = "+91"
        areaCodeLabel.font = Constants.pingFangSCMediumFont(20)
        areaCodeLabel.textColor = Constants.themeTitleColor
        leftView.addSubview(areaCodeLabel)
        phoneInput.addTarget(self, action: #selector(phoneInputTextChanged(textField:)), for: .editingChanged)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 95, height: 56))
        phoneInput.rightView = rightView
        phoneInput.rightViewMode = .always
        let countBtn = CaptchaButton(type: .custom)
        countBtn.frame = CGRect(x: 0, y: 8, width: 88, height: 40)
        countBtn.layer.cornerRadius = 20
        countBtn.layer.masksToBounds = true
        countBtn.setTitle("Get OTP", for: .normal)
        countBtn.setTitleColor(Constants.pureWhite, for: .normal)
        countBtn.titleLabel?.font = Constants.pingFangSCMediumFont(18)
        countBtn.setBackgroundImage(UIImage.tm.createImage(Constants.themeColor), for: .normal)
        countBtn.setBackgroundImage(UIImage.tm.createImage(Constants.themeDisabledColor), for: .disabled)
        rightView.addSubview(countBtn)
        sendOtpBtn = countBtn
        countBtn.addTarget(self, action: #selector(sendOtpAction), for: .touchUpInside)
        phoneInputField = phoneInput
        
        let pwdLabel = UILabel()
        pwdLabel.text = "One-time-Password"
        pwdLabel.font = Constants.pingFangSCMediumFont(20)
        pwdLabel.textColor = Constants.themeTitleColor
        card.addSubview(pwdLabel)
        pwdLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneInput.snp.bottom).offset(25)
            make.left.equalTo(24)
        }
        
        card.addSubview(boxField)
        boxField.snp.makeConstraints { make in
            make.top.equalTo(pwdLabel.snp.bottom).offset(7)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(66)
        }
        
        card.addSubview(checkBox)
        checkBox.snp.makeConstraints { make in
            make.top.equalTo(boxField.snp.bottom).offset(20)
            make.left.equalTo(boxField)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        checkBox.addTarget(self, action: #selector(changeCheckBoxState), for: .touchUpInside)
        
        let privacyLabel = ActiveLabel()
        let termsType    = ActiveType.custom(pattern: "\\sTerms & Conditions\\b")
        let privacyType  = ActiveType.custom(pattern: "\\sPrivacy Policy\\b")
        privacyLabel.enabledTypes.append(termsType)
        privacyLabel.enabledTypes.append(privacyType)
        privacyLabel.customize { label in
            label.text = "By continuing you agree our Terms & Conditions And Privacy Policy."
            label.numberOfLines = 0
            label.textColor = Constants.themeTitleColor
            label.font = Constants.pingFangSCRegularFont(14)
            label.customColor = [termsType: Constants.themeColor, privacyType : Constants.themeColor]
            label.handleCustomTap(for: termsType) { _ in Constants.debugLog("Tapped the Terms & Conditions")}
            label.handleCustomTap(for: privacyType) { _ in Constants.debugLog("Tapped the Privacy Policy") }
        }
        card.addSubview(privacyLabel)
        privacyLabel.snp.makeConstraints { make in
            make.left.equalTo(checkBox.snp.right).offset(5)
            make.right.equalTo(-20)
            make.centerY.equalTo(checkBox)
        }
        
       
        card.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.left.equalTo(35)
            make.right.equalTo(-35)
            make.bottom.equalTo(-20)
            make.height.equalTo(50)
        }
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        // 接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(verityBoxBecomeFirstNotification), name: .verifyBoxFieldDidBecomeFirstResponderNotification, object: nil)
    }
}

extension LoginController {
    
    // 登录动作
    @objc func loginAction() {
        guard let phone = phoneInputField.text, !phone.tm.isBlank, !(phone.count < 10) else {
            HUD.flash(.label("Please enter a 10-digit mobile number"), delay: 1.0)
            return
        }
        
        
        guard var passcode = boxField.text, !passcode.tm.isBlank else {
            HUD.flash(.label("Please enter correct OTP"), delay: 1.0)
            return
        }
        
        ADJustTrackTool.point(name: "w8jlm6")
        
        if !checkBox.isSelected {
            HUD.flash(.label("Please agree with our policy to continue"), delay: 1.0)
            return
        }
        
        #if DEBUG
        passcode = "821350"
        #endif
        
        APIService.standered.fetchModel(api: API.Login.login, parameters: ["phone" : phone, "code" : passcode], type: LoginSuccessModel.self) { model in
            if model.isLogin == 0 {
                ADJustTrackTool.point(name: "1qr0ad")
                FacebookTrackTool.point(name: "1qr0ad")
            }
            HUD.flash(.labeledSuccess(title: nil, subtitle: "Login Success"), delay: 1.0) { isFinished in
                if isFinished {
                    UserDefaults.standard.setValue(true, forKey: Constants.IS_LOGIN)
                    UserDefaults.standard.setValue(model.token, forKey: Constants.ACCESS_TOKEN)
                    UserDefaults.standard.setValue(model.uid, forKey: Constants.UID_KEY)
                    NotificationCenter.default.post(name: Constants.loginSuccessNotification, object: nil)
                    self.goBack()
                }
            }
        }
        
    }
    
    // 发送验证码
    @objc func sendOtpAction() {
        ADJustTrackTool.point(name: "7yrz7e")
        
        guard let phone = phoneInputField.text, !phone.tm.isBlank, !(phone.count < 10) else {
            HUD.flash(.label("Please enter a 10-digit mobile number"), delay: 2.0)
            return
        }
        
        APIService.standered.normalRequest(api: API.Login.sendSMS, parameters: ["phone": phone]) {
            self.sendOtpBtn.codeCountdown(isCodeTimer: true)
        }
    }
    
    @objc func phoneInputTextChanged(textField: UITextField) {
        guard let mobleNumber = textField.text else {
            return
        }
        
        if mobleNumber.count > 10 {
            phoneInputField.text = String(mobleNumber.prefix(10))
        }
    }
    
    @objc func verityBoxBecomeFirstNotification() {
        ADJustTrackTool.point(name: "nihxhq")
    }
    
    @objc func changeCheckBoxState() {
        checkBox.isSelected.toggle()
    }
}
