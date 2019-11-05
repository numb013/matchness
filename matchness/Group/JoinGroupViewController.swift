//
//  JoinGroupViewController.swift
//  matchness
//
//  Created by user on 2019/06/03.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class JoinGroupViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    

    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiGroupList> = [:]
    var dataSourceOrder: Array<String> = []
    
    var progress = [Int:Int]()
    
    @IBOutlet weak var JoinGroup: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JoinGroup.delegate = self
        JoinGroup.dataSource = self
        self.JoinGroup.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")

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
        query["status"] = "1"
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
        print(JoinGroup.contentSize.height - self.JoinGroup.bounds.size.height)
        
        if (!self.isLoading && scrollView.contentOffset.y  < -67.5) {
            self.isLoading = true
            self.page_no = "1"
            self.dataSourceOrder = []
            var dataSource: Dictionary<String, ApiGroupList> = [:]
            print("更新")
            apiRequest()
        }
        
        if (!self.isLoading && scrollView.contentOffset.y  >= JoinGroup.contentSize.height - self.JoinGroup.bounds.size.height) {
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

        var joinGroup = self.dataSource[String(indexPath.row)]
        let cell = JoinGroup.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell

        cell.titel.text = "タイトル : " + joinGroup!.title!
        cell.period.text = "開催期間 : " + ApiConfig.EVENT_PERIOD_LIST[(joinGroup!.event_period)!] + "日"
        cell.joinNumber.text = "参加人数 : " +  ApiConfig.EVENT_PEPLE_LIST[(joinGroup?.event_peple)!] + "人"
        cell.startType.text = "開始 : " +  ApiConfig.EVENT_START_TYPE[(joinGroup?.start_type)!]
        cell.presentPoint.text = "参加人数 : " +  ApiConfig.EVENT_PRESENT_POINT[(joinGroup?.present_point)!] + "point"

        var number = Int.random(in: 1 ... 18)
        cell.joinButton.setTitle("参加中", for: .normal)
        cell.joinButton.layer.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0).cgColor
        cell.joinButton.layer.cornerRadius = 5.0 //丸みを数値で変更できます
        cell.tag = (joinGroup?.id!)!


print("プログレスプログレスプログレス")
print(joinGroup)
        self.progress[joinGroup!.id!] = joinGroup!.progress_day!
        print(self.progress)
        cell.groupTestImage.image = UIImage(named: "\(number)")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("イベントイベントイベントイベントイベント")
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath)
        let group_id = selectedCell?.tag ?? 0

        print(self.progress)
        var progress_day:Int = self.progress[group_id]!
        let group_param:[String:Any] = ["group_id":String(group_id), "progress_day": progress_day]

        print(group_param)
        self.performSegue(withIdentifier: "toGroupEvent", sender: group_param)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GroupEventViewController
        vc.group_param = sender as! [String : Any]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension JoinGroupViewController : GroupModelDelegate {
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
        
        JoinGroup.reloadData()
    }
    func onFailed(model: GroupModel) {
        print("こちら/usersearch/UserSearchViewのonFailed")
    }
    
}
