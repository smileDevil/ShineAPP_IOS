//
//  AppDelegate.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/9.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 var window: UIWindow?
 var isLandscape = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


// MARK: - 是否横屏
extension AppDelegate {
    @objc(application:supportedInterfaceOrientationsForWindow:) func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if isLandscape {
            return .landscapeLeft //只允许全景模式（横屏）
           // return .all //允许所有模式，手机转动会跟随转动
        }else{
            return .portrait //只能竖屏
        }
    }
}

/***
 解决iOS 9 横竖屏的问题
 This is a bug in iOS 9 that it failed to retrieve the supportedInterfaceOrientations for UIAlertController. And it seems it dropped to an infinite recursion loop in looking for the supportedInterfaceOrientations for UIAlertController
 https://stackoverflow.com/questions/31406820/uialertcontrollersupportedinterfaceorientations-was-invoked-recursively
 */
extension UIAlertController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    open override var shouldAutorotate: Bool {
        return false
    }
}
