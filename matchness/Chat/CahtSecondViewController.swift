//
//  CahtSecondViewController.swift
//  matchness
//
//  Created by user on 2019/06/02.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CahtSecondViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate , UITableViewDataSource {
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "マッチング"
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiMatcheList> = [:]
    var dataSourceOrder: Array<String> = []
    @IBOutlet weak var ChatTableView: UITableView!
    var ActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        self.ChatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        // Do any additional setup after loading the view.
        apiRequest()
    }
    
    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestCahtRoomModel = CahtRoomModel();
        requestCahtRoomModel.delegate = self as! CahtRoomModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_MATCHE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String
        
        print("マッチマッチマッチマッチマッチマッチマッチ")
        
        query["user_id"] = matchness_user_id
        query["status"] = "0"
        //リクエスト実行
        if( !requestCahtRoomModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    

    var page_no = "1"
    var isLoading:Bool = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(self.isLoading)
        print("EEWEWEEEEEEEEEEEEEEEEEE")
        print(scrollView.contentOffset.y)
        print(ChatTableView.contentSize.height - self.ChatTableView.bounds.size.height)
        
        if (!self.isLoading && scrollView.contentOffset.y  < -67.5) {
            self.isLoading = true
            self.page_no = "1"
            self.dataSourceOrder = []
            var dataSource: Dictionary<String, ApiMatcheList> = [:]
            print("更新")
            apiRequest()
        }
        
        if (!self.isLoading && scrollView.contentOffset.y >= ChatTableView.contentSize.height - self.ChatTableView.bounds.size.height) {
            self.isLoading = true
            print("無限スクロール無限スクロール無限スクロール")
            apiRequest()
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var matche = self.dataSource[String(indexPath.row)]
        
        let cell = ChatTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        cell.ChatName.text = matche?.name
        cell.ChatDate.text = matche?.created_at
        cell.ChatMessage.text = "マッチングしました。メッセージを送れます。"


        var number = Int.random(in: 1 ... 18)
        cell.ChatImage.image = UIImage(named: "\(number)")
        cell.ChatImage.isUserInteractionEnabled = true
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage(_:)))
        recognizer.targetUserId = self.dataSource["0"]!.id
        cell.ChatImage.addGestureRecognizer(recognizer)
        cell.ChatImage.contentMode = .scaleAspectFill
        cell.ChatImage.clipsToBounds = true
        cell.ChatImage.layer.cornerRadius =  cell.ChatImage.frame.height / 2

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
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let setteing_status:[String:Any] = ["status":"2", "indexPath":indexPath]
        self.performSegue(withIdentifier: "toMessage", sender: setteing_status)
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}


extension CahtSecondViewController : CahtRoomModelDelegate {
    func onFinally(model: CahtRoomModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
    func onStart(model: CahtRoomModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: CahtRoomModel, count: Int) {
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
        
        
        //
        var count: Int = 0;
        //        for(key, code) in dataSourceOrder.enumerated() {
        //            count+=1;
        //            if let jenre: ApiUserDateParam = dataSource[code] {
        //                //取得したデータを元にコレクションを再構築＆更新
        //                mapMenuView.addTagGroup(model: model, jenre: jenre);
        //            }
        //        }
        self.isLoading = false
        ChatTableView.reloadData()
    }
    func onFailed(model: CahtRoomModel) {
        print("こちら/CahtRoomModel/UserDetailViewのonFailed")
    }

    func onError(model: CahtRoomModel) {
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

