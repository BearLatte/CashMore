//
//  LoginController.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import UIKit

class LoginController: BaseViewController {
    override func configUI() {
        super.configUI()
        isLightBack = true
        view.layer.contents = R.image.login_bg()?.cgImage
        
//        let scrollView = UIScrollView()
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(UIEdgeInsets.zero)
//        }
//
//        let contentView = UIView()
//        contentView.backgroundColor = Constants.random
//        scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints { make in
//            make.top.left.right.bottom.equalToSuperview()
//            make.size.equalTo(Constants.screenBounds.size)
//        }
        
        let card = UIView()
        card.backgroundColor = Constants.pureWhite
        view.addSubview(card)
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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
        return field
    }()
    
    private lazy var checkBox = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.check_box(), for: .normal)
        btn.setImage(R.image.check_box_full(), for: .selected)
        return btn
    }()
    
    private lazy var loginBtn = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("Login now", for: .normal)
        loginBtn.backgroundColor = Constants.themeColor
        loginBtn.layer.cornerRadius = 25
        loginBtn.titleLabel?.font = Constants.pingFangSCMediumFont(18)
        return loginBtn
    }()
    
    @objc func phoneInputTextChanged(textField: UITextField) {
        guard let mobleNumber = textField.text else {
            return
        }
        
        if mobleNumber.count > 10 {
            phoneInputField.text = String(mobleNumber.prefix(10))
        }
    }
    
    @objc func sendOtpAction() {
        sendOtpBtn.codeCountdown(isCodeTimer: true)
    }
    
    @objc func changeCheckBoxState() {
        checkBox.isSelected.toggle()
    }
}
