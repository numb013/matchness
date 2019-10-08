//
//  EndGroupViewController.swift
//  matchness
//
//  Created by user on 2019/06/03.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class EndGroupViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    

    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiGroupList> = [:]
    var dataSourceOrder: Array<String> = []
    
    
    @IBOutlet weak var EndGroup: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EndGroup.delegate = self
        EndGroup.dataSource = self
        self.EndGroup.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")

        apiRequest()
    }


    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestGroupModel = GroupModel();
        requestGroupModel.delegate = self as! GroupModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_JOIN_AND_END_GROUP;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String
        
        query["user_id"] = matchness_user_id
        query["status"] = "2"
        //リクエスト実行
        if( !requestGroupModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }

    }
    
    
    var isLoading:Bool = false
    var page_no = "1"
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(self.isLoading)
        print("EEWEWEEEEEEEEEEEEEEEEEE")
        print(scrollView.contentOffset.y)
        print(EndGroup.contentSize.height - self.EndGroup.bounds.size.height)
        
        if (!self.isLoading && scrollView.contentOffset.y  < -67.5) {
            self.isLoading = true
            self.page_no = "1"
            self.dataSourceOrder = []
            var dataSource: Dictionary<String, ApiGroupList> = [:]
            print("更新")
            apiRequest()
        }
        
        if (!self.isLoading && scrollView.contentOffset.y  >= EndGroup.contentSize.height - self.EndGroup.bounds.size.height) {
            self.isLoading = true
            print("グループ無限スクロール無限スクロール無限スクロール")
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

        var eventGroup = self.dataSource[String(indexPath.row)]
        let cell = EndGroup.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        cell.titel.text = "タイトル : " + eventGroup!.title!
        cell.period.text = "開催期間 : " + ApiConfig.EVENT_PERIOD_LIST[(eventGroup!.event_period)!] + "日"
        cell.joinNumber.text = "参加人数 : " +  ApiConfig.EVENT_PEPLE_LIST[(eventGroup?.event_peple)!] + "人"
        cell.startType.text = "開始 : " +  ApiConfig.EVENT_START_TYPE[(eventGroup?.start_type)!]
        cell.presentPoint.text = "参加人数 : " +  ApiConfig.EVENT_PRESENT_POINT[(eventGroup?.present_point)!] + "point"


        var number = Int.random(in: 1 ... 18)
        cell.groupTestImage.image = UIImage(named: "\(number)")
        cell.joinButton.setTitle("参加済", for: .normal)
        cell.joinButton.layer.backgroundColor = UIColor.gray.cgColor
        cell.joinButton.layer.cornerRadius = 5.0 //丸みを数値で変更できます

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}


extension EndGroupViewController : GroupModelDelegate {
    
    func onStart(model: GroupModel) {
        print("こちら/usersearch/UserSearchViewのonStart")
    }
    func onComplete(model: GroupModel, count: Int) {

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
        
        EndGroup.reloadData()
    }
    func onFailed(model: GroupModel) {
        print("こちら/usersearch/UserSearchViewのonFailed")
    }
    
}
