//
//  ConfigFeedbackController.swift
//  CashMore
//
//  Created by Tim on 2023/6/16.
//

import UIKit

class ConfigFeedbackController: BaseScrollController {
    var requireInfo : FeedbackRequiredModel! {
        didSet {
            phoneNumberLabel.text = "Phone number : " + requireInfo.phone
        }
    }
    
    var saveFeedbackSuccess: (() -> Void)?
    
    private lazy var phoneNumberLabel = { () -> UILabel in
        let lb = UILabel()
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCMediumFont(16)
        return lb
    }()
    
    private lazy var productInputView = FormInputView(title: "Loan Product", placeholder: "Loan Product", showsRightView: true) { [weak self] in
        self?.showSelectionView()
    }
    
    private lazy var problemChooseView = ProblemChooseView()
    
    private lazy var problemDescriptionInputView = {
        let textView = UITextView()
        textView.font = Constants.pingFangSCRegularFont(16)
        textView.textColor = Constants.themeTitleColor
        textView.setPlaceholder(text: "Please enter problem description")
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    private lazy var photosView = ProblemPhotosView(type: .upload)
    private lazy var submitBtn = Constants.themeBtn(with: "Submit")
    
    private var selectedFeedbackProductModel : ProductModel?
}

extension ConfigFeedbackController {
    override func configUI() {
        super.configUI()
        title = "Submit feedback"
        
        let descLabel = UILabel()
        descLabel.backgroundColor = Constants.themeColor
        descLabel.font = Constants.pingFangSCMediumFont(20)
        descLabel.textColor = Constants.pureWhite
        descLabel.text = "Dear user, if you have any\n questions, you can fill them in\n here, we will solve them for you."
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(135)
        }
        descLabel.tm.setCorner(10)
        
        contentView.addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom)
            make.left.equalTo(descLabel)
            make.height.equalTo(44)
        }
        
        contentView.addSubview(productInputView)
        productInputView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(problemChooseView)
        problemChooseView.snp.makeConstraints { make in
            make.top.equalTo(productInputView.snp.bottom)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        let problemDescriptionBgView = UIView()
        problemDescriptionBgView.layer.cornerRadius = 10
        problemDescriptionBgView.layer.borderColor = Constants.borderColor.cgColor
        problemDescriptionBgView.layer.borderWidth = 1
        contentView.addSubview(problemDescriptionBgView)
        problemDescriptionBgView.snp.makeConstraints { make in
            make.top.equalTo(problemChooseView.snp.bottom)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        problemDescriptionBgView.addSubview(problemDescriptionInputView)
        problemDescriptionInputView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.greaterThanOrEqualTo(60)
        }
        
        problemDescriptionBgView.addSubview(photosView)
        photosView.snp.makeConstraints { make in
            make.top.equalTo(problemDescriptionInputView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview().offset(-10).priority(.high)
        }
        
        contentView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            make.top.equalTo(problemDescriptionBgView.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 265, height: 50))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().priority(.high)
        }
        submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
    private func showSelectionView() {
        ListSelectionView(title: "Loan Product", showsTitleView: true, unselectedIndicatorText: "", contentList: requireInfo.loanProductList) { model in
            self.productInputView.inputText = model.displayText
            self.selectedFeedbackProductModel = model as? ProductModel
        }
    }
    
    @objc func submitAction() {
        guard let feedbackType = problemChooseView.selectedProblem, !feedbackType.tm.isBlank else {
            return HUD.flash(.label("Type of problem cannot be empty"), delay: 2.0)
        }
        
        guard !requireInfo.phone.tm.isBlank else {
            return HUD.flash(.label("Phone number cannot be empty"), delay: 2.0)
        }
        
        guard let productId = selectedFeedbackProductModel?.id, !productId.tm.isBlank else {
            return HUD.flash(.label("Please choose Loan Product"), delay: 2.0)
        }
        
        guard let feedbackContent = problemDescriptionInputView.text, !feedbackContent.tm.isBlank else {
            return HUD.flash(.label("Feedback content cannot be empty"), delay: 2.0)
        }
        
        var params : [String : Any] = [:]
        params["feedBackType"] = feedbackType
        params["phone"] = requireInfo.phone
        params["feedBackContent"] = feedbackContent
        params["productId"] = productId
        
        if photosView.images.count > 0,
           let data = try? JSONSerialization.data(withJSONObject: photosView.imgUrls),
           let imgStr = String(data: data, encoding: .utf8) {
            params["feedBackImg"] = imgStr
        }
        
        APIService.standered.normalRequest(api: API.Feedback.saveFeedback, parameters: params) {
            HUD.flash(.success, delay: 2.0)
            self.saveFeedbackSuccess?()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
