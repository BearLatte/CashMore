//
//  HomeProductCell.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//

import UIKit
import KingfisherWebP

class HomeProductCell: UITableViewCell {
    
    var product : ProductModel? {
        didSet {
            guard let pr = product else {
                return
            }
            productImgView.kf.setImage(with: URL(string: pr.logo ?? ""), options: [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)])
            productNameLabel.text = pr.loanName
            descLabel.text = "Fee \(pr.loanRate) / day \(pr.loanDate) days"
            amountNumLabel.text = String(format: "INR %.02f", pr.loanAmount)
            layoutIfNeeded()
        }
    }
    
    /// loan now button click action
    var loanAction : (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(container)
        container.addSubview(productImgView)
        container.addSubview(productNameLabel)
        container.addSubview(scoreBadge)
        container.addSubview(amountNumLabel)
        container.addSubview(amountTipLabel)
        container.addSubview(actionBtn)
        container.addSubview(dottedView)
        container.addSubview(descLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview().priority(.high)
        }

        productImgView.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.equalTo(14)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(productImgView.snp.right).offset(6)
            make.centerY.equalTo(productImgView)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(productImgView.snp.bottom).offset(15)
            make.left.equalTo(productImgView)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-14).priority(.high)
        }
        
        actionBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-14)
            make.size.equalTo(CGSize(width: 110, height: 44))
            make.bottom.equalToSuperview().offset(-8)
        }

        amountNumLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.centerX.equalTo(actionBtn)
        }

        amountTipLabel.snp.makeConstraints { make in
            make.top.equalTo(amountNumLabel.snp.bottom)
            make.centerX.equalTo(actionBtn)
        }

        dottedView.snp.makeConstraints { make in
            make.top.equalTo(4)
            make.right.equalTo(actionBtn.snp.left).offset(-9)
            make.bottom.equalTo(-4)
            make.width.equalTo(1)
        }

        scoreBadge.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 55, height: 16))
            make.centerY.equalTo(productImgView)
            make.right.equalTo(dottedView.snp.left).offset(-10)
        }
    }
    
    @objc private func loanBtnDidClick() {
        loanAction?()
    }
    
    private lazy var container : UIView = {
        let view = UIView()
        view.backgroundColor = Constants.pureWhite
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var productImgView : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var productNameLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCRegularFont(14)
        return lb
    }()
    
    private lazy var scoreBadge : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.score_icon(), for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.borderColor = Constants.themeColor.cgColor
        btn.layer.borderWidth = 1
        btn.setTitleColor(Constants.themeTitleColor, for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCRegularFont(14)
        btn.isEnabled = false
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        return btn
    }()
    
    private lazy var amountNumLabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = Constants.pingFangSCMediumFont(16)
        return lb
    }()
    
    private lazy var amountTipLabel = {
        let lb = UILabel()
        lb.text = "Loan amount"
        lb.textColor = Constants.themeSubtitleColor
        lb.font = Constants.pingFangSCRegularFont(14)
        return lb
    }()
    
    private lazy var actionBtn = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = Constants.themeColor
        btn.setTitle("Loan now", for: .normal)
        btn.setTitleColor(Constants.pureWhite, for: .normal)
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(loanBtnDidClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var dottedView = UIImageView(image: R.image.dotted())
    private lazy var descLabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = Constants.pingFangSCMediumFont(16)
        return lb
    }()
}
