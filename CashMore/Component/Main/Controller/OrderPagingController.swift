//
//  OrderPagingController.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit
class OrderPagingController: BaseViewController {
    

    override func configUI() {
        super.configUI()
        title = "My Orders"
        isLightStyle = true
        view.backgroundColor = Constants.darkBgColor
        
        
        view.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        view.layoutIfNeeded()
        
       
        view.addSubview(pagingTitleView)
        pagingTitleView.tm.setCorner(10, [.topLeft, .topRight])
        view.addSubview(pagingContentView)
    }
    
    private lazy var tipsLabel = {
        let tipsLabel = UILabel()
        tipsLabel.numberOfLines = 0
        tipsLabel.font = Constants.pingFangSCRegularFont(18)
        tipsLabel.textColor = Constants.pureWhite
        tipsLabel.text = "Make your repayments on time and apply again for higher amounts."
        tipsLabel.textAlignment = .center
        return tipsLabel
    }()
    
    private lazy var pagingTitleView = {
        var titleViewConfig = PagingTitleViewConfigure()
        titleViewConfig.showBottomSeparator = false
        titleViewConfig.font = Constants.pingFangSCMediumFont(16)
        titleViewConfig.selectedFont = Constants.pingFangSCMediumFont(16)
        titleViewConfig.color = UIColor(white: 1, alpha: 0.48)
        titleViewConfig.selectedColor = Constants.pureWhite
        titleViewConfig.indicatorColor = Constants.themeColor
        titleViewConfig.indicatorType = .Fixed
        
        let titles = ["All Orders", "Disbursing", "To be Repaid", "Denied", "Repaid", "Overdue", "Pending"]
        let frame = CGRect(x: 14, y: tipsLabel.frame.maxY + 14, width: Constants.screenWidth - 28, height: 46)
        let pagingTitleView = PagingTitleView(frame: frame, titles: titles, configure: titleViewConfig)
        pagingTitleView.backgroundColor = UIColor(white: 1, alpha: 0.48)
        pagingTitleView.delegate = self
        pagingTitleView.index = 0
        return pagingTitleView
    }()
    
    private lazy var pagingContentView = {
        let viewControllers = [
            OrderListController(type: .all),
            OrderListController(type: .disbursing),
            OrderListController(type: .unrepaid),
            OrderListController(type: .denied),
            OrderListController(type: .repied),
            OrderListController(type: .overdue),
            OrderListController(type: .pending)
        ]
        let frame = CGRect(x: 0, y: pagingTitleView.frame.maxY, width: Constants.screenWidth, height: Constants.screenHeight - pagingTitleView.frame.maxY)
        let pagingContentView = PagingContentCollectionView(frame: frame, parentVC: self, childVCs: viewControllers)
        pagingContentView.backgroundColor = Constants.themeBgColor
        pagingContentView.delegate = self
        pagingContentView.isBounces = true
        return pagingContentView
    }()
}

extension OrderPagingController : PagingTitleViewDelegate {
    func pagingTitleView(titleView: PagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
}

extension OrderPagingController : PagingContentViewDelegate {
    func pagingContentView(contentView: PagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
}
