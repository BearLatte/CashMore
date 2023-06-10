//
//  TipsSheet.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit

class TipsSheet: UIView {
    static func show(isHiddenTitle: Bool = false, message: String, cancelAction: (() -> Void)? = nil, confirmAction: (() -> Void)? = nil) {
        let sheet = TipsSheet(frame: Constants.screenBounds)
        sheet.isHiddenTitle = isHiddenTitle
        sheet.cancelAction = cancelAction
        sheet.confirmAction = confirmAction
        sheet.messageLabel.text = message
        sheet.show()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(messageLabel)
        cardView.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        cardView.addSubview(confirmBtn)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        if !isHiddenTitle {
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(18)
                make.left.equalTo(18)
            }
        }
        
        messageLabel.snp.makeConstraints { make in
            if isHiddenTitle {
                make.top.equalTo(18)
            } else {
                make.top.equalTo(titleLabel.snp.bottom).offset(6)
            }
            
            make.left.equalTo(18)
            make.right.equalTo(-18)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(18)
            make.left.equalTo(18)
            make.size.equalTo(CGSize(width: 145, height: 50))
            make.bottom.equalToSuperview().offset(-18).priority(.high)
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(cancelBtn)
            make.left.equalTo(cancelBtn.snp.right).offset(7)
            make.size.equalTo(cancelBtn)
            make.right.equalToSuperview().offset(-18).priority(.high)
            make.bottom.equalToSuperview().offset(-18).priority(.high)
        }
    }
    
    @objc func cancelBtnClicked() {
        dismiss()
        cancelAction?()
    }
    
    @objc func confirmBtnClicked() {
        dismiss()
        confirmAction?()
    }
    
    func show() {
        let container = UIApplication.shared.keyWindow
        container?.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            self.cardView.transform = .identity
            self.cardView.alpha     = 1
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.cardView.transform = .init(scaleX: 0.1, y: 0.1)
            self.cardView.alpha     = 0.1
        } completion: { isFinished in
            if isFinished {
                self.removeFromSuperview()
            }
        }
    }
    
    private var isHiddenTitle = false
    private var cancelAction : (() -> Void)?
    private var confirmAction : (() -> Void)?
    
    private lazy var cardView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.transform = .init(scaleX: 0.1, y: 0.1)
        v.alpha = 0.1
        return v
    }()
    
    private lazy var titleLabel = {
        let lb = UILabel()
        lb.text = "TIPS"
        lb.font = Constants.pingFangSCRegularFont(20)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    private lazy var messageLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.textColor = Constants.themeTitleColor
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var cancelBtn = {
        let btn = UIButton(type: .custom)
        btn.setTitle("cancel", for: .normal)
        btn.backgroundColor = Constants.darkBtnBgColor
        btn.titleLabel?.font = Constants.pingFangSCMediumFont(18)
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    private lazy var confirmBtn = Constants.themeBtn(with: "Sure")
}
