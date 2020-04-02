//
//  FBLoginViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/07/31.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import GoogleSignIn
import GTMSessionFetcher
import GoogleAPIClientForREST
import Alamofire
import SwiftyJSON


struct loginParam: Codable {
    let id: Int
    let api_token: String
    let is_user: Int
}

class FBLoginViewController: UIViewController, LoginButtonDelegate {
    
    private var requestAlamofire: Alamofire.Request?;
    var userProfile : NSDictionary = [:]

    var login_sns_type = ""
    var sns_id = ""
    var name = ""
    var email = ""
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Facebookログイン用ボタンがSDKに用意されている
        let facebookLoginButton = FBLoginButton()

        // アクセス許可
        facebookLoginButton.permissions = ["public_profile", "email"]
        facebookLoginButton.center = self.view.center
        facebookLoginButton.delegate = self

        let googleImage = UIImageView(image: UIImage(named: "googlelogin"))
        googleImage.isUserInteractionEnabled = true

        
        switch (UIScreen.main.nativeBounds.height) {
        case 480:
            // iPhone
            // iPhone 3G
            // iPhone 3GS
            googleImage.frame = CGRect(x:((self.view.bounds.width-220)/2),y:350,width:220,height:35)

            facebookLoginButton.frame = CGRect(x:((self.view.bounds.width-220)/2),y:400,width:220,height:35)
            print("heigh_1")
            break
        case 960:
            // iPhone 4
            // iPhone 4S
            print("heigh_2")
            googleImage.frame = CGRect(x:((self.view.bounds.width-220)/2),y:350,width:220,height:35)
            facebookLoginButton.frame = CGRect(x:((self.view.bounds.width-220)/2),y:410,width:220,height:35)
            break
        case 1136:
            // iPhone 5
            // iPhone 5s
            // iPhone 5c
            // iPhone SE
            print("heigh_3")
            googleImage.frame = CGRect(x:((self.view.bounds.width-220)/2),y:350,width:220,height:35)
            facebookLoginButton.frame = CGRect(x:((self.view.bounds.width-220)/2),y:400,width:220,height:35)
            break
        case 1334:
            // iPhone 6
            // iPhone 6s
            // iPhone 7
            // iPhone 8
            print("heigh_4")
            googleImage.frame = CGRect(x:((self.view.bounds.width-220)/2),y:550,width:220,height:35)
            facebookLoginButton.frame = CGRect(x:((self.view.bounds.width-220)/2),y:600,width:220,height:35)
            break
        case 2208:
            // iPhone 6 Plus
            // iPhone 6s Plus
            // iPhone 7 Plus
            // iPhone 8 Plus
            print("heigh_5")
            googleImage.frame = CGRect(x:((self.view.bounds.width-220)/2),y:350,width:220,height:35)

            facebookLoginButton.frame = CGRect(x:((self.view.bounds.width-220)/2),y:400,width:220,height:35)
            break
        case 2436:
            //iPhone X
            print("heigh_6")
            googleImage.frame = CGRect(x:((self.view.bounds.width-220)/2),y:650,width:220,height:35)

            facebookLoginButton.frame = CGRect(x:((self.view.bounds.width-220)/2),y:700,width:220,height:35)
            break
        case 1792:
            //iPhone XR
            print("heigh_7")
            googleImage.frame = CGRect(x:((self.view.bounds.width-220)/2),y:700,width:220,height:35)
            facebookLoginButton.frame = CGRect(x:((self.view.bounds.width-220)/2),y:780,width:220,height:35)
            break
        case 2688:
            //iPhone XR
            print("heigh_7")
            googleImage.frame = CGRect(x:((self.view.bounds.width-220)/2),y:700,width:220,height:35)
            facebookLoginButton.frame = CGRect(x:((self.view.bounds.width-220)/2),y:780,width:220,height:35)
            break
        default:
            print("heigh_8")
            break
        }

