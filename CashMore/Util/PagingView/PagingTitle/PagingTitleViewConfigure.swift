//
//  PagingTitleViewConfigure.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import Foundation

enum IndicatorType {
    case Default, Cover, Fixed, Dynamic
}

enum IndicatorScrollStyle {
    case Default, Half, End
}

enum IndicatorLocation {
    case Default, Top
}


struct PagingTitleViewConfigure {
    var bounce = false
    var bounces = true
    var equivalence = true
    var showBottomSeparator = true
    var bottomSeparatorColor: UIColor = .lightGray
    var font: UIFont = .systemFont(ofSize: 15)
    var selectedFont: UIFont = .systemFont(ofSize: 15)
    var color: UIColor = .black
    var selectedColor: UIColor = .red
    var gradientEffect = false
    var textZoom = false
    var textZoomRatio: CGFloat = 0.0
    var additionalWidth: CGFloat = 20.0
    var showIndicator = true
    var indicatorColor: UIColor = .red
    var indicatorHeight: CGFloat = 2.0
    var indicatorAnimationTime: TimeInterval = 0.1
    var indicatorCornerRadius: CGFloat = 0.0
    var indicatorBorderWidth: CGFloat = 0.0
    var indicatorBorderColor: UIColor = .clear
    var indicatorAdditionalWidth: CGFloat = 0.0
    var indicatorFixedWidth: CGFloat = 30.0
    var indicatorDynamicWidth: CGFloat = 20.0
    var indicatorToBottomDistance: CGFloat = 0.0
    var indicatorType: IndicatorType = .Default
    var indicatorScrollStyle: IndicatorScrollStyle = .Default
    var indicatorLocation: IndicatorLocation = .Default
    var showSeparator = false
    var separatorColor: UIColor = .red
    var separatorAdditionalReduceLength: CGFloat = 20.0
    var badgeColor: UIColor = .red
    var badgeHeight: CGFloat = 7.0
    var badgeOff: CGPoint = .zero
    var badgeTextColor: UIColor = .white
    var badgeTextFont: UIFont = .systemFont(ofSize: 10)
    var badgeAdditionalWidth: CGFloat = 10.0
    var badgeBorderWidth: CGFloat = 0.0
    var badgeBorderColor: UIColor = .clear
    var badgeCornerRadius: CGFloat = 5.0
}
