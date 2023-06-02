//
//  HomeHeaderView.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//

import UIKit

protocol HomeHeaderViewDelegate {
    func headerViewBanerTapAction(headerView: HomeHeaderView)
    func headerViewFeedbackTapAction(headerView: HomeHeaderView)
    func headerViewOdersTapAction(headerView: HomeHeaderView)
    func headerViewMeTapAction(headerView: HomeHeaderView)
}

class HomeHeaderView: UIView {

    weak var delegate : AnyObject?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(banerView)
        let tap = UITapGestureRecognizer()
        banerView.addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(banerTap))
        addSubview(btnBgView)
        btnBgView.addSubview(feedbackBtn)
        btnBgView.addSubview(ordersBtn)
        btnBgView.addSubview(meBtn)
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClicked), for: .touchUpInside)
        ordersBtn.addTarget(self, action: #selector(ordersBtnClicked), for: .touchUpInside)
        meBtn.addTarget(self, action: #selector(meBtnClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        banerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        btnBgView.snp.makeConstraints { make in
            make.top.equalTo(banerView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(78)
            make.bottom.equalToSuperview().priority(.high)
        }
        
        feedbackBtn.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(95)
        }
        
        ordersBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(feedbackBtn)
        }
        
        meBtn.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(feedbackBtn)
        }
    }
    
    private lazy var banerView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = Constants.isLogin && Constants.isCertified ? R.image.certified() : R.image.uncertified()
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    private lazy var btnBgView   = UIView()
    private lazy var feedbackBtn = menuBtn(title: "Feedback", image: R.image.feedback())
    private lazy var ordersBtn   = menuBtn(title: "My Orders", image: R.image.orders())
    private lazy var meBtn       = menuBtn(title: "Me", image: R.image.me())
    
    private func menuBtn(title: String, image: UIImage?) -> UIButton {
        var btn : UIButton = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setImage(image, for: .normal)
        if #available(iOS 15.0, *) {
            var btnConfig = UIButton.Configuration.borderless()
            btnConfig.imagePadding = 6
            btnConfig.imagePlacement = .top
            btn = UIButton(configuration: btnConfig)
            btn.setTitle(title, for: .normal)
            btn.setImage(image, for: .normal)
        } else {
            btn.setTitle(title, for: .normal)
            btn.setImage(image, for: .normal)
            btn.tm.centerImageAndButton(6, imageOnTop: true)
        }
        
        btn.setTitleColor(Constants.themeTitleColor, for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCRegularFont(16)
        return btn
    }
    @objc func banerTap() {
        (delegate as? HomeHeaderViewDelegate)?.headerViewBanerTapAction(headerView: self)
    }
    @objc func feedbackBtnClicked() {
        (delegate as? HomeHeaderViewDelegate)?.headerViewFeedbackTapAction(headerView: self)
    }
    @objc func ordersBtnClicked() {
        (delegate as? HomeHeaderViewDelegate)?.headerViewOdersTapAction(headerView: self)
    }
    @objc func meBtnClicked() {
        (delegate as? HomeHeaderViewDelegate)?.headerViewMeTapAction(headerView: self)
    }
}
