//
//  PointHistoryViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/09/22.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class PointHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    //ApiPintHistoryList
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiPintHistoryList> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    let userDefaults = UserDefaults.standard
    var pont: Int = 0
    var notice_id: Int = 0
    var selectRow = 0
    var ActivityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var myPoint: UILabel!    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib(nibName: "PointHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "PointHistoryTableViewCell")
        
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestPointHistoryModel = PointHistoryModel();
        requestPointHistoryModel.delegate = self as! PointHistoryModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_POINT_PURCHASE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var api_key = userDefaults.object(forKey: "api_token") as? String
        query["api_token"] = api_key
        //リクエスト実行
        if( !requestPointHistoryModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        print("マイデータ")
    }

    func returnView() {
        var detail = self.dataSource["0"]
        self.pont = self.userDefaults.object(forKey: "point") as! Int
        myPoint.text = String(self.pont)
    }

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "設定"
    //    }
    
    //    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
    //        header.tintColor = #colorLiteral(red: 0.9499146342, green: 0.9500735402, blue: 0.9498936534, alpha: 1)
    //        header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    //        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    //    }
    
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("こいいいいいい")
        print(self.dataSource)
        var notice = self.dataSource[String(indexPath.row)]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointHistoryTableViewCell") as! PointHistoryTableViewCell
//        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.created?.text = notice?.created_at
        cell.point?.text = notice?.point
        if (notice?.status == "0") {
            cell.point?.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            cell.p_text.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            cell.title?.text = "ポイント交換"
        }
        if (notice?.status == "1") {
            cell.point?.textColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
            cell.p_text.textColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
            cell.title?.text = "ポイント購入"
        }
        if (notice?.status == "2") {
            cell.point?.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.p_text.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.title?.text = "いいね"
        }
        if (notice?.status == "3") {
            cell.point?.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.p_text.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.title?.text = "メッセージ"
        }
        if (notice?.status == "4") {
            cell.point?.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.p_text.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.title?.text = "グループ作成"
        }

        //cell.detail?.text = ApiConfig.BLOOD_LIST[myData?.blood_type ?? 2]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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

extension PointHistoryViewController : PointHistoryModelDelegate {
    func onFinally(model: PointHistoryModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
    
    func onStart(model: PointHistoryModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onComplete(model: PointHistoryModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        
        print(self.dataSourceOrder)
        print("UserDetail耳耳耳意味耳みm")
        print(self.dataSource)
        
        
        //一つもなかったら
        //        if( dataSourceOrder.isEmpty ){
        //            return;
        //        }
        
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
        //        self.cellCount = 10;
        
        
        
        //
        var count: Int = 0;
        //        for(key, code) in dataSourceOrder.enumerated() {
        //            count+=1;
        //            if let jenre: ApiUserDateParam = dataSource[code] {
        //                //取得したデータを元にコレクションを再構築＆更新
        //                mapMenuView.addTagGroup(model: model, jenre: jenre);
        //            }
        //        }
        returnView()
        tableView.reloadData()
    }
    func onFailed(model: PointHistoryModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }
    
    
    func onError(model: PointHistoryModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }


}
