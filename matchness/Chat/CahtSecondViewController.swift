//
//  CahtSecondViewController.swift
//  matchness
//
//  Created by user on 2019/06/02.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CahtSecondViewController: baseViewController, IndicatorInfoProvider, UITableViewDelegate , UITableViewDataSource {
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "マッチング"    
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiMessage> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    let dateFormater = DateFormatter()
    @IBOutlet weak var ChatTableView: UITableView!
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;
    var page_no = "1"
    var isLoading:Bool = false
    var isUpdate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        
        self.ChatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        self.ChatTableView.register(UINib(nibName: "NotDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NotDataTableViewCell")

        // Do any additional setup after loading the view.
        apiRequest()
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
    
    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestCahtFirstModel = CahtFirstModel();
        requestCahtFirstModel.delegate = self as! CahtFirstModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_MATCHE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["status"] = "0"

        var array1: [String] = []
        var array2: Dictionary<String, ApiMessage> = [:]

        //リクエスト実行
        if( !requestCahtFirstModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(self.isLoading)
        print("EEWEWEEEEEEEEEEEEEEEEEE")
        print(scrollView.contentOffset.y)
        print(ChatTableView.contentSize.height - self.ChatTableView.bounds.size.height)
        
        if (!self.isLoading && scrollView.contentOffset.y  < -67.5) {
            self.isLoading = true
            self.page_no = "1"
            self.dataSourceOrder = []
            var dataSource: Dictionary<String, ApiMatcheList> = [:]
            print("更新")
            apiRequest()
        }
        if (!self.isUpdate) {
            if (!self.isLoading && scrollView.contentOffset.y >= ChatTableView.contentSize.height - self.ChatTableView.bounds.size.height) {
                self.isLoading = true
                print("無限スクロール無限スクロール無限スクロール")
                apiRequest()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
        return self.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatTableView.dequeueReusableCell(withIdentifier: "NotDataTableViewCell") as! NotDataTableViewCell

        if self.cellCount != 0 {
            var message = self.dataSource["0"]!.message[indexPath.row]
            let cell = ChatTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
            cell.ChatName.text = message.target_name
            
            dateFormater.locale = Locale(identifier: "ja_JP")
//            dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date = dateFormater.date(from: message.created_at!)
            dateFormater.dateFormat = "yyyy年MM月dd日"
            let date_text = dateFormater.string(from: date ?? Date())
            cell.ChatDate.text = String(date_text)
            cell.ChatMessage.text = "マッチングしました。"

            if (message.profile_image == nil) {
                cell.ChatImage.image = UIImage(named: "no_image")
            } else {
                let profileImageURL = image_url + (message.profile_image!)
                let url = NSURL(string: profileImageURL);
                let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
                cell.ChatImage.image = UIImage(data:imageData! as Data)
            }

            cell.ChatImage.isUserInteractionEnabled = true
            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage(_:)))
            recognizer.targetUserId = self.dataSource["0"]!.id
            cell.ChatImage.addGestureRecognizer(recognizer)
            cell.ChatImage.contentMode = .scaleAspectFill
            cell.ChatImage.clipsToBounds = true
            cell.ChatImage.layer.cornerRadius =  cell.ChatImage.frame.height / 2

            cell.tag = indexPath.row
            return cell
        } else {
            let cell = ChatTableView.dequeueReusableCell(withIdentifier: "NotDataTableViewCell") as! NotDataTableViewCell

        }
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath)
        let message_id = selectedCell?.tag ?? 0
        
        var users = self.dataSource["0"]!.message[message_id]
        let message_users:[String:String] = [
            "room_code":String(users.room_code!),
            "user_id":String(self.dataSource["0"]!.id!),
            "user_name":self.dataSource["0"]!.name!,
            "point":self.dataSource["0"]!.point!,
            "my_image":self.dataSource["0"]!.profile_image!,
            "target_imag":users.profile_image!,
        ]

print("セカンド送信送信送信送信送信送信送信")
print(message_users)

        self.performSegue(withIdentifier: "toMessage", sender: message_users)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessage" {
            let mvc = segue.destination as! MessageViewController
            print("sendersendersendersender")
            print(sender)
            mvc.message_users = sender as! [String : String]
        }
    }

    
    
    
}


extension CahtSecondViewController : CahtFirstModelDelegate {
    func onFinally(model: CahtFirstModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
    
    func onStart(model: CahtFirstModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: CahtFirstModel, count: Int) {
        print("着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        
        print(self.dataSourceOrder)
        print("耳耳耳意味耳みm")
        //cellの件数更新
        self.cellCount = dataSource["0"]!.message.count;
        
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
        ChatTableView.reloadData()
    }
    func onFailed(model: CahtFirstModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }
    
    func onError(model: CahtFirstModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }


}

