//
//  PhotoTipSheet.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit

class PhotoTipSheet: UIView {
    
    static func showTipSheet(okAction: (() -> Void)?) {
        let sheet = PhotoTipSheet(frame: Constants.screenBounds)
        sheet.okBtnAction = okAction
        sheet.show()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.48)
        addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(correctImgView)
        cardView.addSubview(demonstrationLabel)
        cardView.addSubview(detailLabel)
        cardView.addSubview(mistakeTipLabel)
        cardView.addSubview(mistakeImgView1)
        cardView.addSubview(mistakeImgView2)
        cardView.addSubview(mistakeImgView3)
        cardView.addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(okBtnDidClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        dismiss()
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335, height: 565))
            make.center.equalToSuperview()
        }
        cardView.tm.setCorner(10)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(18)
        }
        
        correctImgView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalTo(18)
            make.right.equalTo(-18)
        }
        
        demonstrationLabel.snp.makeConstraints { make in
            make.top.equalTo(correctImgView.snp.bottom)
            make.left.equalTo(correctImgView)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(demonstrationLabel.snp.bottom)
            make.left.right.equalTo(correctImgView)
        }
        
        mistakeTipLabel.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(28)
            make.left.equalTo(correctImgView)
        }
        
        mistakeImgView1.snp.makeConstraints { make in
            make.top.equalTo(mistakeTipLabel.snp.bottom).offset(2)
            make.left.equalTo(correctImgView)
        }
        
        mistakeImgView2.snp.makeConstraints { make in
            make.top.equalTo(mistakeImgView1)
            make.centerX.equalToSuperview()
        }
        
        mistakeImgView3.snp.makeConstraints { make in
            make.top.equalTo(mistakeImgView1)
            make.right.equalTo(correctImgView)
        }
        
        okBtn.snp.makeConstraints { make in
            make.top.equalTo(mistakeImgView1.snp.bottom).offset(18)
            make.size.equalTo(CGSize(width: 266, height: 50))
            make.centerX.equalToSuperview()
        }
    }
    
    private lazy var cardView = {
        let view = UIView()
        view.backgroundColor = DynamicColor(hexString: "#F2F2F2")
        view.transform = .init(scaleX: 0.1, y: 0.1)
        view.alpha = 0.1
        return view
    }()
     
    private lazy var titleLabel = label(with: "Photo Tips")
    private lazy var correctImgView = UIImageView(image: R.image.card_front_correct())
    private lazy var demonstrationLabel = label(with: "Demonstration")
    private lazy var detailLabel = {
        let lb = UILabel()
        lb.text = "Please ensure the whole cotent involved and words clear."
        lb.textColor = DynamicColor(hexString: "#B4B4B4")
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.numberOfLines = 0
        return lb
    }()
    private lazy var mistakeTipLabel = label(with: "Unusable", textColor: Constants.themeColor)
    private lazy var mistakeImgView1 = UIImageView(image: R.image.card_front_mistake1())
    private lazy var mistakeImgView2 = UIImageView(image: R.image.card_front_mistake2())
    private lazy var mistakeImgView3 = UIImageView(image: R.image.card_front_mistake3())
    private lazy var okBtn = Constants.themeBtn(with: "OK")
    private var okBtnAction : (() -> Void)?
    
    
    private func show() {
        let container = UIApplication.shared.keyWindow
        container?.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            self.cardView.transform = .identity
            self.cardView.alpha = 1
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.cardView.transform = .init(scaleX: 0.1, y: 0.1)
            self.cardView.alpha = 0.1
        } completion: { isFinished in
            if isFinished {
                self.removeFromSuperview()
            }
        }
    }
    
    private func label(with text: String, textColor: UIColor = Constants.themeTitleColor) -> UILabel {
        let lb = UILabel()
        lb.textColor = textColor
        lb.font      = Constants.pingFangSCRegularFont(20)
        lb.text      = text
        return lb
    }
    
    @objc func okBtnDidClicked() {
        dismiss()
        okBtnAction?()
    }
}
