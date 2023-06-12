//
//  OCRInputActionView.swift
//  CashMore
//
//  Created by Tim on 2023/6/10.
//

import UIKit

class OCRInputActionView: UIView {
    
    var title : String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var image : UIImage? {
        get {
            iconView.image
        }
        set {
            iconView.image = newValue
        }
    }
    
    
    convenience init(title: String?, image: UIImage?,  tapAction: (() -> Void)?) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.iconView.image = image
        self.tapAction = tapAction
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.themeColor
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.image = UIImage.tm.createImage(Constants.themeColor)
        addSubview(backgroundImageView)
        iconView.contentMode = .scaleAspectFit
        addSubview(iconView)
        addSubview(titleLabel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(inputViewAction))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(10).priority(.high)
        }
    }
    
    lazy var backgroundImageView = UIImageView()
    private lazy var iconView = UIImageView()
    private lazy var titleLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = Constants.pureWhite
        lb.textAlignment = .center
        lb.font = Constants.pingFangSCRegularFont(14)
        return lb
    }()
    private var tapAction : (() -> Void)?
    
    @objc func inputViewAction() {
        tapAction?()
    }
    
}
