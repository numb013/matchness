//
//  CahtFirstViewController.swift
//  matchness
//
//  Created by user on 2019/06/02.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CahtFirstViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate , UITableViewDataSource {
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "やりとり"
    let stepInstance = TodayStep()
    
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiMessageList> = [:]
    var dataSourceOrder: Array<String> = []
    
    @IBOutlet weak var ChatTableView: UITableView!
    
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
        let requestCahtFirstModel = CahtFirstModel();
        requestCahtFirstModel.delegate = self as! CahtFirstModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_MESSAGE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String
        
        query["user_id"] = matchness_user_id
        query["status"] = "0"
        //リクエスト実行
        if( !requestCahtFirstModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //タブバー表示
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //タブバー表示
        tabBarController?.tabBar.isHidden = false
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var message = self.dataSource[String(indexPath.row)]
        
        
        let cell = ChatTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        cell.ChatName.text = message?.name
        cell.ChatDate.text = message?.created_at
        cell.ChatMessage.text = message?.last_message
        var number = Int.random(in: 1 ... 18)
        cell.ChatImage.image = UIImage(named: "\(number)")
        cell.tag = Int(message!.room_code!)!
        cell.ChatImage.contentMode = .scaleAspectFill
        cell.ChatImage.clipsToBounds = true
        cell.ChatImage.layer.cornerRadius =  cell.ChatImage.frame.height / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let setteing_status:[String:Any] = ["status":"2", "indexPath":indexPath]
        self.performSegue(withIdentifier: "toMessage", sender: setteing_status)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessage" {
            let vc = segue.destination as! MessageViewController
            //            vc.delegate = self
            //            vc.setteing_status = sender as! [String:Any]
        }
    }
    
    
    
}


extension CahtFirstViewController : CahtFirstModelDelegate {
    
    func onStart(model: CahtFirstModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: CahtFirstModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        print(self.dataSourceOrder)
        print("耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳")
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
        var count: Int = 0;
        print("ががががががががが")
        print(self.dataSource)
        print(self.dataSourceOrder)
        
        ChatTableView.reloadData()
    }
    func onFailed(model: CahtFirstModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }
}

