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
import CoreTelephony


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        networkState(application: application, didFinishLaunchingWithOptions: launchOptions)
       
        // 设置打开app时间戳
        UIDevice.tm.setOpenAppTimeStamp()
        
//        launchNetwork()
        
        // 获取IDFA
        fetchIDFA()
        
        // 请求位置权限
        LocationManager.shared.requestLocationAuthorizaiton()
        
        // 初始化ADJust
        let adjustConfig = ADJConfig(appToken: Constants.ADJUST_APP_TOKEN, environment: ADJEnvironmentProduction)
        adjustConfig?.logLevel = ADJLogLevelVerbose
        adjustConfig?.delegate = self
        adjustConfig?.defaultTracker = "AppStore"
        adjustConfig?.allowIdfaReading = true
        Adjust.appDidLaunch(adjustConfig)
        
        IQKeyboardManager.shared.enable = true
        
        
        NetworkTool.shared.startMonitoring()
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: HomeController())
        window?.makeKeyAndVisible()
        
        // facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        Settings.shared.isAdvertiserTrackingEnabled = true
        return true
    }
    
    
    
}

extension AppDelegate {
    private func fetchIDFA() {
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                if status == .authorized {
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    UserDefaults.standard.set(idfa, forKey: Constants.IDFA_KEY)
                }
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled == true {
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                UserDefaults.standard.set(idfa, forKey: Constants.IDFA_KEY)
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
    
    private func networkState(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let cellularData = CTCellularData()
        cellularData.cellularDataRestrictionDidUpdateNotifier = {state in
            if state == .restricted {
                self.launchNetwork()
                NotificationCenter.default.post(name: Constants.networkStateChangedNotification, object: nil)
            }
        }
    }
    
    private func launchNetwork() {
        APIService.standered.normalRequest(api: API.Common.firstLaunch) {
        }
    }
}

