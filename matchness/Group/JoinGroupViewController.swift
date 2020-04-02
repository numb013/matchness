//
//  JoinGroupViewController.swift
//  matchness
//
//  Created by user on 2019/06/03.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class JoinGroupViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    var group_id: Int = 0
    var cellCount: Int = 0
    var progress_day:Int = 0
    var dataSource: Dictionary<String, ApiGroupList> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;
    var progress = [Int:Int]()
    
    var isLoading:Bool = false
    var isUpdate:Bool = false
    var page_no = "1"

    @IBOutlet weak var JoinGroup: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        JoinGroup.delegate = self
        JoinGroup.dataSource = self
        self.JoinGroup.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")

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
        query["status"] = "1"
        query["page"] = page_no

        requestGroupModel.array1 = self.dataSourceOrder
        requestGroupModel.array2 = self.dataSource

        //リクエスト実行
        if( !requestGroupModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
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
        if (!self.isUpdate) {
            if (!self.isLoading && scrollView.contentOffset.y  >= JoinGroup.contentSize.height - self.JoinGroup.bounds.size.height) {
                self.isLoading = true
                print("グループ無限スクロール無限スクロール無限スクロール")
                apiRequest()
            }
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
//        self.progress_day = (joinGroup?.progress_day!)!
        let cell = JoinGroup.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        cell.titel.text = "タイトル : " + joinGroup!.title!
        cell.period.text = "開催期間 : " + ApiConfig.EVENT_PERIOD_LIST[(joinGroup!.event_period)!] + "日"
        cell.joinNumber.text = "参加人数 : " +  ApiConfig.EVENT_PEPLE_LIST[(joinGroup?.event_peple)!] + "人"
//        cell.startType.text = "開始 : " +  ApiConfig.EVENT_START_TYPE[(joinGroup?.start_type)!]
        cell.presentPoint.text = "参加人数 : " +  ApiConfig.EVENT_PRESENT_POINT[(joinGroup?.present_point)!] + "point"


        cell.joinButton.setTitle("参加中", for: .normal)
        cell.joinButton.layer.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0).cgColor
        cell.joinButton.layer.cornerRadius = 5.0 //丸みを数値で変更できます
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        recognizer.targetString = String(indexPath.row)
        recognizer.targetGroupId = joinGroup!.id
        cell.joinButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4609032869, blue: 0.2899915278, alpha: 1)
        cell.joinButton.addGestureRecognizer(recognizer)
        

        
print("じゃおいんじゃおいんじゃおいんじゃおいんじゃおいん")
print(joinGroup)
    

        if (joinGroup?.profile_image == nil) {
            cell.groupTestImage.image = UIImage(named: "no_image")
        } else {
            let profileImageURL = image_url + (joinGroup?.profile_image!)!
            let url = NSURL(string: profileImageURL);
            let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
            cell.groupTestImage.image = UIImage(data:imageData! as Data)
        }


        cell.groupTestImage.isUserInteractionEnabled = true
        var recognizer_1 = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage(_:)))
        recognizer_1.targetUserId = joinGroup?.master_id
        cell.groupTestImage.addGestureRecognizer(recognizer_1)

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
        self.group_id = sender.targetGroupId!

        print("イベントイベントイベントイベントイベント")

        let group_param:[String:Any] = [
            "group_id":String(self.group_id),
            "start": self.dataSource[sender.targetString!]?.event_start,
            "end": self.dataSource[sender.targetString!]?.event_end
        ]

        print("111111イベントイベントイベントイベントイベント")
        print(group_param)

        
        
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
        
        JoinGroup.reloadData()
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
