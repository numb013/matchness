//
//  WaitGroupViewController.swift
//  matchness
//
//  Created by user on 2019/06/03.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class WaitGroupViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var WaitGroup: UITableView!
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiGroupList> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    
    var isLoading:Bool = false
    var isUpdate = false
    var page_no = "1"
    var group_id: Int = 0
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;

    var group_freeword = ""
    var event_peple: String? = nil
    var event_period: String? = nil
    var present_point: String? = nil
    var master_flag: String? = nil
    var request_flag: String? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        WaitGroup.delegate = self
        WaitGroup.dataSource = self
        self.WaitGroup.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        apiRequest()
    }

    override func viewDidAppear(_ animated: Bool) {
        print("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY")
        self.isLoading = true
        super.viewDidAppear(animated)
        //タブバー表示
        tabBarController?.tabBar.isHidden = false
    }


    override func viewWillAppear(_ animated: Bool) {
        print("BBBBBBBBBBBBBBBBBBBBBBBBBBBB")
        self.isLoading = true
        self.page_no = "1"
        self.dataSourceOrder = []
        var dataSource: Dictionary<String, ApiGroupList> = [:]
        super.viewWillAppear(animated)
        apiRequest()
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("QQQQQQ更新更新更新更新更新更新更新更新更新更新更新")
        print(self.isLoading)
//        print("EEWEWEEEEEEEEEEEEEEEEEE")
//        print(scrollView.contentOffset.y)
//        print(WaitGroup.contentSize.height - self.WaitGroup.bounds.size.height)
//
        if (!self.isLoading && scrollView.contentOffset.y  < -67.5) {
            self.isLoading = true
            self.page_no = "1"
            self.dataSourceOrder = []
            var dataSource: Dictionary<String, ApiGroupList> = [:]
            print("更新更新更新更新更新更新更新更新更新更新更新")
            apiRequest()
        }
        
        if (!self.isUpdate) {
            if (!self.isLoading && scrollView.contentOffset.y  >= WaitGroup.contentSize.height - self.WaitGroup.bounds.size.height) {
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
        let requestGroupModel = GroupModel();
        requestGroupModel.delegate = self as! GroupModelDelegate;
        //リクエスト先
//        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_GROUP;
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SEARCH_GROUP;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["status"] = "0"
        query["page"] = self.page_no

        
        query["freeword"] = userDefaults.object(forKey: "searchGroupFreeword") as? String
        query["event_peple"] = userDefaults.object(forKey: "searchEventPeple") as? String
        query["event_period"] = userDefaults.object(forKey: "searchEventPeriod") as? String
        query["present_point"] = userDefaults.object(forKey: "searchPresentPoint") as? String
        query["master_flag"] = userDefaults.object(forKey: "searchMasterFlag") as? String
        query["request_flag"] = userDefaults.object(forKey: "searchRequestFlag") as? String
        
        
        
        requestGroupModel.array1 = self.dataSourceOrder
        requestGroupModel.array2 = self.dataSource

print(self.dataSourceOrder)
print(requestGroupModel.array1)
        
        
        print("リクエスト実行")
        print(query)
        //リクエスト実行
        if( !requestGroupModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var waitGroup = self.dataSource[String(indexPath.row)]
        print("募集募集募集募集募集募集募集募集募集募集募集")
        print(self.dataSource)
        let cell = WaitGroup.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell

        cell.titel.text = "タイトル : " + waitGroup!.title!
        cell.period.text = "開催期間 : " + ApiConfig.EVENT_PERIOD_LIST[(waitGroup!.event_period)!] + "日"
        cell.joinNumber.text = "参加人数 : " +  ApiConfig.EVENT_PEPLE_LIST[(waitGroup?.event_peple)!] + "人"
//        cell.startType.text = "開始 : " +  (waitGroup?.event_start!)!
        cell.presentPoint.text = "賞金 : " +  ApiConfig.EVENT_PRESENT_POINT[(waitGroup?.present_point)!] + "P"

        cell.groupFlag.image = UIImage(named: "new3")

        
        var number_button = waitGroup?.request_status

        if ((waitGroup?.master_group) != 0) {
            cell.joinButton.setTitle("主催グループ", for: .normal)
            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            recognizer.targetString = "3"
            recognizer.targetGroupId = waitGroup!.id
            cell.joinButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
            cell.joinButton.addGestureRecognizer(recognizer)
        } else {
            if (number_button == 1) {
                cell.joinButton.setTitle("参加希望中", for: .normal)
                var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
                recognizer.targetString = "1"
                recognizer.targetGroupId = waitGroup!.id
                cell.joinButton.layer.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                cell.joinButton.addGestureRecognizer(recognizer)
            } else if (number_button == 0) {
                cell.joinButton.setTitle("募集中", for: .normal)
                var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
                recognizer.targetString = "0"
                recognizer.targetGroupId = waitGroup!.id
                cell.joinButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.194529444, blue: 0.5957843065, alpha: 1)
                cell.joinButton.addGestureRecognizer(recognizer)
            }
        }

        //cell.joinButton.layer.backgroundColor = UIColor(red: 254/255, green: 0, blue: 124/255, alpha: 1).cgColor
        cell.joinButton.layer.cornerRadius = 5.0 //丸みを数値で変更できます

        if (waitGroup?.profile_image == nil) {
            cell.groupTestImage.image = UIImage(named: "no_image")
        } else {
            let profileImageURL = image_url + (waitGroup?.profile_image!)!
            let url = NSURL(string: profileImageURL);
            let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
            cell.groupTestImage.image = UIImage(data:imageData! as Data)
        }

        cell.groupTestImage.isUserInteractionEnabled = true
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage(_:)))
        recognizer.targetUserId = waitGroup?.master_id
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
    
    
    @objc func onTap(_ sender: MyTapGestureRecognizer) {
        print("タップタナンバー")
        self.group_id = sender.targetGroupId!
        var tap_number = sender.targetString!
        if (tap_number == "3") {
            let storyboard: UIStoryboard = self.storyboard!
            let next = storyboard.instantiateViewController(withIdentifier: "PreferredGroupList") as! PreferredGroupListViewController
            next.modalPresentationStyle = .fullScreen
            next.group_id = group_id
            //ここが実際に移動するコードとなります
            self.present(next, animated: false, completion: nil)

        } else if (tap_number == "1"){
            let alertController:UIAlertController =
                UIAlertController(title:"キャンセルする",message: "本当にキャンセルしますか？",preferredStyle: .alert)
            // Default のaction
            let defaultAction:UIAlertAction =
                UIAlertAction(title: "キャンセルする",style: .destructive,handler:{
                    (action:UIAlertAction!) -> Void in
                    // 処理
                    print("キャンセルする")
                    self.requestJoin(status:"0")
                })
            // Cancel のaction
            let cancelAction:UIAlertAction =
                UIAlertAction(title: "閉じる",style: .cancel,handler:{
                    (action:UIAlertAction!) -> Void in
                    // 処理
                    print("閉じる")
                })
            // actionを追加
            alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            // UIAlertControllerの起動
            present(alertController, animated: true, completion: nil)
        } else if (tap_number == "0"){
            let alertController:UIAlertController =
                UIAlertController(title:"参加する",message: "本当に参加しますか？",preferredStyle: .alert)
            // Default のaction
            let defaultAction:UIAlertAction =
                UIAlertAction(title: "参加する",style: .destructive,handler:{
                    (action:UIAlertAction!) -> Void in
                    // 処理
                    print("参加する")
                    self.requestJoin(status:"1")
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func requestJoin(status: String) {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestGroupModel = GroupModel();
        requestGroupModel.delegate = self as! GroupModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_REQUEST_GROUP_EVENT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["group_id"] = String(self.group_id)
        query["status"] = status
        query["type"] = "1"
        query["page"] = "1"
        //リクエスト実行
        if( !requestGroupModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
}

extension WaitGroupViewController : GroupModelDelegate {
    func onFinally(model: GroupModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }

    func onStart(model: GroupModel) {
        print("こちら/usersearch/UserSearchViewのonStart")
    }
    func onComplete(model: GroupModel, count: Int) {
        print("着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        

        print("耳耳耳意味耳みm")
        print(self.dataSourceOrder)
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;

        
        print("グループカウントカウントカウントカウントカウント")
        print(self.page_no)
        print(dataSourceOrder.count)
        print(self.cellCount)
        
        
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
        WaitGroup.reloadData()
    }
    func onFailed(model: GroupModel) {
        print("こちら/usersearch/UserSearchViewのonFailed")
    }
    
    func onError(model: GroupModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }
}
