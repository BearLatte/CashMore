//
//  BaseViewController.swift
//  CashMore
//
//  Created by Tim on 2023/5/31.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    override var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isHiddenBackBtn = false {
        didSet {
            backBtn.isHidden = isHiddenBackBtn
        }
    }
    
    var isHiddenTitleLabel = false {
        didSet {
            titleLabel.isHidden = isHiddenTitleLabel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private let backBtn = {
        let btn = UIButton()
        btn.setImage(R.image.back_arrow(), for: .normal)
        return btn
    }()
    
    let titleLabel = {
        let lb = UILabel()
        lb.font = Constants.pageTitleFont
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    func configUI() {
        view.backgroundColor = Constants.themeBgColor
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.top.equalTo(Constants.topSafeArea + 15)
            make.left.equalTo(15)
        }
        backBtn.addTarget(self, action: #selector(pop2parant), for: .touchUpInside)
        
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn)
            make.left.equalTo(backBtn.snp.right)
        }
    }
    
    @objc func pop2parant() {
        navigationController?.popViewController(animated: true)
    }
}
