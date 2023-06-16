//
//  FeedbackCell.swift
//  CashMore
//
//  Created by Tim on 2023/6/16.
//

import UIKit

class FeedbackCell: UITableViewCell {
    
    var feedback : FeedbackModel? {
        didSet {
            problemTypeLabel.text = feedback?.feedBackType
            dateLabel.text = feedback?.createTime
            badgeLabel.isHidden = feedback?.replyNum == "0"
            badgeLabel.text = feedback?.replyNum
            feedbackContentLabel.text = feedback?.feedBackContent
            layoutIfNeeded()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(problemTypeLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(badgeLabel)
        contentView.addSubview(feedbackContentLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var problemTypeLabel : UILabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCSemiboldFont(14)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    private lazy var dateLabel : UILabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.textColor = Constants.formTitleTextColor
        lb.textAlignment = .right
        return lb
    }()
    
    private lazy var badgeLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = Constants.pureWhite
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.layer.cornerRadius = 9
        lb.layer.masksToBounds = true
        lb.backgroundColor = Constants.themeColor
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var feedbackContentLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeSubtitleColor
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.numberOfLines = 0
        return lb
    }()
}

extension FeedbackCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        problemTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(18)
            make.left.equalTo(18)
            make.height.equalTo(20)
        }
        
        badgeLabel.snp.makeConstraints { make in
            make.right.equalTo(-18)
            make.height.equalTo(18)
            make.width.greaterThanOrEqualTo(18)
            make.centerY.equalTo(problemTypeLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.right.equalTo(badgeLabel.snp.left).offset(-10)
            make.centerY.equalTo(badgeLabel)
        }
        
        feedbackContentLabel.snp.makeConstraints { make in
            make.top.equalTo(problemTypeLabel.snp.bottom).offset(6)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(38)
            make.bottom.equalToSuperview().offset(-16).priority(.high)
        }
    }
}
