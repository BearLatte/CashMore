//
//  AppDelegate.swift
//  CashMore
//
//  Created by Tim on 2023/5/31.
//

import UIKit
import Adjust
import AdSupport
import AppTrackingTransparency
import IQKeyboardManagerSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // 设置第一次启动的key
        _ = Constants.isFirstLaunch
        
        // 获取IDFA
        fetchIDFA()
        
        // 请求位置权限
        LocationManager.shared.requestLocationAuthorizaiton()
        
        let adjustConfig = ADJConfig(appToken: Constants.ADJUST_APP_TOKEN, environment: Constants.ADJUST_ENVIROMENT)
        Adjust.appDidLaunch(adjustConfig)
        
        IQKeyboardManager.shared.enable = true
        NetworkTool.shared.startMonitoring()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: HomeController())
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    private func fetchIDFA() {
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                if status == .authorized {
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    UserDefaults.standard.set(idfa, forKey: "IDFA")
                }
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled == true {
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                UserDefaults.standard.set(idfa, forKey: "IDFA")
            }
        }
    }
}

