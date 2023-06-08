//
//  Constants.swift
//  CashMore
//
//  Created by Tim on 2023/6/1.
//

import Foundation
import AdSupport
import Adjust
@_exported import DynamicColor

struct Constants {
    static let IS_LOGIN     = "kIS_LOGIN"
    static let IS_CERTIFIED = "kIS_CERTIFIED"
    static let ACCESS_TOKEN = "kACCESS_TOKEN"
    static let ADJUST_APP_TOKEN = "94ai1nsbc1ds"
    static var ADJUST_ENVIROMENT : String {
        #if DEBUG
        return ADJEnvironmentSandbox
        #else
        return ADJEnvironmentProduction
        #endif
    }
    
    static var isLogin : Bool {
        true
//        UserDefaults.standard.bool(forKey: IS_LOGIN)
    }
    
    static var isCertified : Bool {
        UserDefaults.standard.bool(forKey: IS_CERTIFIED)
    }
    
    static var token : String? {
        UserDefaults.standard.string(forKey: ACCESS_TOKEN)
    }
    
    static var deviceInfo : [String : Any] {
        var dict : [String : Any] = [:]
        dict["appVersion"] = Bundle.tm.productVersion
        dict["bag"]   = Bundle.tm.bundleId
        dict["brand"] = "Apple"
        dict["deviceModel"] = UIDevice.current.model
        dict["osVersion"] =  UIDevice.current.systemVersion
        dict["operationSys"] = UIDevice.current.systemName
        dict["advertising_id"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        dict["udid"] = UIDevice.current.identifierForVendor?.uuidString
        dict["channel"] = "AppStore"
        dict["mac"] = ""
        return dict
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
    static var darkBgColor          = DynamicColor(hexString: "#41465A")
    static var borderColor          = DynamicColor(hexString: "#E6E6E6")
}

// MARK: - method
extension Constants {
    /// Form page label indicator for camera
    static var indicatorLabel : UILabel {
        let lb = UILabel()
        lb.text = "Clear & original documents"
        lb.font = Constants.pingFangSCRegularFont(14)
        lb.textColor = Constants.themeSubtitleColor
        return lb
    }
    
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
    
    
    /// Create a UIButton with an image on top
    static func imageOnTopBtn(with image: UIImage?, title: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setImage(image, for: .normal)
        btn.setTitleColor(Constants.pureWhite, for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCRegularFont(14)
        if #available(iOS 15.0, *) {
            var btnConfig = UIButton.Configuration.borderedProminent()
            btnConfig.baseBackgroundColor = Constants.themeColor
            btnConfig.imagePadding = 5
            btnConfig.imagePlacement = .top
            btn.configuration = btnConfig
        } else {
            btn.tm.centerImageAndButton(0, imageOnTop: true)
            btn.backgroundColor = Constants.themeColor
            btn.layer.cornerRadius = 10
        }
        
        return btn
    }
    
    static func themeBtn(with title: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.backgroundColor = Constants.themeColor
        btn.layer.cornerRadius = 25
        btn.titleLabel?.font = Constants.pingFangSCMediumFont(18)
        btn.setTitleColor(pureWhite, for: .normal)
        return btn
    }
    
    
    static func configParameters(_ parameters: [String : Any]?) -> [String : Any] {
        var body = parameters ?? [:]
        body["noncestr"] = String.tm.randomString(with: 30)
        // 生成一个参数进行验签
        var  keyString : String
        #if DEBUG
        keyString = String.tm.sortedDictionary(with: body) + "&" + "indiakey=6ShEUmiNSp9sQWgBzS8N831zyJXlKEKrjqlcZBZN"
        #else
        keyString = ""
        #endif
        Constants.debugLog("加密前" + keyString)
        let signStr = keyString.tm.md5.uppercased()
        Constants.debugLog("加密后" + signStr)
        body["sign"] = signStr
        
        return body
    }
    
    static func topViewController(_ vc: UIViewController) -> UIViewController {
        if vc.isKind(of: UITabBarController.self) {
            return topViewController((vc as! UITabBarController).selectedViewController!)
        } else if vc.isKind(of: UINavigationController.self) {
            return topViewController((vc as! UINavigationController).topViewController!)
        } else {
            return vc
        }
    }
    
}
