//
//  UIView+Extension.swift
//  YiLianGongFang
//
//  Created by Tim on 2021/8/9.
//

import UIKit

extension UIView : TMCompatible {}
extension TM where Base : UIView {
    func setCorner(_ radius: CGFloat, _ rectCorner: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]) {
        base.layoutIfNeeded()
        let path = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius))
        let shapLayer = CAShapeLayer()
        shapLayer.path = path.cgPath
        base.layer.mask = shapLayer
    }
    
    
    /// add a top border
    func topBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: base.bounds.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
    
    /// add a left border
    func leftBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: width, height: base.bounds.height)
        drawBorder(rect: rect, color: borderColor)
    }
    
    /// add a bottom border
    func bottomBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: base.bounds.height - width, width: base.bounds.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
    
    /// add a right border
    func rightBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: base.bounds.width - width, y: 0, width: width, height: base.bounds.height)
        drawBorder(rect: rect, color: borderColor)
    }
    
    private func drawBorder(rect: CGRect, color: UIColor) {
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        base.layer.addSublayer(lineShape)
    }
}
