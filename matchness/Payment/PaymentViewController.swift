//
//  PaymentViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/10/31.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import SwiftyJSON


class PaymentViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    private var requestAlamofire: Alamofire.Request?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapButton(_ sender: Any) {




        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self as! STPAddCardViewControllerDelegate
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
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


extension PaymentViewController: STPAddCardViewControllerDelegate {
 
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        print("決済１１１１１")
        dismiss(animated: true)
    }
 

    
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {


 
        print("決済２２２２")

        print(token.tokenId)
        dismiss(animated: true)

        print("ハッスルクエスト")
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_CHARGE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["stripeToken"] = String(token.tokenId)
        query["amount"] = String(500)
        var headers: [String : String] = [:]

        var api_key = userDefaults.object(forKey: "api_token") as? String

        print("えーピアイトークンーピアイトークン")
        print(api_key)
        if ((api_key) != nil) {
            headers = [
                "Accept" : "application/json",
                "Authorization" : "Bearer " + api_key!,
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }
        print("ヘッダーヘッダーヘッダーヘッダーヘッダー")
        print(headers)
        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            print("リクエストRRRRRRRRRRRRRRRRRR")
            print(requestUrl)
//            print(method)
            print(query)
            print("リクエストBBBBBBBBBBBBBBBBBBBBB")
            switch response.result {
            case .success:
                var json:JSON;
                do{
                    //レスポンスデータを解析
                    json = try SwiftyJSON.JSON(data: response.data!);
                } catch {
                    // error
                    print("json error: \(error.localizedDescription)");
//                     self.onFaild(response as AnyObject);
                    break;
                }
                print("取得した値はここにきて")
                print(json)

                self.dismiss(animated: true, completion: nil)
                print("！！！！！！！！！！")

                // アラート作成
                let alert = UIAlertController(title: "ポイント", message: "ポイントを購入しました。", preferredStyle: .alert)
                // アラート表示
                self.present(alert, animated: true, completion: {
                    // アラートを閉じる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                })

            case .failure:
                //  リクエスト失敗 or キャンセル時
                print("リクエスト失敗 or キャンセル時")
                return;
            }
        }

        


        // token.tokenId と 価格をパラメーターとして先程作成したAPIを呼び出す
    }
}
