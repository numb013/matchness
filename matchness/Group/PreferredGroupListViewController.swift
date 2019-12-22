//
//  PreferredGroupListViewController.swift
//  matchness
//
//  Created by user on 2019/07/22.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class PreferredGroupListViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiGroupRequestList> = [:]
    var dataSourceOrder: Array<String> = []
    var group_id: Int = Int()
    var ActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        // Do any additional setup after loading the view.
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
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String
        
        query["user_id"] = matchness_user_id
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        var requestGroup = self.dataSource[String(indexPath.row)]
        cell.titel.text = requestGroup?.name
        cell.period.text = requestGroup!.age! + "歳"
        cell.joinNumber.text = "CCCCC"

        if (requestGroup?.status == 1) {
            cell.joinButton.setTitle("希望", for: .normal)
            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            recognizer.targetString = "1"
            recognizer.targetUserId = requestGroup?.user_id
            cell.joinButton.layer.backgroundColor = #colorLiteral(red: 0.0163966082, green: 0.5516188145, blue: 0.6297279, alpha: 1)
            cell.joinButton.addGestureRecognizer(recognizer)
        } else if (requestGroup?.status == 2) {
            cell.joinButton.setTitle("確定", for: .normal)
            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            recognizer.targetString = "2"
            recognizer.targetUserId = requestGroup?.user_id
            cell.joinButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4609032869, blue: 0.2899915278, alpha: 1)
            cell.joinButton.addGestureRecognizer(recognizer)
        }
        cell.joinButton.layer.cornerRadius = 5.0 //丸みを数値で変更できます


       var number = Int.random(in: 1 ... 18)
        cell.groupTestImage.image = UIImage(named: "\(number)")
        cell.groupTestImage.isUserInteractionEnabled = true
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage(_:)))
        recognizer.targetUserId = requestGroup?.user_id
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
    }
    
    
    
    func requestJoin(status: String, user_id: Int) {
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
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String
        
        query["user_id"] = String(user_id)
        query["group_id"] = String(self.group_id)
        query["status"] = status
        query["type"] = "2"
        print("リリリリリリリリリリリリリリリリr")
        print(query)
        
        //リクエスト実行
        if( !requestPreferredGroupListModel.requestApi(url: requestUrl, addQuery: query) ){
            
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
        print("着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        self.cellCount = dataSourceOrder.count;
        var count: Int = 0;
        tableView.reloadData()
    }
    func onFailed(model: PreferredGroupListModel) {
        print("こちら/usersearch/UserSearchViewのonFailed")
    }

    func onError(model: PreferredGroupListModel) {
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
