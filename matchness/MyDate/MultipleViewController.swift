//
//  MultipleViewController.swift
//  matchness
//
//  Created by user on 2019/07/17.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class MultipleViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var dataSource: Dictionary<String, ApiMultipleUser> = [:]
    var dataSourceOrder: Array<String> = []
    var cellCount: Int = 0
    var status:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        self.tableView.register(UINib(nibName: "MultipleTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleTableViewCell")
        apiRequest()
        // Do any additional setup after loading the view.
    }

    var isLoading:Bool = false
    var page_no = "1"
    
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
        
        if (!self.isLoading && scrollView.contentOffset.y  >= tableView.contentSize.height - self.tableView.bounds.size.height) {
            self.isLoading = true
            print("グループ無限スクロール無限スクロール無限スクロール")
            apiRequest()
        }
    }

    func apiRequest() {
        print("ステータス!!!!!!!!")
        print(status)
        
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestMultipleModel = MultipleModel();
        requestMultipleModel.delegate = self as! MultipleModelDelegate;
        //リクエスト先
        var requestUrl: String = ""
        if status == 0 {
            requestUrl = ApiConfig.REQUEST_URL_API_USER_FOOTPRINT;
        }
        if status == 1 {
            requestUrl = ApiConfig.REQUEST_URL_API_MY_FOOTPRINT;
        }
        if status == 3 {
            requestUrl = ApiConfig.REQUEST_URL_API_USER_FOOTPRINT;
        }
        if status == 4 {
            requestUrl = ApiConfig.REQUEST_URL_API_USER_FOOTPRINT;
        }

        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["id"] = userDefaults.object(forKey: "matchness_user_id") as? String
        //リクエスト実行
        if( !requestMultipleModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleTableViewCell") as! MultipleTableViewCell

        cell.userName.text = self.dataSource[String(indexPath.row)]!.name!
        cell.userWork.text = ApiConfig.WORK_LIST[self.dataSource[String(indexPath.row)]?.work ?? 0]
        var number = Int.random(in: 1 ... 18)
        cell.userImage.image = UIImage(named: "\(number)")
        cell.createTime.text = self.dataSource[String(indexPath.row)]!.updated_at!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    
//    @IBAction func toMyDataButton(_ sender: Any) {
//        let storyboard: UIStoryboard = self.storyboard!
////ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
//        let multiple = storyboard.instantiateViewController(withIdentifier: "Mydate")
//        //ここが実際に移動するコードとなります
//        self.present(multiple, animated: false, completion: nil)
//    }

    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MultipleViewController : MultipleModelDelegate {
    
    func onStart(model: MultipleModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }

    func onComplete(model: MultipleModel, count: Int) {
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
        tableView.reloadData()
    }

    func onFailed(model: MultipleModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }
}


