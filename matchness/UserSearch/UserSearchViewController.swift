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

class UserSearchViewController: baseViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate  {

    @IBOutlet weak var userDetail: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var ActivityIndicator: UIActivityIndicatorView!
    
    let navBarHeight : CGFloat = 164.0
    let userDefaults = UserDefaults.standard
    var cellCount: Int = 0

    var dataSource: Dictionary<String, ApiUserDate> = [:]
    var dataSourceOrder: Array<String> = []
    var page_no = "1"
    var isLoading:Bool = false

    var freeword = ""
    var work: String? = nil
    var prefecture_id: String? = nil
    var blood_type: String? = nil
    var fitness_parts_id: String? = nil
    
    
    override func viewDidLoad() {

//        print("AAAAAAAAAA")
//        //画面遷移
//        let storyboard: UIStoryboard = self.storyboard!
//        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
//        let multiple = storyboard.instantiateViewController(withIdentifier: "pointPayment")
//        multiple.modalPresentationStyle = .fullScreen
//        //ここが実際に移動するコードとなります
//        self.present(multiple, animated: true, completion: nil)
//        画面遷移
//                performSegue(withIdentifier: "payment", sender: self)

        print("チェックチェックチェックチェック")
        print(AccessToken.current)

//        tabBarController?.tabBar.isHidden = true
        
        if let _ = AccessToken.current {
            print("ログイン済み")
        } else {
            userDefaults.removeObject(forKey: "api_token")
            userDefaults.removeObject(forKey: "login_type")

            print("みログイン")
            // 画面遷移
            let storyboard: UIStoryboard = self.storyboard!
            // ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let multiple = storyboard.instantiateViewController(withIdentifier: "fblogin") as! FBLoginViewController
            multiple.modalPresentationStyle = .fullScreen
            // ここが実際に移動するコードとなります
            self.present(multiple, animated: false, completion: nil)
        }
        super.viewDidLoad()
        userDetail.delegate = self
        userDetail.dataSource = self

        self.userDetail.register(UINib(nibName: "UserSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "userDetailCell")
        // Do any additional setup after loading the view.
        apiRequest()
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
        self.isLoading = true
        self.page_no = "1"
        self.dataSourceOrder = []
        var dataSource: Dictionary<String, ApiUserDate> = [:]


        // ActivityIndicatorを作成＆中央に配置
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        // 色を設定
        ActivityIndicator.style = UIActivityIndicatorView.Style.gray
        //Viewに追加
        self.view.addSubview(ActivityIndicator)
        ActivityIndicator.startAnimating()

        apiRequest()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(self.isLoading)
        print("EEWEWEEEEEEEEEEEEEEEEEE")
        print(scrollView.contentOffset.y)
        print(userDetail.contentSize.height - self.userDetail.bounds.size.height)
        
        if (!self.isLoading && scrollView.contentOffset.y  < -67.5) {
            self.isLoading = true
            self.page_no = "1"
            self.dataSourceOrder = []
            var dataSource: Dictionary<String, ApiUserDate> = [:]
            print("更新")
            // ActivityIndicatorを作成＆中央に配置
            ActivityIndicator = UIActivityIndicatorView()
            ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            ActivityIndicator.center = self.view.center
            // クルクルをストップした時に非表示する
            ActivityIndicator.hidesWhenStopped = true
            // 色を設定
            ActivityIndicator.style = UIActivityIndicatorView.Style.gray
            //Viewに追加
            self.view.addSubview(ActivityIndicator)
            ActivityIndicator.startAnimating()
            apiRequest()
        }
        
        if (!self.isLoading && scrollView.contentOffset.y + 2  >= userDetail.contentSize.height - self.userDetail.bounds.size.height) {
            self.isLoading = true
            print("無限スクロール無限スクロール無限スクロール")
            apiRequest()
        }
    }
    
    
    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestUserSearchModel = UserSearchModel();
        requestUserSearchModel.delegate = self as! UserSearchModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_SEARCH;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();

        print("午後午後午後午後午後ごg")
//        self.page_no = String(model.page);
        print(page_no)
        requestUserSearchModel.array1 = self.dataSourceOrder
        requestUserSearchModel.array2 = self.dataSource
        //リクエスト実行
        query["page"] = page_no

        query["freeword"] = userDefaults.object(forKey: "searchFreeword") as? String
        query["work"] = userDefaults.object(forKey: "searchWork") as? String
        query["prefecture_id"] = userDefaults.object(forKey: "searchFitnessPartsId") as? String
        query["blood_type"] = userDefaults.object(forKey: "searchBloodType") as? String
        query["fitness_parts_id"] = userDefaults.object(forKey: "searchPrefectureId") as? String
        
        
        print("検索ーーーーーーーーーーー")
        print(query)
        

        if( !requestUserSearchModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }

//    userDetail: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionView, forRowAt indexPath: IndexPath) {
        // 下から５件くらいになったらリフレッシュ
        guard collectionView.cellForItem(at: IndexPath(row: collectionView.numberOfItems(inSection: 0)-5, section: 0)) != nil else {
            print("下下下下下下下下下下下下下下下下")

            return
        }
       print("したしたしたしたしたしたした")
    }

    //データの個数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        return 30
        return self.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var search = self.dataSource[String(indexPath.row)]

        let cell : UserSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "userDetailCell", for: indexPath as IndexPath) as! UserSearchCollectionViewCell

//        cell.agearea.text = self.dataSource[String(indexPath.row)]?.work
        cell.agearea.text = search?.name
        