        self.view.addSubview(facebookLoginButton)
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage(_:)))
    //            recognizer.targetUserId = Int(message.target_id!)
        googleImage.addGestureRecognizer(recognizer)

        self.view.addSubview(googleImage)
        // ログイン済みかチェック
        checkloginFacebook()


        if let user = GIDSignIn.sharedInstance()?.currentUser {
            print("currentUser.profile.email: \(user.profile!.email!)")
        } else {
            // 次回起動時にはこちらのログが出力される
            print("currentUser is nil")
        }


        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /// ログイン済みかチェック
    func checkloginFacebook() {
        if let _ = AccessToken.current {
            print("Logged in")
        } else {
            print("Not Logged in")
        }
    }
    
    
    //    ログインコールバック
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        //エラーチェック
        if error == nil {
            //キャンセルしたかどうか
            if result.isCancelled {
                print("キャンセルFBlogin")
            }else{
                print("成功成功成功成功成功")

                returnUserData()
                //                //画面遷移
//                let storyboard: UIStoryboard = self.storyboard!
//                //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
//                let multiple = storyboard.instantiateViewController(withIdentifier: "profile")
//                multiple.modalPresentationStyle = .fullScreen
//                //ここが実際に移動するコードとなります
//                self.present(multiple, animated: false, completion: nil)
////                画面遷移
////                performSegue(withIdentifier: "toProfileAdd", sender: self)
            }
        }else{
            print("PPPPPPPPPPPPPPPPPPPP")
            print("エラー")
        }
    }
    //    ログアウトコールバック
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
        print("ログアウトコールバックログアウトコールバックログアウトコールバック")
    }

    //googleログイン
    @objc func onTapImage(_ sender: MyTapGestureRecognizer) {
        GIDSignIn.sharedInstance()?.delegate = self
        // ログイン画面の表示元を設定
        GIDSignIn.sharedInstance()?.presentingViewController = self

        if GIDSignIn.sharedInstance()!.hasPreviousSignIn() {
            // 以前のログイン情報が残っていたら復元する
            GIDSignIn.sharedInstance()!.restorePreviousSignIn()
        } else {
            // 通常のログインを実行
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    


    func returnUserData()
    {
        let graphRequest : GraphRequest = GraphRequest(
            graphPath: "me",
            parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
            graphRequest.start(completionHandler: {
            (connection, result, error) -> Void in
            if ((error) != nil)
            {
                // エラー処理
                print("Error: \(error)")
            } else {
                // エラー処理
                print("OKOKOKOKOKOKOKOK")
                self.userProfile = result as! NSDictionary
                print("aaaaaaaaaaaaaaaaaaaaaa")
                print(self.userProfile)
                print(self.userProfile.object(forKey: "picture") as AnyObject)

                self.login_sns_type = "1"
                self.sns_id = (self.userProfile.object(forKey: "id") as? String)!
                self.name = (self.userProfile.object(forKey: "name") as? String)!
                self.email = (self.userProfile.object(forKey: "email") as? String)!
                
                self.apiLoginCheck()
                
            }
        })
    }

   func apiLoginCheck() {
        print("APIへリクエスト（ユーザー取得")
        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_ADD;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        let headers = [
            "Accept" : "application/json",
            "Authorization" : "",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        query["name"] = self.name
        query["email"] = self.email
        query["login_sns_type"] = self.login_sns_type
        query["sns_id"] = self.sns_id

    
        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
               switch response.result {
               case .success:
                   print("取得!!!!!!!!!!!")
                   guard let data = response.data else { return }
                   print(data)
                    guard let loginParam = try? JSONDecoder().decode(loginParam.self, from: data) else {
                        print("取得失敗")
                        return
                    }

                    print("baseParambaseParambaseParambaseParam")
                    print(loginParam)

                    let userDefaults = UserDefaults.standard
                    userDefaults.set(loginParam.api_token, forKey: "api_token")
                    userDefaults.set(loginParam.id, forKey: "matchness_user_id")

                   
                    if (loginParam.is_user == 1) {
                        self.userDefaults.set("1", forKey: "login_step_2")
                        let storyboard: UIStoryboard = self.storyboard!
                        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                        let multiple = storyboard.instantiateViewController(withIdentifier: "start")
                        multiple.modalPresentationStyle = .fullScreen
                        //ここが実際に移動するコードとなります
                        self.present(multiple, animated: true, completion: nil)
                    } else {
//                        let storyboard: UIStoryboard = self.storyboard!
//                        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
//                        let multiple = storyboard.instantiateViewController(withIdentifier: "profile")
//                        multiple.modalPresentationStyle = .fullScreen
//                        //ここが実際に移動するコードとなります
//                        self.present(multiple, animated: false, completion: nil)
                        //画面遷移
                        self.performSegue(withIdentifier: "toProfileAdd", sender: self)
                
                
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


}

// GIDSignInDelegateへの適合とメソッドの追加を行う
extension FBLoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            // ログイン成功した場合
            print("signIned user email: \(user!.profile!.email!)")
            print(user!.userID)
            print(user!.profile!.name)
            print(user!.profile!.givenName)
            print(user!.profile!.familyName)

            self.login_sns_type = "2"
            self.sns_id = user!.userID
            self.name = user!.profile!.name
            self.email = user!.profile!.email!

            
            apiLoginCheck()

            let service = GTLRDriveService()
            service.authorizer = user.authentication.fetcherAuthorizer()
        } else {
            // ログイン失敗した場合
            print("error: \(error!.localizedDescription)")
        }
    }
}

