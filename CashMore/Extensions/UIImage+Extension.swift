//
//  UIImage+Extension.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import Foundation
import UIKit

extension UIImage : TMCompatible {}
extension TM where Base : UIImage {
    static func createImage(_ color : UIColor) -> UIImage {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
