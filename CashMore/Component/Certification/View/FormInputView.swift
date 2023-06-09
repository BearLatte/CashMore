//
//  FormInputView.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit

class FormInputView: UIView {

    var inputText : String? {
        get {
            inputField.text
        }
        set {
            inputField.text = newValue
        }
        
    }
    
    convenience init(title: String, placeholder: String, isInputEnabel: Bool = true, rightViewTapAction: (() -> Void)? = nil) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.inputField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : Constants.placeholderTextColor])
        self.inputField.isEnabled = isInputEnabel
        self.inputField.rightViewMode = rightViewTapAction == nil ? .never : .always
        self.rightAction = rightViewTapAction
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(inputField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.height.equalTo(25)
        }
        
        inputField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(34)
            make.bottom.equalToSuperview().priority(.high)
        }
        
        inputField.tm.bottomBorder(width: 1, borderColor: Constants.borderColor)
    }
    
    
    private lazy var titleLabel : UILabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCMediumFont(18)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    private lazy var inputField : UITextField = {
        let field = UITextField()
        field.font = Constants.pingFangSCRegularFont(16)
        field.textColor = Constants.themeTitleColor
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 34))
        field.leftView = leftView
        field.leftViewMode = .always
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        let downArrow = UIButton(type: .custom)
        downArrow.setImage(R.image.form_down_arrow(), for: .normal)
        downArrow.frame = rightView.bounds
        rightView.addSubview(downArrow)
        field.rightView = rightView
        downArrow.addTarget(self, action: #selector(downArrowClicked), for: .touchUpInside)
        return field
    }()
    
    private var rightAction : (() -> Void)?
    
    @objc func downArrowClicked() {
        rightAction?()
    }
}
