//
//  AppDelegate.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/9.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

//iOS 系统版本号判断
let iOS_Version:Float = Float.init(UIDevice.current.systemVersion)!
let iOS10 = (iOS_Version >= 10.0)
let iOS8 = (iOS_Version >= 8.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 var window: UIWindow?
 var isLandscape = false
    
    private let PushKey = "1d6261a0ba792889f7a8d1c9"
    private let channel = "App Store"
    private let isProduction = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerForAPNs(launchOptions)
      
        
         NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.self.networkDidLogin(notification:)), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
              
        return true
    }

    //在这个通知的方法中，就可以拿到我们想要的registID
    @objc public func networkDidLogin(notification:NSNotification){

           if (JPUSHService.registrationID() != nil) {

            let str:String = JPUSHService.registrationID()
            UserDefaults.standard.set(str, forKey: "registId")
           }
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
    
    //MARK:配置极光推送
    func registerForAPNs(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        //适配系统版本
        if #available(iOS 10.0, *) {
            let entity = JPUSHRegisterEntity.init()
            entity.types = Int(Double(JPAuthorizationOptions.alert.rawValue) + TimeInterval(JPAuthorizationOptions.badge.rawValue) + Double(JPAuthorizationOptions.sound.rawValue));
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self as JPUSHRegisterDelegate)
        }else{
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }

        JPUSHService.setup(withOption: launchOptions,
                           appKey: PushKey,
                           channel: channel,
                           apsForProduction: isProduction)

    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error:\(error)")
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }


}

extension AppDelegate : JPUSHRegisterDelegate{
    //ios 12 support
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        if((notification != nil)  && ((notification?.request.trigger?.isKind(of: UNPushNotificationTrigger.self)) != nil)){
            //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
    }
    
   
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
//            UIApplication.shared.applicationIconBadgeNumber = notification.request.content.badge as! Int
        }
        print("前台 收到推送 userInfo=\(userInfo)")
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
         print("点击推送消息 content=\(response.notification.request.content.userInfo)")
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        let notification = NSNotification.Name(rawValue: "jpush")
         NotificationCenter.default.post(name: notification, object: nil, userInfo: nil)
        
        completionHandler()
        
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
