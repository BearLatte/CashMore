//
//  ContactInfoInputView.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit

class ContactInfoInputView: UIView {
    
    var contact : ContactModel? {
        get {
            currentContact
        }
        set {
            nameInputField.text = newValue?.name
            numInputField.text = newValue?.phoneNumber
            currentContact = newValue!
        }
    }
    
    convenience init(title: String, contactBookTapAction: (() -> Void)? = nil) {
        self.init(frame: .zero)
        titleLabel.text = title
        contactAction = contactBookTapAction
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(contactBookBtn)
        contactBookBtn.addTarget(self, action: #selector(contactBookBtnClicked), for: .touchUpInside)
        addSubview(numIndicatLabel)
        addSubview(numInputField)
        addSubview(nameIndicatLabel)
        addSubview(nameInputField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.left.equalTo(10)
        }
        
        contactBookBtn.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.centerY.equalTo(titleLabel.snp.bottom)
        }
        
        numIndicatLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel)
        }
        
        numInputField.snp.makeConstraints { make in
            make.top.equalTo(numIndicatLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(35)
        }
        numInputField.tm.bottomBorder(width: 1, borderColor: Constants.borderColor)
        
        nameIndicatLabel.snp.makeConstraints { make in
            make.top.equalTo(numInputField.snp.bottom).offset(15)
            make.left.equalTo(numIndicatLabel)
        }
        
        nameInputField.snp.makeConstraints { make in
            make.top.equalTo(nameIndicatLabel.snp.bottom).offset(10)
            make.left.right.height.equalTo(numInputField)
            make.bottom.equalToSuperview().priority(.high)
        }
        nameInputField.tm.bottomBorder(width: 1, borderColor: Constants.borderColor)
    }
    
    private lazy var titleLabel : UILabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCMediumFont(18)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    private lazy var numIndicatLabel : UILabel = {
        let lb = UILabel()
        lb.text = "Number"
        lb.font = Constants.pingFangSCMediumFont(18)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    private lazy var numInputField : UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "Number", attributes: [.foregroundColor : Constants.placeholderTextColor])
        field.font = Constants.pingFangSCRegularFont(16)
        field.textColor = Constants.themeTitleColor
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 34))
        field.leftView = leftView
        field.leftViewMode = .always
        field.keyboardType = .numberPad
        field.delegate = self
        return field
    }()
    
    private lazy var nameIndicatLabel : UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        lb.font = Constants.pingFangSCMediumFont(18)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    private lazy var nameInputField : UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [.foregroundColor : Constants.placeholderTextColor])
        field.font = Constants.pingFangSCRegularFont(16)
        field.textColor = Constants.themeTitleColor
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 34))
        field.leftView = leftView
        field.leftViewMode = .always
        field.delegate = self
        return field
    }()
    
    private lazy var contactBookBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.contact_book(), for: .normal)
        return btn
    }()
    
    private var contactAction : (() -> Void)?
    
    private var currentContact = ContactModel(name: "", phone: "")
    
    @objc func contactBookBtnClicked() {
        contactAction?()
    }
}

extension ContactInfoInputView : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameInputField {
            currentContact.name = textField.text ?? ""
        } else {
            currentContact.phoneNumber = textField.text ?? ""
        }
    }
}
