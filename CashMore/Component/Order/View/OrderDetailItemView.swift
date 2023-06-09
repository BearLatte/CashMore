//
//  OrderDetailItemView.swift
//  CashMore
//
//  Created by Tim on 2023/6/12.
//

import Foundation

class OrderDetailItemView : UIView {
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    var subtitleColor : UIColor = Constants.themeTitleColor {
        didSet {
            self.subtitleLabel.textColor = subtitleColor
        }
    }
    
    convenience init(title: String? = nil, subTitle: String? = nil, subtitleColor: UIColor = Constants.themeTitleColor) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.subtitle = subTitle
        self.subtitleLabel.text = subTitle
        self.subtitleColor = subtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(20)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().priority(.high)
            make.right.lessThanOrEqualTo(subtitleLabel.snp.left).offset(-6).priority(.high)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalTo(-20)
            make.height.bottom.equalTo(titleLabel)
        }
    }
    
    private lazy var titleLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(16)
        lb.textColor = Constants.formTitleTextColor
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var subtitleLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(16)
        lb.textAlignment = .right
        lb.textColor = subtitleColor
        return lb
    }()
}
