//
//  OrderCell.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit

class OrderCell: UITableViewCell {
    
    var order : OrderModel? {
        didSet {
            orderNumLabel.text = "Order Number : \(order?.orderNumber ?? "")"
            productNameLabel.text = order?.productName
            switch order?.orderType {
            case "disbursing":
                tagLabel.backgroundColor = DynamicColor(hexString: "#31DC78")
                tagLabel.text = "Disbursing"
            case "unrepaid":
                tagLabel.backgroundColor = DynamicColor(hexString: "#FFB200")
                tagLabel.text = "To be Repaid"
            case "denied":
                tagLabel.backgroundColor = DynamicColor(hexString: "#F061EA")
                tagLabel.text = "Denied"
            case "repied":
                tagLabel.backgroundColor = DynamicColor(hexString: "#B4B4B4")
                tagLabel.text = "Repaid"
            case "overdue":
                tagLabel.backgroundColor = DynamicColor(hexString: "#FF4C00")
                tagLabel.text = "Overdue"
            case "pending":
                tagLabel.backgroundColor = DynamicColor(hexString: "#0091FF")
                tagLabel.text = "Pending"
            default:
                break
            }
            amountCountLabel.text = "₹\(order?.amount ?? "")"
            dateLabel.text = "Apply date : \(order?.date ?? "")"
            layoutIfNeeded()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.addSubview(orderNumLabel)
        bgView.addSubview(productImgView)
        productImgView.backgroundColor = Constants.random
        bgView.addSubview(productNameLabel)
        bgView.addSubview(tagLabel)
        bgView.addSubview(amountCountLabel)
        bgView.addSubview(dateLabel)
        bgView.addSubview(amountTagLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview().priority(.high)
        }

        orderNumLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }

        productImgView.snp.makeConstraints { make in
            make.top.equalTo(orderNumLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        productImgView.tm.setCorner(20)

        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(productImgView.snp.right).offset(6)
            make.centerY.equalTo(productImgView)
        }

        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(productImgView)
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 130, height: 26))
        }
        tagLabel.tm.setCorner(13, [.topLeft, .bottomLeft])

        amountCountLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom)
            make.centerX.equalTo(tagLabel)
            make.height.equalTo(22)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(productImgView.snp.bottom).offset(6)
            make.left.equalTo(productImgView)
            make.right.lessThanOrEqualTo(-90)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-14).priority(.high)
        }

        amountTagLabel.snp.makeConstraints { make in
            make.top.equalTo(amountCountLabel.snp.bottom)
            make.centerX.equalTo(amountCountLabel)
        }

        bgView.tm.setCorner(10)
    }
    
    private lazy var bgView = {
        let bg = UIView()
        bg.backgroundColor = Constants.pureWhite
        return bg
    }()
    
    private lazy var orderNumLabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.textColor = Constants.themeSubtitleColor
        return lb
    }()
    
    private lazy var productImgView = UIImageView()
    
    private lazy var productNameLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    private lazy var tagLabel = {
        let lb = UILabel()
        lb.font          = Constants.pingFangSCRegularFont(14)
        lb.textColor     = Constants.pureWhite
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var amountCountLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCMediumFont(16)
        lb.textColor = Constants.themeTitleColor
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var dateLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var amountTagLabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.textColor = Constants.themeSubtitleColor
        lb.text = "Loan amount"
        return lb
    }()
}
