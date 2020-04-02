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

    var activityIndicatorView = UIActivityIndicatorView()
    let navBarHeight : CGFloat = 164.0
    let userDefaults = UserDefaults.standard
    var cellCount: Int = 0

    var dataSource: Dictionary<String, ApiUserDate> = [:]
    var errorData: Dictionary<String, ApiErrorAlert> = [:]

    var dataSourceOrder: Array<String> = []
    var page_no = "1"
    var isLoading:Bool = false
    var isUpdate:Bool = false

    var freeword = ""
    var work: String? = nil
    var prefecture_id: String? = nil
    var blood_type: String? = nil
    var sex: String? = nil
    var fitness_parts_id: String? = nil
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;

    override func viewDidLoad() {
        super.viewDidLoad()
        userDetail.delegate = self
        userDetail.dataSource = self

        view.backgroundColor = .lightGray
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        view.addSubview(activityIndicatorView)
        
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
        var errorData: Dictionary<String, ApiErrorAlert> = [:]

        activityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .default).async {
            // 非同期処理などを実行
            Thread.sleep(forTimeInterval: 5)
            // 非同期処理などが終了したらメインスレッドでアニメーション終了
            DispatchQueue.main.async {
                // アニメーション終了
                self.activityIndicatorView.stopAnimating()
            }
        }
        apiRequest()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!self.isLoading && scrollView.contentOffset.y  < -67.5) {
            self.isLoading = true
            self.page_no = "0"
            self.dataSourceOrder = []
            var dataSource: Dictionary<String, ApiUserDate> = [:]
            print("更新更新更新更新更新")
            activityIndicatorView.startAnimating()
            DispatchQueue.global(qos: .default).async {
                // 非同期処理などを実行
                Thread.sleep(forTimeInterval: 5)
                // 非同期処理などが終了したらメインスレッドでアニメーション終了
                DispatchQueue.main.async {
                    // アニメーション終了
                    self.activityIndicatorView.stopAnimating()
                }
            }
            apiRequest()
        }
        if (!self.isUpdate) {
            if (!self.isLoading && scrollView.contentOffset.y + 2  >= userDetail.contentSize.height - self.userDetail.bounds.size.height) {
                self.isLoading = true
                print("無限スクロール無限スクロール無限スクロール")
                apiRequest()
            }
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
        requestUserSearchModel.array1 = self.dataSourceOrder
        requestUserSearchModel.array2 = self.dataSource
        //リクエスト実行
        query["page"] = page_no

        query["freeword"] = userDefaults.object(forKey: "searchFreeword") as? String
        query["work"] = userDefaults.object(forKey: "searchWork") as? String
        query["prefecture_id"] = userDefaults.object(forKey: "searchFitnessPartsId") as? String
        query["blood_type"] = userDefaults.object(forKey: "searchBloodType") as? String
        query["sex"] = userDefaults.object(forKey: "searchSex") as? String
        query["fitness_parts_id"] = userDefaults.object(forKey: "searchPrefectureId") as? String
        
        if( !requestUserSearchModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }

//    userDetail: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionView, forRowAt indexPath: IndexPath) {
        // 下から５件くらいになったらリフレッシュ
        guard collectionView.cellForItem(at: IndexPath(row: collectionView.numberOfItems(inSection: 0)-5, section: 0)) != nil else {
            return
        }
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

        if (search != nil) {
    //        cell.agearea.text = self.dataSource[String(indexPath.row)]?.work
            cell.agearea.text = search?.name
            cell.job.text = "痩せたい箇所:" + ApiConfig.FITNESS_LIST[search!.fitness_parts_id!]
            cell.tag = search?.id! ?? 0

            if (search?.profile_image == nil) {
                cell.imageView.image = UIImage(named: "no_image")
            } else {
                let profileImageURL = image_url + search!.profile_image!
                let url = NSURL(string: profileImageURL);
                let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
                cell.imageView.image = UIImage(data:imageData! as Data)
            }

            cell.new_flag.isHidden = true
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
        self.performSegue(withIdentifier: "toDetail", sender: user_id)



////        self.performSegue(withIdentifier: "toSearch", sender: user_id)
//        //画面遷移
//        let storyboard: UIStoryboard = self.storyboard!
//        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
//        let nextVC = storyboard.instantiateViewController(withIdentifier: "toUserDetail") as! UserDetailViewController
//        nextVC.modalPresentationStyle = .fullScreen
//        nextVC.user_id = user_id
//        //ここが実際に移動するコードとなります
//        self.present(nextVC, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "toDetail" {
            let udc:UserDetailViewController = segue.destination as! UserDetailViewController
            udc.user_id = sender as! Int
        }
    }
        
    @IBAction func searchButton(_ sender: Any) {
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
        if (self.dataSourceOrder.isEmpty) {
            let alertController:UIAlertController = UIAlertController(title:"該当なし",message: "再度検索してください",preferredStyle: .alert)
            let cancelAction:UIAlertAction =
                UIAlertAction(title: "閉じる",style: .cancel,handler:{
                    (action:UIAlertAction!) -> Void in
                    print("キャンセル")
                })
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    func onStart(model: UserSearchModel) {
        print("こちら/usersearch/UserSearchViewのonStart")
    }
    func onComplete(model: UserSearchModel, count: Int) {
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        if (Int(self.page_no)! > 3 && self.cellCount == dataSourceOrder.count) {
            self.isLoading = false
            self.isUpdate = true
        } else {
            self.cellCount = dataSourceOrder.count;
            self.page_no = String(model.page);
            print(self.page_no)
            var count: Int = 0;
            self.isLoading = false
        }
        self.activityIndicatorView.stopAnimating()
        userDetail.reloadData()
    }
    func onFailed(model: UserSearchModel) {
        print("こちら/usersearch/UserSearchViewのonFailed")
    }

    func onError(model: UserSearchModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
//        ActivityIndicator.stopAnimating()
        activityIndicatorView.stopAnimating()
    }
}

