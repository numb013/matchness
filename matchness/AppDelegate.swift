//
//  AppDelegate.swift
//  matchness
//
//  Created by user on 2019/02/05.
//  Copyright © 2019年 a2c. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

import Alamofire
import SwiftyJSON
import FacebookCore //in theory is just this one
import FBSDKCoreKit
import FBSDKShareKit
import GoogleSignIn
import Stripe

let userDefaults = UserDefaults.standard
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var api_key = userDefaults.object(forKey: "api_token") as? String
        // Client IDを設定する
        GIDSignIn.sharedInstance()?.clientID = "806178990139-ei082f93503lki48k1us1i88rk9pu6bb.apps.googleusercontent.com"
        //        return true
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "comp")
//        //rootViewControllerに入れる
//        self.window?.rootViewController = initialViewController
//        //表示
//        self.window?.makeKeyAndVisible()
//        return true

        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
        appId: "4346e763-bb7b-49c4-a900-0a78328b3c2a",
        handleNotificationAction: nil,
        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
        print("User accepted notifications: \(accepted)")
        })
        //END OneSignal initializataion code

        Stripe.setDefaultPublishableKey("pk_test_9ctOhFy7xdS9cYXFudRC4Smh001imsNQzB")

        if (api_key == nil || api_key == "") {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "fblogin")
            //rootViewControllerに入れる
            self.window?.rootViewController = initialViewController
            //表示
            self.window?.makeKeyAndVisible()
            return true
        }
        
        var login_step_2 = userDefaults.object(forKey: "login_step_2") as? String

        if (login_step_2 == nil) {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "profile")
            //rootViewControllerに入れる
            self.window?.rootViewController = initialViewController
            //表示
            self.window?.makeKeyAndVisible()
            return true
        }

        FirebaseApp.configure()
        return true
    }

//    func STPPaymentConfiguration;.shared().appleMerchantIdentifier = "your apple merchant identifier"

    func application(_ application: UIApplication,open url: URL,sourceApplication: String?,annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")

      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    

    // 追加する
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // GIDSignInのhandle()を呼び、返り値がtrueであればtrueを返す
        if GIDSignIn.sharedInstance()!.handle(url) {
            return true
        }
        return false
    }
    
    
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
}
