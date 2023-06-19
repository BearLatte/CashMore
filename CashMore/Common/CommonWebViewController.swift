//
//  CommonWebViewController.swift
//  CashMore
//
//  Created by Tim on 2023/6/19.
//

import UIKit
import WebKit

class CommonWebViewController: BaseViewController {
    var url : String = "" {
        didSet {
           let request = URLRequest(url: URL(string: url)!)
            webView.load(request)
        }
    }
    
    private lazy var webView : WKWebView = WKWebView()
}

extension CommonWebViewController {
    override func configUI() {
        super.configUI()
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
