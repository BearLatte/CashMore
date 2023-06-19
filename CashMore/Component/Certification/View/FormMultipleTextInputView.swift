//
//  FormMultipleTextInputView.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit

class FormMultipleTextInputView: UIView {
    
    var inputText : String? {
        get {
            return textView.text
        }
        
        set {
            textView.text = newValue
        }
    }
    
    convenience init(title: String, placeholder: String?) {
        self.init(frame: .zero)
        self.title = title
        self.titleLabel.text = title
        textView.setPlaceholder(text: placeholder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(bottomLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.height.equalTo(25)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(35)
            
        }
        
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().priority(.high)
        }
    }
    

    private var title : String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var titleLabel : UILabel = {
        let lb = UILabel()
        lb.font = Constants.pingFangSCMediumFont(18)
        lb.textColor = Constants.themeTitleColor
        return lb
    }()
    
    private lazy var textView = {
        let tv = UITextView()
        tv.font = Constants.pingFangSCRegularFont(16)
        tv.textColor = Constants.themeTitleColor
        tv.textContainer.lineFragmentPadding = 10
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.delegate = self
        return tv
    }()
    
    private lazy var bottomLine = {
        let line = UIView()
        line.backgroundColor = Constants.borderColor
        return line
    }()
}

extension FormMultipleTextInputView : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch title {
        case "Detail Address":
            ADJustTrackTool.point(name: "dr16cv")
        default: break
        }
    }
}
