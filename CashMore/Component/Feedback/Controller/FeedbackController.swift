//
//  FeedbackController.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import UIKit
import EmptyDataSet_Swift

class FeedbackController: BaseTableController {
    override func configUI() {
        super.configUI()
        title = "My Feedback"
        let descView = UIView()
        descView.backgroundColor = Constants.themeColor
        view.addSubview(descView)
        descView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(125)
        }
        descView.tm.setCorner(10)
        
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.font = Constants.pingFangSCMediumFont(20)
        descLabel.textColor = Constants.pureWhite
        descLabel.text = "Click the button below to submit your feedback."
        descLabel.numberOfLines = 0
        descView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        let addBtn = UIButton(type: .custom)
        addBtn.setImage(R.image.feedback_add(), for: .normal)
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(descView.snp.bottom)
            make.size.equalTo(CGSize(width: 52, height: 52))
        }
        
        tableView.backgroundColor = Constants.pureWhite
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.emptyDataSetView { view in
            view.detailLabelString(NSAttributedString(string: "Please describe your problems and suggestions. we will solve them in time.", attributes: [.font : Constants.pingFangSCRegularFont(16), .foregroundColor : UIColor.black]))
                .image(R.image.empty_data_img())
        }
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(addBtn.snp.bottom).offset(20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(Constants.isBangs ? -Constants.bottomSafeArea : -10)
        }
        
    }
}

extension FeedbackController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
