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
        
        // Do any additional setup after loading the view.
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
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        
        print(self.dataSourceOrder)
        print("UserDetail耳耳耳意味耳みm")
        print(self.dataSource)
        print(self.dataSource["0"]?.name)
        print(self.dataSource["0"]?.work)
        
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
        
        tableView.reloadData()
    }
    func onFailed(model: MultipleModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }
}


