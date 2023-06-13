//
//  AppDelegate.swift
//  CashMore
//
//  Created by Tim on 2023/5/31.
//

import UIKit
import IQKeyboardManagerSwift
import Adjust

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // 设置第一次启动的key
        _ = Constants.isFirstLaunch
        
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

