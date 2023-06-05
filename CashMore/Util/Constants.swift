//
//  Constants.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//

import Foundation
import DynamicColor

struct Constants {
    static let IS_LOGIN = "IS_LOGIN"
    static let IS_CERTIFIED = "IS_CERTIFIED"
    static var isLogin : Bool {
        UserDefaults.standard.bool(forKey: IS_LOGIN)
    }
    static var isCertified : Bool {
        UserDefaults.standard.bool(forKey: IS_CERTIFIED)
    }
}


// MARK: - layout
extension Constants {
    static var isIpad = UIDevice.current.model == "iPad"
    static var isBangs : Bool {
        if UIDevice.current.model == "iPad" {
            return false
        }
        
        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.delegate?.window,
                  let unwrapedWindow = window else {
                      return false
                  }
            if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                return true
            }
        }
        return false
    }
    static var statusBarHeight: CGFloat    = isBangs ? 44.0 : 20.0
    static var navigationBarHeight: CGFloat = statusBarHeight + 44.0
    static var tabBarHeight: CGFloat = statusBarHeight == 20 ? 49.0 : 83.0
    static var topSafeArea  = (statusBarHeight - 20.0)
    static var bottomSafeArea = tabBarHeight - 49.0
    static var screenBounds = UIScreen.main.bounds
    static var screenWidth: CGFloat = UIScreen.main.bounds.width
    static var screenHeight: CGFloat = UIScreen.main.bounds.height
    static var screenScale = UIScreen.main.scale
}

// MARK: - font
extension Constants {
    static var pageTitleFont = pingFangSCMediumFont(18)
}

// MARK: - colors
extension Constants {
    /// theme color
    static var themeColor           = DynamicColor(hexString: "#FF5300")
    /// theme disabled color
    static var themeDisabledColor   = DynamicColor(hexString: "#c7c7c7")
    /// theme dark color
    static var themeDarkColor       = DynamicColor(hexString: "#3D4455")
    /// theme background color
    static var themeBgColor         = DynamicColor(hexString: "#f6f6f6")
    /// theme button text color
    static var pureWhite            = DynamicColor(hexString: "#ffffff")
    /// main text color
    static var themeTitleColor      = DynamicColor(hexString: "#333333")
    /// product title color
    static var themeProductTitleColor = DynamicColor(hexString: "#040101")
    /// secondary text color
    static var themeSubtitleColor   = DynamicColor(hexString: "#999999")
    /// placeholder text color
    static var placeholderTextColor = DynamicColor(hexString: "#c7c7c7")
    /// form title text color
    static var formTitleTextColor   = DynamicColor(hexString: "#b4b4b4")
    /// dark btn background color
    static var darkBtnBgColor       = DynamicColor(hexString: "#3D4455")
    static var borderColor          = DynamicColor(hexString: "#E6E6E6")
}

// MARK: - method
extension Constants {
    /// debug environment log
    /// - Parameters:
    ///   - file: file name
    ///   - fn: function name
    ///   - line: line number
    ///   - message: content
    static func debugLog<T>(file: NSString = #file, fn: String = #function, line: Int = #line, _ message: T) {
        #if DEBUG
        print("---------------------------------------------------------------------------------------------------")
        let prefix = "fileName: \(file.lastPathComponent)\nlineNumber: \(line)\nmethodName: \(fn) \ncontent: \n"
        print(prefix, message)
        print("---------------------------------------------------------------------------------------------------\n")
        #endif
    }
    
    /// return a PingFangSC-Medium font
    /// - Parameter size: size
    /// - Returns: PingFangSC-Medium font
    static func pingFangSCMediumFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    /// return a PingFangSC-Regular font
    /// - Parameter size: size
    /// - Returns: PingFangSC-Regular font
    static func pingFangSCRegularFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    /// return a PingFangSC-Semibold font
    /// - Parameter size: size
    /// - Returns: PingFangSC-Semibold font
    static func pingFangSCSemiboldFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    /// Randomly generate a color value for test
    static var random : UIColor {
        UIColor(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1)
    }
}