        cell.job.text = "痩せたい部位:" + ApiConfig.FITNESS_LIST[search!.fitness_parts_id!]
        cell.tag = search?.id! ?? 0

        var number = Int.random(in: 1 ... 18)
        cell.imageView.image = UIImage(named: "\(number)")

//        //urlでの画像の表示
//        let url = NSURL(string:"http://k.yimg.jp/images/top/sp2/cmn/logo-ns-131205.png")
//        let req = NSURLRequest(url:url! as URL)
//        NSURLConnection.sendAsynchronousRequest(req as URLRequest, queue:OperationQueue.main){(res, data, err) in
//            let image = UIImage(data:data!)
//             cell.imageView.image = image
//        }

        cell.new_flag.isHidden = true
        print(search)

        
        if (search?.created_flag != nil) {
            if (search!.created_flag! == 1) {
                cell.new_flag.image = UIImage(named: "new2")
                cell.new_flag.isHidden = false
            }
            if (search!.created_flag! == 2) {
                cell.new_flag.image = UIImage(named: "new2")
                cell.new_flag.isHidden = false
            }
            if (search!.created_flag! == 3) {
                cell.new_flag.image = UIImage(named: "new2")
                cell.new_flag.isHidden = false
            }
        }
        
        
        if (search?.last_login_flag != nil) {
            if (search!.last_login_flag! == 1) {
                cell.new_flag.image = UIImage(named: "new1")
                cell.new_flag.isHidden = false
            }
            if (search!.last_login_flag! == 2) {
                cell.new_flag.image = UIImage(named: "new1")
                cell.new_flag.isHidden = false
            }
            if (search!.last_login_flag! == 3) {
                cell.new_flag.image = UIImage(named: "new1")
                cell.new_flag.isHidden = false
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 例えば端末サイズの半分の width と height にして 2 列にする場合
//        let width: CGFloat = UIScreen.main.bounds.width / 2.025
        let width: CGFloat = UIScreen.main.bounds.width / 2.07
        let height = width + 50
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)
        let user_id = selectedCell?.tag ?? 0
//        self.performSegue(withIdentifier: "toUserDetail", sender: user_id)
        //画面遷移
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "toUserDetail") as! UserDetailViewController
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.user_id = user_id
        //ここが実際に移動するコードとなります
        self.present(nextVC, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "toUserDetail" {
            print("ユーザー詳細遷移前")
            print(sender)
            let udc:UserDetailViewController = segue.destination as! UserDetailViewController
            udc.user_id = sender as! Int
        }
    }

    
    @IBAction func searchButton(_ sender: Any) {
        print("検索検索検索検索検索")
        self.performSegue(withIdentifier: "searchButton", sender: nil)
    }
    
    @IBAction func backSearchView(segue:UIStoryboardSegue){
        NSLog("backSearchView#backSearchView")
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
    func onFinally(model: UserSearchModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
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
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;

        print("路オロロロロロロロロ路r")
        self.page_no = String(model.page);
        print(self.page_no)
        print("ががががががががが")
        print(self.dataSource)
        print(self.dataSourceOrder)

        var count: Int = 0;
        self.isLoading = false
        ActivityIndicator.stopAnimating()
        userDetail.reloadData()
    }
    func onFailed(model: UserSearchModel) {
        print("こちら/usersearch/UserSearchViewのonFailed")
    }

    func onError(model: UserSearchModel) {
        ActivityIndicator.stopAnimating()
        let alertController:UIAlertController = UIAlertController(title:"サーバーエラー",message: "アプリを再起動してください",preferredStyle: .alert)
        // Default のaction
        let defaultAction:UIAlertAction = UIAlertAction(title: "アラートを閉じる",style: .destructive,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                //  self.dismiss(animated: true, completion: nil)
            })
        alertController.addAction(defaultAction)
        // UIAlertControllerの起動
        self.present(alertController, animated: true, completion: nil)
    }
}

