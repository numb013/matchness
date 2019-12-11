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

class baseViewController: UIViewController {

    private var requestAlamofire: Alamofire.Request?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        apiNoticeRequest()
        


        if let tabItem = self.tabBarController?.tabBar.items?[2] {
            tabItem.badgeValue = "3"
        }
        if let tabItem = self.tabBarController?.tabBar.items?[3] {
            tabItem.badgeValue = "4"
        }
        
        // Do any additional setup after loading the view.
    }
    
        func apiNoticeRequest() {
            print("APIへリクエスト（ユーザー取得")
            let requestUrl: String = ApiConfig.REQUEST_URL_API_EDIT_SETTING;
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

            self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
                switch response.result {
                case .success:
                    var json:JSON;
                    do{
                        json = try SwiftyJSON.JSON(data: response.data!);
                    } catch {
                        break;
                    }
                case .failure:
                    //  リクエスト失敗 or キャンセル時
                    let alert = UIAlertController(title: "設定", message: "失敗しました。", preferredStyle: .alert)
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

}
