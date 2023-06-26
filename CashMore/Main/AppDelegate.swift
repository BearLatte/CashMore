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
import FacebookCore


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // 设置第一次启动的key
        _ = Constants.isFirstLaunch
        
        launchNetwork()
        
        // 获取IDFA
        fetchIDFA()
        
        // 请求位置权限
        LocationManager.shared.requestLocationAuthorizaiton()
        
        // 初始化ADJust
        let adjustConfig = ADJConfig(appToken: Constants.ADJUST_APP_TOKEN, environment: Constants.ADJUST_ENVIROMENT)
        adjustConfig?.logLevel = ADJLogLevelVerbose
        Adjust.appDidLaunch(adjustConfig)
        
        IQKeyboardManager.shared.enable = true
        NetworkTool.shared.startMonitoring()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: HomeController())
        window?.makeKeyAndVisible()
        
        // facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
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

// MARK: - ADJust 和 facebook
extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
        fetchIDFA()
        Adjust.requestTrackingAuthorization()
    }
    
    
    
    // facebook
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate
            .shared
            .application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
    }
}

extension AppDelegate : AdjustDelegate {
    func adjustEventTrackingSucceeded(_ eventSuccessResponseData: ADJEventSuccess?) {}
    func adjustEventTrackingFailed(_ eventFailureResponseData: ADJEventFailure?) {}
    func adjustAttributionChanged(_ attribution: ADJAttribution?) {}
}

extension AppDelegate {
    private func launchNetwork() {
        APIService.standered.normalRequest(api: API.Common.firstLaunch) {
            Constants.debugLog("获取channel")
        }
    }
}

