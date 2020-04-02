//
//  SettingEditViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/08.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    let dateFormater = DateFormatter()
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiNoticeList> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    var isLoading:Bool = false
    var isUpdate = false
    var page_no = "1"
    var notice_id: Int = 0
    var selectRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeTableViewCell")


        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableView.automaticDimension
        
        userDefaults.set(0, forKey: "notice")
        apiRequest()
    }


    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(self.isLoading)
        print("EEWEWEEEEEEEEEEEEEEEEEE")
        print(scrollView.contentOffset.y)
        print(tableView.contentSize.height - self.tableView.bounds.size.height)
        
        if (!self.isLoading && scrollView.contentOffset.y  < -67.5) {
            self.isLoading = true
            self.page_no = "1"
            self.dataSourceOrder = []
            var dataSource: Dictionary<String, ApiGroupList> = [:]
            print("更新")
            apiRequest()
        }
        if (!self.isUpdate) {
            if (!self.isLoading && scrollView.contentOffset.y  >= tableView.contentSize.height - self.tableView.bounds.size.height) {
                self.isLoading = true
                print("グループ無限スクロール無限スクロール無限スクロール")
                apiRequest()
            }
        }
    }

    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestNoticeModel = NoticeModel();
        requestNoticeModel.delegate = self as! NoticeModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_NOTICE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var api_key = userDefaults.object(forKey: "api_token") as? String
        query["api_token"] = api_key

        requestNoticeModel.array1 = self.dataSourceOrder
        requestNoticeModel.array2 = self.dataSource
        //リクエスト実行
        if( !requestNoticeModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        print("マイデータ")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("こいいいいいい")
        print(self.dataSource)
        var notice = self.dataSource[String(indexPath.row)]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell") as! NoticeTableViewCell
//        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator


        dateFormater.locale = Locale(identifier: "ja_JP")
//            dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = dateFormater.date(from: (notice?.created_at!)!)
        dateFormater.dateFormat = "yyyy年MM月dd日"
        let date_text = dateFormater.string(from: date ?? Date())
        cell.dateTime?.text = String(date_text)

        cell.noticeText?.text = notice?.title
        cell.tag = notice!.notice_id!

        
        cell.noticeText?.adjustsFontSizeToFitWidth = true
        cell.noticeText?.numberOfLines = 0
        
        print("お知らせID")
        print(notice!.notice_id!)

        //cell.detail?.text = ApiConfig.BLOOD_LIST[myData?.blood_type ?? 2]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        self.notice_id = selectedCell?.tag ?? 0
        self.performSegue(withIdentifier: "toNoticeDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNoticeDetail" {
            let nextVC = segue.destination as! NoticeDetailViewController
            nextVC.notice_id = self.notice_id
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 200 //セルの高さ
        return UITableView.automaticDimension //自動設定
    }
    
    @IBAction func backNoticeView(segue:UIStoryboardSegue){
        NSLog("PlaninputViewController#backFromPlaninputView")
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


extension NoticeViewController : NoticeModelDelegate {
    func onFinally(model: NoticeModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
    
    func onStart(model: NoticeModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onComplete(model: NoticeModel, count: Int) {
        print("着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        
        print(self.dataSourceOrder)
        print("耳耳耳意味耳みm")
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
        if (Int(self.page_no)! > 3 && self.cellCount == dataSourceOrder.count) {
            self.isLoading = false
            self.isUpdate = true
        } else {
            self.page_no = String(model.page);

            print("グループページページページページ")
            print(self.page_no)

            var count: Int = 0;
            self.isLoading = false
        }
        tableView.reloadData()
    }

    func onFailed(model: NoticeModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }
    
    func onError(model: NoticeModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }

}
