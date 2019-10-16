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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let fbLoginBtn = FBLoginButton()
//            fbLoginBtn.readPermissions = ["public_profile", "email"]
            fbLoginBtn.center = self.view.center
            fbLoginBtn.delegate = self
    }
    
    //    ログインコールバック
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        //        エラーチェック
        if error == nil {
            //            キャンセルしたかどうか
            if result.isCancelled {
                print("キャンセルFBlogin")
            }else{
                print("AAAAAAAAAA")
                //            画面遷移
                let storyboard: UIStoryboard = self.storyboard!
                //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                let multiple = storyboard.instantiateViewController(withIdentifier: "profile")
                //ここが実際に移動するコードとなります
                self.present(multiple, animated: false, completion: nil)


                //                画面遷移
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

