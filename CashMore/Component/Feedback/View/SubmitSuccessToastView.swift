//
//  SubmitSuccessToastView.swift
//  CashMore
//
//  Created by Tim on 2023/6/20.
//


class SubmitSuccessToastView : UIView {
    override init(frame: CGRect) {
        super.init(frame: Constants.screenBounds)
        backgroundColor = UIColor(white: 0, alpha: 0.48)
        addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.insertSubview(bottomContentView, belowSubview: iconView)
        bottomContentView.addSubview(indicatorLabel)
        bottomContentView.addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(okBtnClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerView = {
        let view = UIView()
        view.transform = .init(scaleX: 1.5, y: 1.5)
        view.alpha = 0.1
        return view
    }()
    
    private lazy var iconView = {
        let view = UIImageView(image: R.image.submit_success_icon())
        view.contentMode = .center
        return view
    }()
    
    private lazy var bottomContentView = {
        let view = UIView()
        view.backgroundColor = Constants.pureWhite
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var indicatorLabel = {
        let lb = UILabel()
        lb.text = "Submitted successfully"
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCRegularFont(20)
        return lb
    }()
    
    private lazy var okBtn = Constants.themeBtn(with: "OK")
    private var okBtnAction : (() -> Void)?
}

extension SubmitSuccessToastView {
    static func showToast(completion:(() -> Void)?) {
        let toast = SubmitSuccessToastView()
        toast.okBtnAction = completion
        toast.show()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        bottomContentView.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.centerY)
            make.left.right.equalToSuperview()
            make.height.equalTo(215)
            make.bottom.equalToSuperview().priority(.high)
        }
        
        indicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(28)
        }

        okBtn.snp.makeConstraints { make in
            make.top.equalTo(indicatorLabel.snp.bottom).offset(18)
            make.left.equalTo(35)
            make.right.equalTo(-35)
            make.height.equalTo(50)
        }
    }
    
    
    private func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            self.containerView.transform = .identity
            self.containerView.alpha = 1
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 0.1
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc func okBtnClicked() {
        okBtnAction?()
        dismiss()
    }
}

