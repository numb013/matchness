//
//  baseViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/11/20.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import OneSignal

struct baseParam: Codable {
    let point: Int
    let notice: Int
    let like: Int
    let message: Int
    let footprint: Int
}

class baseViewController: UIViewController {

    private var requestAlamofire: Alamofire.Request?
//    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()


        let types = UIApplication.shared.enabledRemoteNotificationTypes()
        print("通知を通知を通知を通知を")
        print(types)
        print(UIRemoteNotificationType.self)

//        if types == UIRemoteNotificationType.None {
//            // push notification disabled
//            return false
//        }else{
//            // push notification enable
//            return true
//        }


        let osVersion = UIDevice.current.systemVersion
print("通知バーしょん")
print(osVersion)
        updateUI()


//        if osVersion < "8.0" {
//
//        }else{
//            if UIApplication.shared.isRegisteredForRemoteNotifications {
//                //通知が許可されている！！！！！
//                print("通知が許可されている通知が許可されている通知が許可されている")
//            }else{
//               //設定画面への誘導など
//                print("通知が無無無無無無無無")
//            }
//        }

        apiNoticeRequest()
    }

    func apiNoticeRequest() {
        print("APIへリクエスト（ユーザー取得")
        let requestUrl: String = ApiConfig.REQUEST_URL_API_BASE_PARAM;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var headers: [String : String] = [:]
        var api_key = userDefaults.object(forKey: "api_token") as? String
        if ((api_key) != nil) {
            headers = [
                "Accept" : "application/json",
                "Authorization" : "Bearer " + api_key!,
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }
        //onesignal（プッシュ通知のid取得）
        query["onesignal_id"] = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId


        print(query["onesignal_id"])
        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                print("取得!!!!!!!!!!!")
                guard let data = response.data else { return }
                 guard let baseParam = try? JSONDecoder().decode(baseParam.self, from: data) else {
                     return
                 }

                let userDefaults = UserDefaults.standard
                userDefaults.set(baseParam.point, forKey: "point")
                userDefaults.set(baseParam.notice, forKey: "notice")
                userDefaults.set(baseParam.like, forKey: "like")
                userDefaults.set(baseParam.footprint, forKey: "footprint")

                if (baseParam.notice != 0 || baseParam.like != 0 || baseParam.footprint != 0) {
                    if let tabItem = self.tabBarController?.tabBar.items?[3] {
                        tabItem.badgeValue = "N"
                    }
                } else {
                    if let tabBarItem = self.tabBarController?.tabBar.items?[3] as? UITabBarItem {
                        tabBarItem.badgeValue = nil
                    }
                }
                if baseParam.message != 0 {
                    if let tabItem = self.tabBarController?.tabBar.items?[2] {
                        tabItem.badgeValue = "N"
                    }
                }
            case .failure:
                //  リクエスト失敗 or キャンセル時
                let alert = UIAlertController(title: "サーバーエラー", message: "しばらくお待ちください", preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                })
                return;
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func updateUI() {
        guard let types = UIApplication.shared.currentUserNotificationSettings?.types else {
            print("000000")
            return
        }
        switch types {
        case [.badge, .alert]:
            print("11111")
        case [.badge]:
            print("22222")
        case []:
            print("33333")
        default:
            print(types)
            print("Handle the default case") //TODO
        }
    }
    
    
    
}

