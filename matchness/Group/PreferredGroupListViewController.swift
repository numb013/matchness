//
//  PreferredGroupListViewController.swift
//  matchness
//
//  Created by user on 2019/07/22.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PreferredGroupListViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var decisionButton: UIButton!
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;

    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiGroupRequest> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    private var requestAlamofire: Alamofire.Request?;

    var group_id: Int = Int()
//    var ActivityIndicator: UIActivityIndicatorView!
    var activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        // Do any additional setup after loading the view.

        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        view.addSubview(activityIndicatorView)

        decisionButton.isEnabled = false // ボタン無効
        decisionButton.backgroundColor = #colorLiteral(red: 0.4803626537, green: 0.05874101073, blue: 0.1950398982, alpha: 1)
        
        apiRequest()
    }
    

    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestPreferredGroupListModel = PreferredGroupListModel();
        requestPreferredGroupListModel.delegate = self as! PreferredGroupListModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_REQUEST_GROUP_EVENT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["group_id"] = String(self.group_id)
        //リクエスト実行
        if( !requestPreferredGroupListModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {

print("ZZZZZZZZZZZZZZZZZZ")
print(self.dataSource["0"])
        
        if (self.dataSource["0"]?.decision_type == 1) {
            print("ボタン有効ボタン有効ボタン有効ボタン有効ボタン有効")
            print(self.dataSource["0"]?.decision_type)
            decisionButton.isEnabled = true // ボタン有効
            decisionButton.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.6039506793, alpha: 1)
        } else {
            print("ボタン無効ボタン無効ボタン無効ボタン無効ボタン無効")
            print(self.dataSource["0"]?.decision_type)
            decisionButton.isEnabled = false // ボタン無効
            decisionButton.backgroundColor = #colorLiteral(red: 0.4803626537, green: 0.05874101073, blue: 0.1950398982, alpha: 1)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        var requestGroup = self.dataSource["0"]!.request_list[indexPath.row]

        cell.titel.text = requestGroup.name
        cell.period.text = requestGroup.age! + "歳"
        cell.joinNumber.text = "CCCCC"
        if (requestGroup.status == 1) {
            cell.joinButton.setTitle("希望", for: .normal)
            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            recognizer.targetString = "1"
            recognizer.targetUserId = requestGroup.user_id
            cell.joinButton.layer.backgroundColor = #colorLiteral(red: 0.0163966082, green: 0.5516188145, blue: 0.6297279, alpha: 1)
            cell.joinButton.addGestureRecognizer(recognizer)
        } else if (requestGroup.status == 2) {
            cell.joinButton.setTitle("確定", for: .normal)
            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            recognizer.targetString = "2"
            recognizer.targetUserId = requestGroup.user_id
            cell.joinButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4609032869, blue: 0.2899915278, alpha: 1)
            cell.joinButton.addGestureRecognizer(recognizer)
        }
        cell.joinButton.layer.cornerRadius = 5.0 //丸みを数値で変更できます

        if (requestGroup.profile_image == nil) {
            cell.groupTestImage.image = UIImage(named: "no_image")
        } else {
            let profileImageURL = image_url + (requestGroup.profile_image!)
            let url = NSURL(string: profileImageURL);
            let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
            cell.groupTestImage.image = UIImage(data:imageData! as Data)
        }


        cell.groupTestImage.isUserInteractionEnabled = true
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage(_:)))
        recognizer.targetUserId = requestGroup.user_id
        cell.groupTestImage.addGestureRecognizer(recognizer)

        return cell
    }

    @objc func onTapImage(_ sender: MyTapGestureRecognizer) {
        var user_id = sender.targetUserId!
        let storyboard: UIStoryboard = self.storyboard!
        let nextVC = storyboard.instantiateViewController(withIdentifier: "toUserDetail") as! UserDetailViewController
        nextVC.user_id = user_id
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    @objc func onTap(_ sender: MyTapGestureRecognizer) {
        print("タップタナンバー")
        var tap_number = sender.targetString!
        var user_id = sender.targetUserId!
        if (tap_number == "1"){
            if (self.dataSource["0"]?.decision_type == 0) {
                let alertController:UIAlertController =
                    UIAlertController(title:"参加を確定する",message: "本当に参加を確定しますか？",preferredStyle: .alert)
                // Default のaction
                let defaultAction:UIAlertAction =
                    UIAlertAction(title: "参加を確定する",style: .destructive,handler:{
                        (action:UIAlertAction!) -> Void in
                        // 処理
                        print("参加を確定する")
                        self.requestJoin(status:"2", user_id:user_id)
                    })
                // Cancel のaction
                let cancelAction:UIAlertAction =
                    UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                        (action:UIAlertAction!) -> Void in
                        // 処理
                        print("キャンセル")
                    })
                // actionを追加
                alertController.addAction(cancelAction)
                alertController.addAction(defaultAction)
                // UIAlertControllerの起動
                present(alertController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "参加人数オーバー", message: "確定人数が参加人数より多くなります、確定しているユーザーをキャンセルする必要があります", preferredStyle: .alert)
                // アラート表示
                self.present(alert, animated: true, completion: {
                    // アラートを閉じる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                })
            }
        } else if (tap_number == "2"){
            let alertController:UIAlertController =
                UIAlertController(title:"確定を戻す",message: "本当に確定を戻しますか？",preferredStyle: .alert)
            // Default のaction
            let defaultAction:UIAlertAction =
                UIAlertAction(title: "確定を戻す",style: .destructive,handler:{
                    (action:UIAlertAction!) -> Void in
                    // 処理
                    print("確定を戻す")
                    self.requestJoin(status:"1", user_id:user_id)
                })
            // Cancel のaction
            let cancelAction:UIAlertAction =
                UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                    (action:UIAlertAction!) -> Void in
                    // 処理
                    print("キャンセル")
                })
            // actionを追加
            alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            // UIAlertControllerの起動
            present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func BBB(_ sender: Any) {
        print("GGGGGGGGQQQQ")
    }
    
    @IBAction func GroupEventDelete(_ sender: Any) {
        print("GGGGGGGG")
        print(self.group_id)

        // ActivityIndicatorを作成＆中央に配置
//        self.ActivityIndicator = UIActivityIndicatorView()
//        self.ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        self.ActivityIndicator.center = self.view.center
//        // クルクルをストップした時に非表示する
//        self.ActivityIndicator.hidesWhenStopped = true
//        // 色を設定
//        self.ActivityIndicator.style = UIActivityIndicatorView.Style.gray
//        //Viewに追加
//        self.view.addSubview(self.ActivityIndicator)
//        self.ActivityIndicator.startAnimating()

        
                    let alertController:UIAlertController =
                        UIAlertController(title:"本当に削除してよろしいですか",message: "作成時に使用したポイントは戻りません"  ,preferredStyle: .alert)
                    // Default のaction
                    let defaultAction:UIAlertAction =
                        UIAlertAction(title: "削除",style: .destructive,handler:{
                            (action:UIAlertAction!) -> Void in

                            self.activityIndicatorView.startAnimating()
                            DispatchQueue.global(qos: .default).async {

                                // 非同期処理などを実行
                                Thread.sleep(forTimeInterval: 5)
                                // 非同期処理などが終了したらメインスレッドでアニメーション終了
                                DispatchQueue.main.async {
                                    // アニメーション終了
//                                    self.activityIndicatorView.stopAnimating()
                                    self.requestDeleteGroup(group_id:self.group_id)
                                }
                            }
                        })

                    // Cancel のaction
                    let cancelAction:UIAlertAction =
                        UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                            (action:UIAlertAction!) -> Void in
                            // 処理
                            print("キャンセル")
        //                    self.dismiss(animated: true, completion: nil)
                        })
                    
                    alertController.addAction(defaultAction)
                    alertController.addAction(cancelAction)
                    // UIAlertControllerの起動
                    self.present(alertController, animated: true, completion: nil)
        
