//
//  UserSearchViewController.swift
//  matchness
//
//  Created by user on 2019/02/05.
//  Copyright © 2019年 a2c. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit

class UserSearchViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate  {

    @IBOutlet weak var userDetail: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    let navBarHeight : CGFloat = 164.0

    let userDefaults = UserDefaults.standard
    
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiUserDate> = [:]
    var dataSourceOrder: Array<String> = []

    override func viewDidLoad() {
        print("チェックチェックチェックチェック")
        print(FBSDKAccessToken.current())

        if let _ = FBSDKAccessToken.current() {
            print("ログイン済み")
        } else {
            userDefaults.removeObject(forKey: "api_token")
            userDefaults.removeObject(forKey: "login_type")

            print("みログイン")
            // 画面遷移
            let storyboard: UIStoryboard = self.storyboard!
            // ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let multiple = storyboard.instantiateViewController(withIdentifier: "fblogin")
            // ここが実際に移動するコードとなります
            self.present(multiple, animated: false, completion: nil)
        }
        super.viewDidLoad()
        userDetail.delegate = self
        userDetail.dataSource = self
        if let tabItem = self.tabBarController?.tabBar.items?[2] {
            tabItem.badgeValue = "new"
        }

        self.userDetail.register(UINib(nibName: "UserSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "userDetailCell")
        // Do any additional setup after loading the view.


        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestUserSearchModel = UserSearchModel();
        requestUserSearchModel.delegate = self as! UserSearchModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_SEARCH;
        //パラメーター
        let query: Dictionary<String,String> = Dictionary<String,String>();
        //リクエスト実行
        if( !requestUserSearchModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        //タブバー表示
        tabBarController?.tabBar.isHidden = false
    }

    
    override func viewWillAppear(_ animated: Bool) {
        print("ここにこに")
        super.viewWillAppear(animated)
        //タブバー表示
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("こっちにも恋")
        //タブバー表示
        tabBarController?.tabBar.isHidden = false
    }

    //データの個数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        return 30
        return self.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UserSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "userDetailCell", for: indexPath as IndexPath) as! UserSearchCollectionViewCell

//        cell.agearea.text = self.dataSource[String(indexPath.row)]?.work
        cell.agearea.text = self.dataSource[String(indexPath.row)]?.name
        cell.job.text = self.dataSource[String(indexPath.row)]?.profile_text

        cell.tag = self.dataSource[String(indexPath.row)]!.id! ?? 0

        var number = Int.random(in: 1 ... 18)
        cell.imageView.image = UIImage(named: "\(number)")  
        

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 例えば端末サイズの半分の width と height にして 2 列にする場合
        let width: CGFloat = UIScreen.main.bounds.width / 2.025
        let height = width + 50
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)
        let user_id = selectedCell?.tag ?? 0
        self.performSegue(withIdentifier: "toUserDetail", sender: user_id)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "toUserDetail" {
            print("ユーザー詳細遷移前")
            print(sender)
            let udc:UserDetailViewController = segue.destination as! UserDetailViewController
            udc.user_id = sender as! Int
        }
    }
    
    
    @objc func onTap(_ sender: MyTapGestureRecognizer) {
        print("タップタップタップいいね")
        var target_id = sender.targetString!
        
        let requestUserSearchModel = UserSearchModel();
        requestUserSearchModel.delegate = self as! UserSearchModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_LIKE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["user_id"] = userDefaults.object(forKey: "matchness_user_id") as? String
        query["target_id"] = String(target_id)
        print("ハッスル")
        print(userDefaults.object(forKey: "matchness_user_id") as? String)
        //リクエスト実行
        if( !requestUserSearchModel.requestApi(url: requestUrl, addQuery: query) ){
            
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


extension UserSearchViewController : UserSearchModelDelegate {
    
    func onStart(model: UserSearchModel) {
        print("こちら/usersearch/UserSearchViewのonStart")
    }
    func onComplete(model: UserSearchModel, count: Int) {
        print("着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;

        print(self.dataSourceOrder)
        print("耳耳耳意味耳みm")
        
        //一つもなかったら
//        if( dataSourceOrder.isEmpty ){
//            return;
//        }
        
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
//        self.cellCount = 10;

        print("ががががががががが")
        print(self.dataSource)
        print(self.dataSourceOrder)

        
        //
        var count: Int = 0;
//        for(key, code) in dataSourceOrder.enumerated() {
//            count+=1;
//            if let jenre: ApiUserDateParam = dataSource[code] {
//                //取得したデータを元にコレクションを再構築＆更新
//                mapMenuView.addTagGroup(model: model, jenre: jenre);
//            }
//        }
        
        userDetail.reloadData()
    }
    func onFailed(model: UserSearchModel) {
        print("こちら/usersearch/UserSearchViewのonFailed")
    }
    
}