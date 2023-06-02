//
//  UIButton+Extension.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//

import UIKit

extension TM where Base : UIButton {
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {
        guard let imageView = base.currentImage,
            let titleLabel = base.titleLabel?.text else { return }

        let sign: CGFloat = imageOnTop ? 1 : -1
        base.titleEdgeInsets = UIEdgeInsets(top: (imageView.size.height + gap) * sign, left: -imageView.size.width, bottom: 0, right: 0);

        let titleSize = titleLabel.size(withAttributes:[NSAttributedString.Key.font: base.titleLabel!.font!])
        base.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + gap) * sign, left: 0, bottom: 0, right: -titleSize.width)
    }
}
