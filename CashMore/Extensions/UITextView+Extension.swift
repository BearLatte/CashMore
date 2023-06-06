//
//  UITextView+Extension.swift
//  CashMore
//
//  Created by Tim on 2023/6/5.
//

import UIKit

extension UITextView {
    func setPlaceholder(text: String?) {
        if text == nil {
            return
        }
        
        let placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = font
        placeholderLabel.textColor = Constants.borderColor
        placeholderLabel.text = text
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        setValue(placeholderLabel, forKeyPath: "_placeholderLabel")
    }
}
