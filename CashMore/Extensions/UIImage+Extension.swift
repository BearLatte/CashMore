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
    
    func compressQuality(maxLength: Int) -> Data {
        var compression : CGFloat = 1.0
        var data = base.jpegData(compressionQuality: compression)
        if (data?.count ?? 0) < maxLength {
            return data ?? Data()
        }
        
        var max : CGFloat = 1
        var min : CGFloat = 0
        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            data = base.jpegData(compressionQuality: compression)
            if (data?.count ?? 0) < Int(CGFloat(maxLength) * 0.9) {
                min = compression
            } else if (data?.count ?? 0) > maxLength {
                max = compression
            } else {
                break
            }
        }
        return data ?? Data()
    }
    
    // byte
    func compressImage(maxLength: Int) -> Data {
        // let tempMaxLength: Int = maxLength / 8
        let tempMaxLength: Int = maxLength
        var compression: CGFloat = 1
        guard var data = base.jpegData(compressionQuality: compression), data.count > tempMaxLength else {
            return base.jpegData(compressionQuality: compression)!
        }
        
        // 压缩大小
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = base.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(tempMaxLength) * 0.9 {
                min = compression
            } else if data.count > tempMaxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < tempMaxLength { return data }
        
        // 压缩大小
        var lastDataLength: Int = 0
        while data.count > tempMaxLength && data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(tempMaxLength) / CGFloat(data.count)
            print("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
        }
        return data
    }
}
