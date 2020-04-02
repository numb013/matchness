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
    var errorData: Dictionary<String, ApiErrorAlert> = [:]

    @IBOutlet weak var titleLabel: UILabel!
    var cellCount: Int = 0
    var status:Int = 0
    let dateFormater = DateFormatter()
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;
    var isLoading:Bool = false
    var page_no = "1"
    var isUpdate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        print("JIJIJIJIJIJIJIJ")

       if status == 0 {
            titleLabel.text = "足あと"
        } else if status == 1 {
            titleLabel.text = "もらったいいね"
        } else if status == 3 {
            titleLabel.text = "お気に入り"
        } else if status == 4 {
            titleLabel.text = "ぶ"
        } else if status == 6 {
            titleLabel.text = "ブロック"
        }

        self.tableView.register(UINib(nibName: "MultipleTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleTableViewCell")
        apiRequest()
        // Do any additional setup after loading the view.
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

print("ああああああああああああああああああああ")
print(status)
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();

        if status == 0 {
            requestUrl = ApiConfig.REQUEST_URL_API_USER_FOOTPRINT;
            userDefaults.set(0, forKey: "footprint")
        }
        if status == 1 {
            requestUrl = ApiConfig.REQUEST_URL_API_SEECT_GET_LIKE;
            userDefaults.set(0, forKey: "like")
        }
        if status == 3 {
            requestUrl = ApiConfig.REQUEST_URL_API_SELECT_FAVORITE_BLOCK;
            query["status"] = "1"
        }
        if status == 6 {
            requestUrl = ApiConfig.REQUEST_URL_API_SELECT_FAVORITE_BLOCK;
            query["status"] = "2"
        }
        var array1: [String] = []
        var array2: Dictionary<String, ApiMultipleUser> = [:]

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
        var multiple = self.dataSource[String(indexPath.row)]
        cell.userName.text = multiple?.name!
        cell.userWork.text = ApiConfig.PREFECTURE_LIST[multiple?.prefecture_id ?? 0]

        if (multiple?.profile_image == nil) {
            cell.userImage.image = UIImage(named: "no_image")
        } else {
            let profileImageURL = image_url + (multiple?.profile_image!)!
            let url = NSURL(string: profileImageURL);
            let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
            cell.userImage.image = UIImage(data:imageData! as Data)
        }
        
        cell.userImage.isUserInteractionEnabled = true
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        recognizer.targetUserId = multiple?.user_id
        cell.userImage.addGestureRecognizer(recognizer)

        dateFormater.locale = Locale(identifier: "ja_JP")
//        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = dateFormater.date(from: self.dataSource[String(indexPath.row)]!.updated_at!)
        dateFormater.dateFormat = "MM月dd日 HH:mm"
        let date_text = dateFormater.string(from: date ?? Date())
        cell.createTime.text = String(date_text)

        return cell
    }
    
    @objc func onTap(_ sender: MyTapGestureRecognizer) {
        print("!!!!!!!!!")
        var user_id = sender.targetUserId!
//
//        let storyboard: UIStoryboard = self.storyboard!
//        let nextVC = storyboard.instantiateViewController(withIdentifier: "toUserDetail") as! UserDetailViewController
//        nextVC.user_id = user_id
//        nextVC.modalPresentationStyle = .fullScreen
//
//        self.present(nextVC, animated: true, completion: nil)

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()! as! UserDetailViewController
        vc.user_id = user_id
        navigationController?.pushViewController(vc, animated: true)
        
        
        
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
//    multiple.modalPresentationStyle = .fullScreen
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
    func onFinally(model: MultipleModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
    
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

    func onFailed(model: MultipleModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }
    
    func onError(model: MultipleModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }

}


