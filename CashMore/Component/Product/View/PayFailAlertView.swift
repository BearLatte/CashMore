//
//  PayFailAlertView.swift
//  CashMore
//
//  Created by Tim on 2023/6/25.
//

import UIKit

class PayFailAlertView: UIView {

    // 是否正在显示
    var isShowing : Bool = false
    
    var payFailInfo : PayFailInfo? {
        didSet {
            guard let value = payFailInfo else { return }
            productIconView.kf.setImage(with: URL(string: value.logo))
            productNameLabel.text = value.loanName
            let attStr =  NSMutableAttributedString(string: "Order Number : ", attributes: [.foregroundColor : Constants.formTitleTextColor])
            let orderNumber = NSAttributedString(string: value.loanOrderNo, attributes: [.foregroundColor : Constants.themeTitleColor])
            attStr.append(orderNumber)
            orderNumberLabel.attributedText = attStr
            messageLabel.text = value.content
            layoutIfNeeded()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: Constants.screenBounds)
        backgroundColor = UIColor(white: 0, alpha: 0.48)
        addSubview(alertBgView)
        alertBgView.addSubview(productIconView)
        alertBgView.addSubview(productNameLabel)
        alertBgView.addSubview(orderNumberLabel)
        alertBgView.addSubview(messageLabel)
        alertBgView.addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var alertBgView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.transform = .init(scaleX: 1.1, y: 1.1)
        view.alpha = 0.1
        return view
    }()
    
    private lazy var productIconView = {
        let iconView = UIImageView()
        iconView.layer.cornerRadius = 25
        iconView.layer.masksToBounds = true
        iconView.contentMode = .scaleAspectFill
        return iconView
    }()
    
    private lazy var productNameLabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCRegularFont(20)
        return lb
    }()
    
    private lazy var orderNumberLabel = {
        let label = UILabel()
        label.font = Constants.pingFangSCRegularFont(14)
        label.textColor = Constants.themeTitleColor
        return label
    }()
    
    private lazy var messageLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.textColor = Constants.themeTitleColor
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var okBtn = Constants.themeBtn(with: "OK")
}

extension PayFailAlertView {
   
    override func layoutSubviews() {
        super.layoutSubviews()
        alertBgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        productIconView.snp.makeConstraints { make in
            make.top.equalTo(18)
            make.left.equalTo(18)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(productIconView.snp.right).offset(14)
            make.centerY.equalTo(productIconView)
        }
        
        orderNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(productIconView.snp.bottom).offset(6)
            make.left.equalTo(productIconView)
            make.height.equalTo(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(orderNumberLabel.snp.bottom).offset(16)
            make.left.equalTo(productIconView)
            make.right.equalTo(-18)
        }
        
        okBtn.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 265, height: 50))
            make.bottom.equalToSuperview().offset(-18).priority(.high)
        }
    }
    
    func show() {
        isShowing = true
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            self.alertBgView.transform = .identity
            self.alertBgView.alpha = 1
        }
    }
    
    @objc private func dismiss() {
        isShowing = false
        UIView.animate(withDuration: 0.25) {
            self.alertBgView.transform = .init(scaleX: 1.1, y: 1.1)
            self.alertBgView.alpha = 0.1
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
