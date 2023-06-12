//
//  PurchaseController.swift
//  CashMore
//
//  Created by Tim on 2023/6/12.
//


class PurchaseController : BaseScrollController {
    override func configUI() {
        super.configUI()
        title = "Detail"
        view.backgroundColor = Constants.pureWhite
        let headerView = UIImageView(image: R.image.purchase_icon())
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        let productInfoView = UIView()
        productInfoView.backgroundColor = Constants.random
        contentView.addSubview(productInfoView)
        productInfoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(20)
        }
        
        productInfoView.addSubview(productImgView)
        productImgView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        productInfoView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(productImgView.snp.right).offset(14)
        }
        
        contentView.addSubview(amountView)
        contentView.addSubview(termsView)
        contentView.addSubview(receivedView)
        contentView.addSubview(verifyFeeView)
        contentView.addSubview(gstView)
        contentView.addSubview(interestView)
        contentView.addSubview(overdueView)
        contentView.addSubview(paymentAmountView)
        
        amountView.snp.makeConstraints { make in
            make.top.equalTo(productInfoView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        termsView.snp.makeConstraints { make in
            make.top.equalTo(amountView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        receivedView.snp.makeConstraints { make in
            make.top.equalTo(termsView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        verifyFeeView.snp.makeConstraints { make in
            make.top.equalTo(receivedView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        gstView.snp.makeConstraints { make in
            make.top.equalTo(verifyFeeView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        interestView.snp.makeConstraints { make in
            make.top.equalTo(gstView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        overdueView.snp.makeConstraints { make in
            make.top.equalTo(interestView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        paymentAmountView.snp.makeConstraints { make in
            make.top.equalTo(overdueView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        contentView.addSubview(purchaseBtn)
        purchaseBtn.snp.makeConstraints { make in
            make.top.equalTo(paymentAmountView.snp.bottom).offset(40)
            make.size.equalTo(CGSize(width: 265, height: 50))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constants.bottomSafeArea).priority(.high)
        }
    }
    
    private lazy var productImgView   : UIImageView = UIImageView()
    private lazy var productNameLabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCRegularFont(20)
        lb.text = "Rupee Star"
        return lb
    }()
    private lazy var amountView    = ProductDetailItemView(title: "Amount")
    private lazy var termsView     = ProductDetailItemView(title: "Terms")
    private lazy var receivedView  = ProductDetailItemView(title: "Received Amount")
    private lazy var verifyFeeView = ProductDetailItemView(title: "Verification Fee")
    private lazy var gstView       = ProductDetailItemView(title: "GST")
    private lazy var interestView  = ProductDetailItemView(title: "Interest")
    private lazy var overdueView   = ProductDetailItemView(title: "Overdue Charge")
    private lazy var paymentAmountView = ProductDetailItemView(title: "Repayment Amount")
    private lazy var purchaseBtn   = Constants.themeBtn(with: "Loan now")
}

extension PurchaseController {
    
}
