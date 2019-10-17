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

class FBLoginViewController: UIViewController, LoginButtonDelegate {
    
var userProfile : NSDictionary = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Facebookログイン用ボタンがSDKに用意されている
        let facebookLoginButton = FBLoginButton()
        // アクセス許可
        facebookLoginButton.permissions = ["public_profile", "email"]
        facebookLoginButton.center = self.view.center
        facebookLoginButton.delegate = self
        self.view.addSubview(facebookLoginButton)

        // ログイン済みかチェック
        checkloginFacebook()
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
                print("AAAAAAAAAA")
                //画面遷移
                let storyboard: UIStoryboard = self.storyboard!
                //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                let multiple = storyboard.instantiateViewController(withIdentifier: "profile")
                //ここが実際に移動するコードとなります
                self.present(multiple, animated: false, completion: nil)
                //画面遷移
//                performSegue(withIdentifier: "toProfile", sender: self)
            }
        }else{
            print("BBBBBBBBB")
            print("エラー")
        }
    }
    //    ログアウトコールバック
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
        
    }
}

