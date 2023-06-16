//
//  FeedbackDetailController.swift
//  CashMore
//
//  Created by Tim on 2023/6/16.
//

import UIKit

class FeedbackDetailController: BaseScrollController {
    var feedback : FeedbackModel! {
        didSet {
            isShowReplyContentView = !feedback.feedBackReply.tm.isBlank
            isShowReplyDateViwe = !feedback.feedBackReply.tm.isBlank
            replyContentView.text = feedback.feedBackReply
            replyTimeView.text = feedback.replyTime
            phoneNumberLabel.text = "Phone number : " + feedback.phone
            feedbackTypeLabel.text = feedback.feedBackType
            productIconView.kf.setImage(with: URL(string: feedback.logo))
            productNameLabel.text = feedback.loanName
            feedbackContentView.text = feedback.feedBackContent
            feedbackCreateTime.text = feedback.createTime
            guard  let data = feedback.feedBackImg.data(using: .utf8, allowLossyConversion: false),
                   let images = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String] else {
                return
            }
            photosView.imgUrls = images
        }
    }
    
    private lazy var replyContentBgView : UIView = {
        let replyContentBgView = UIView()
        replyContentBgView.layer.cornerRadius = 10
        replyContentBgView.layer.masksToBounds = true
        replyContentBgView.layer.borderColor = Constants.borderColor.cgColor
        replyContentBgView.layer.borderWidth = 1
        return replyContentBgView
    }()
    
    private lazy var replyContentView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = false
        view.textColor = Constants.themeTitleColor
        view.font = Constants.pingFangSCRegularFont(16)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var replyTimeView = createLabel(font: Constants.pingFangSCRegularFont(14), textColor: Constants.placeholderTextColor)
    
    private lazy var feedbackInfoBgView = {
        let view = UIView()
        view.backgroundColor = Constants.themeColor
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var phoneNumberLabel = createLabel(font: Constants.pingFangSCMediumFont(16))
    private lazy var feedbackTypeLabel = createLabel()
    private lazy var productIconView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 15
        icon.layer.masksToBounds = true
        return icon
    }()
    private lazy var productNameLabel = createLabel()
    
    private lazy var feedbackContentView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = false
        view.textColor = Constants.themeTitleColor
        view.font = Constants.pingFangSCRegularFont(16)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private let photosView = ProblemPhotosView(type: .preview)
    
    private lazy var feedbackCreateTime = createLabel(font: Constants.pingFangSCRegularFont(14), textColor: Constants.placeholderTextColor)
    
    private var isShowReplyContentView = false {
        didSet {
            replyContentBgView.isHidden = !isShowReplyContentView
        }
    }
    private var isShowReplyDateViwe = false {
        didSet {
            replyTimeView.isHidden = !isShowReplyDateViwe
        }
    }
}

extension FeedbackDetailController {
    override func configUI() {
        super.configUI()
        title = "Detail"
        
        contentView.addSubview(replyContentBgView)
        replyContentBgView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        self.replyContentBgView = replyContentBgView
        
        replyContentBgView.addSubview(replyContentView)
        replyContentView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.greaterThanOrEqualTo(60)
            make.bottom.equalToSuperview().offset(-10).priority(.high)
        }
        
        
        contentView.addSubview(replyTimeView)
        replyTimeView.snp.makeConstraints { make in
            make.top.equalTo(replyContentBgView.snp.bottom).offset(2)
            make.right.equalTo(-10)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(feedbackInfoBgView)
        feedbackInfoBgView.snp.makeConstraints { make in
            if isShowReplyDateViwe {
                make.top.equalTo(replyTimeView.snp.bottom).offset(25)
            } else {
                make.top.equalToSuperview()
            }

            make.left.equalTo(10)
            make.right.equalTo(-10)
        }

        feedbackInfoBgView.addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.height.equalTo(22)
        }

        feedbackInfoBgView.addSubview(feedbackTypeLabel)
        feedbackTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(6)
            make.left.height.equalTo(phoneNumberLabel)
        }

        feedbackInfoBgView.addSubview(productIconView)
        productIconView.snp.makeConstraints { make in
            make.top.equalTo(feedbackTypeLabel.snp.bottom).offset(6)
            make.left.equalTo(phoneNumberLabel)
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.bottom.equalTo(-30).priority(.high)
        }

        feedbackInfoBgView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(productIconView.snp.right).offset(10)
            make.centerY.equalTo(productIconView)
        }
        
        let feedbackContentBgView = UIView()
        feedbackContentBgView.layer.cornerRadius = 10
        feedbackContentBgView.layer.masksToBounds = true
        feedbackContentBgView.layer.borderColor = Constants.borderColor.cgColor
        feedbackContentBgView.layer.borderWidth = 1
        contentView.addSubview(feedbackContentBgView)
        feedbackContentBgView.snp.makeConstraints { make in
            make.top.equalTo(feedbackInfoBgView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        feedbackContentBgView.addSubview(feedbackContentView)
        feedbackContentView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.greaterThanOrEqualTo(60)
        }
        
        feedbackContentBgView.addSubview(photosView)
        photosView.snp.makeConstraints { make in
            make.top.equalTo(feedbackContentView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview().offset(-10).priority(.high)
        }
        
        contentView.addSubview(feedbackCreateTime)
        feedbackCreateTime.snp.makeConstraints { make in
            make.top.equalTo(feedbackContentBgView.snp.bottom).offset(2)
            make.right.equalTo(-10)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-Constants.bottomSafeArea)
        }
    }
    
    
    private func createLabel(font: UIFont = Constants.pingFangSCRegularFont(16), textColor: UIColor = Constants.pureWhite) -> UILabel {
        let lb = UILabel()
        lb.textColor = textColor
        lb.font = font
        return lb
    }
}
