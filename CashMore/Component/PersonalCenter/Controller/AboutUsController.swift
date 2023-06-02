//
//  AboutUsController.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import UIKit

class AboutUsController: BaseViewController {
    override func configUI() {
        super.configUI()
        title = "About Us"
        
        let imgView = UIImageView(image: R.image.about_us_img())
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let versionLabel = UILabel()
        versionLabel.text = "Version \(Bundle.tm.productVersion)"
        versionLabel.font = Constants.pingFangSCRegularFont(16)
        versionLabel.textColor = Constants.themeTitleColor
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-Constants.bottomSafeArea)
            make.centerX.equalToSuperview()
        }
    }
}