//
//        activityIndicatorView.startAnimating()
//        DispatchQueue.global(qos: .default).async {
//            // 非同期処理などを実行
//            Thread.sleep(forTimeInterval: 5)
//            // 非同期処理などが終了したらメインスレッドでアニメーション終了
//            DispatchQueue.main.async {
//                // アニメーション終了
//                self.activityIndicatorView.stopAnimating()
//            }
//        }
        
        self.requestDeleteGroup(group_id:group_id)
    }
    
    func requestJoin(status: String, user_id: Int) {

        print("ジョインジョインジョインジョインジョイン")

        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestPreferredGroupListModel = PreferredGroupListModel();
        requestPreferredGroupListModel.delegate = self as! PreferredGroupListModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_REQUEST_GROUP_EVENT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();

        query["user_id"] = String(user_id)
        query["group_id"] = String(self.group_id)
        query["status"] = status
        query["type"] = "2"
        if( !requestPreferredGroupListModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }

    
    @IBAction func decisionAction(_ sender: Any) {
        print("確定")

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionChoise1 = UIAlertAction(title: "今日から始める", style: .default){
            action in
            self.eventStart(1)
        }
        let actionChoise2 = UIAlertAction(title: "翌日から始める", style: .default){
            action in

            self.eventStart(2)
        }

        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel){
            (action) -> Void in
             print("Cancel")
         }
        // actionを追加
        alertController.addAction(actionChoise1)
        alertController.addAction(actionChoise2)
        alertController.addAction(actionCancel)
        // UIAlertControllerの起動
        present(alertController, animated: true, completion: nil)
    }
    
    
    func eventStart(_ status:Int) {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestPreferredGroupListModel = PreferredGroupListModel();
        requestPreferredGroupListModel.delegate = self as! PreferredGroupListModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_GROUP_EVENT_START;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var headers: [String : String] = [:]
        query["group_id"] = String(self.group_id)
        query["start_status"] = String(status)

        
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
//
//                self.ActivityIndicator.stopAnimating()
//                self.activityIndicatorView.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            case .failure:
                //  リクエスト失敗 or キャンセル時
                let alert = UIAlertController(title: "設定", message: "失敗しました。", preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                })
                return;
            }
        }
        
        
        
    }
    
    
        func requestDeleteGroup(group_id: Int) {
            print("APIへリクエスト（ユーザー取得")
            let requestUrl: String = ApiConfig.REQUEST_URL_API_RECRUITMENT_DELETE_GROUP;
            //パラメーター
            var query: Dictionary<String,String> = Dictionary<String,String>();
            var headers: [String : String] = [:]
            query["group_id"] = String(group_id)

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

//                    self.ActivityIndicator.stopAnimating()
                    self.activityIndicatorView.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                case .failure:
                    //  リクエスト失敗 or キャンセル時
                    let alert = UIAlertController(title: "設定", message: "失敗しました。", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            alert.dismiss(animated: true, completion: nil)
                        })
                    })
                    return;
                }
            }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let setteing_status:[String:Any] = ["status":"2", "indexPath":indexPath]
        self.performSegue(withIdentifier: "toGroupEvent", sender: setteing_status)
    }
}


extension PreferredGroupListViewController : PreferredGroupListModelDelegate {
    func onFinally(model: PreferredGroupListModel) {
        print("こちら/usersearch/UserSearchViewのonStart")
    }
    
    func onStart(model: PreferredGroupListModel) {
        print("こちら/usersearch/UserSearchViewのonStart")
    }
    func onComplete(model: PreferredGroupListModel, count: Int) {
        print("着てきてきてきてZZZZZZZZZ")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        self.cellCount = self.dataSource["0"]!.request_list.count;
        var count: Int = 0;
        tableView.reloadData()
    }
    func onFailed(model: PreferredGroupListModel) {
        print("こちら/usersearch/UserSearchViewのonFailed")
    }
    
    func onError(model: PreferredGroupListModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }

}
