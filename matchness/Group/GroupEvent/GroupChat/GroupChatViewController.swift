//
//  SettingEditViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/08.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class GroupChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var sendButton: UIButton!
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiGroupChatList> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    var page_no = "1"
    var isLoading:Bool = false
    var validate = 0
    var isUpdate:Bool = false

    var group_id:String = ""
    var comment:String = ""
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var tableView: UITableView!
//    var ActivityIndicator: UIActivityIndicatorView!
    var activityIndicatorView = UIActivityIndicatorView()
    var selectRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textFiled.delegate = self
        // Do any additional setup after loading the view.

//        sendButton.isEnabled = false
        self.tableView.register(UINib(nibName: "GroupChatTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupChatTableViewCell")

        //        view.backgroundColor = .lightGray
//        activityIndicatorView.center = view.center
//        activityIndicatorView.style = .whiteLarge
//        activityIndicatorView.color = .purple
//        view.addSubview(activityIndicatorView)

        self.tableView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)

        apiRequest()
    }

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

print("無限無限無限無限無限無限無限")
        print(scrollView.contentOffset.y)
        print(self.isLoading)

        if (!self.isUpdate && scrollView.contentOffset.y  < -67.5) {
            self.isUpdate = true
            print("無限スクロール無限スクロール無限スクロール")
            print(self.isUpdate)
            apiRequest()

        }
        if (!self.isLoading) {
            self.isLoading = true
            self.page_no = "0"
            self.dataSourceOrder = []
            var dataSource: Dictionary<String, ApiUserDate> = [:]
            activityIndicatorView.startAnimating()
            DispatchQueue.global(qos: .default).async {
                // 非同期処理などを実行
                Thread.sleep(forTimeInterval: 5)
                // 非同期処理などが終了したらメインスレッドでアニメーション終了
                DispatchQueue.main.async {
                    // アニメーション終了
                    self.activityIndicatorView.stopAnimating()
                }
            }
            apiRequest()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //タブバー表示
//        tabBarController?.tabBar.isHidden = false
        self.isLoading = true
        self.page_no = "1"
        self.dataSourceOrder = []
        var dataSource: Dictionary<String, ApiUserDate> = [:]
        var errorData: Dictionary<String, ApiErrorAlert> = [:]

        activityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .default).async {
            // 非同期処理などを実行
            Thread.sleep(forTimeInterval: 5)
            // 非同期処理などが終了したらメインスレッドでアニメーション終了
            DispatchQueue.main.async {
                // アニメーション終了
                self.activityIndicatorView.stopAnimating()
            }
        }
        apiRequest()
    }
    
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(self.isLoading)
//        print("EEWEWEEEEEEEEEEEEEEEEEE")
//        print(scrollView.contentOffset.y)
//        print(tableView.contentSize.height - self.tableView.bounds.size.height)
//
//        if (!self.isLoading && scrollView.contentOffset.y  < -67.5) {
//            self.isLoading = true
//            self.page_no = "1"
//            self.dataSourceOrder = []
//            var dataSource: Dictionary<String, ApiGroupChatList> = [:]
//            print("更新")
//            activityIndicatorView.startAnimating()
//            DispatchQueue.global(qos: .default).async {
//                // 非同期処理などを実行
//                Thread.sleep(forTimeInterval: 5)
//                // 非同期処理などが終了したらメインスレッドでアニメーション終了
//                DispatchQueue.main.async {
//                    // アニメーション終了
////                    self.activityIndicatorView.stopAnimating()
//                    self.activityIndicatorView.stopAnimating()
//                }
//            }
//            apiRequest()
//        }
//
//        if (!self.isLoading && scrollView.contentOffset.y + 2  >= tableView.contentSize.height - self.tableView.bounds.size.height) {
//            self.isLoading = true
//            print("無限スクロール無限スクロール無限スクロール")
//            apiRequest()
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()  //Notification発行
    }
    
    /// Notification発行
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    /// キーボードが表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.view.transform = transform
        }
        print("keyboardWillShowを実行")
    }

    /// キーボードが降りたら画面を戻す
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
        print("keyboardWillHideを実行")
    }
    

    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestGroupChatModel = GroupChatModel();
        requestGroupChatModel.delegate = self as! GroupChatModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_GROUP_CHAT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["group_id"] = group_id
        //リクエスト実行
        if( !requestGroupChatModel.requestApi(url: requestUrl, addQuery: query) ){
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.tintColor = #colorLiteral(red: 0.9499146342, green: 0.9500735402, blue: 0.9498936534, alpha: 1)
        header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var myData = self.dataSource[String(indexPath.row)]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChatTableViewCell") as! GroupChatTableViewCell
        cell.comment?.text = myData?.comment
        cell.name?.text = myData?.name
        cell.created_at?.text = myData?.created_at
        cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)

        cell.comment?.adjustsFontSizeToFitWidth = true
        cell.comment?.numberOfLines = 0

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 200 //セルの高さ
        return UITableView.automaticDimension //自動設定
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var tag = textField.tag
        if tag == 0 {
            self.comment = textField.text!
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var tag = textField.tag
        if tag == 0 {
            self.comment = textField.text!
        }
        textField.resignFirstResponder()
        return
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        self.comment = textField.text!
        textField.resignFirstResponder()
        sendButton.isEnabled = true
        return true
    }

        func validator(){
    //        ActivityIndicator.stopAnimating()
            self.activityIndicatorView.stopAnimating()
            // アラート作成
            let alert = UIAlertController(title: "入力エラー", message: "メッセージを入力してください。", preferredStyle: .alert)
            // アラート表示
            self.present(alert, animated: true, completion: {
                // アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    alert.dismiss(animated: true, completion: nil)
                    self.validate = 0
                })
            })
        }
        
    
    
    @IBAction func sendGroupChat(_ sender: Any) {
        textFiled.endEditing(true)
        sendButton.isEnabled = false
        let requestGroupChatModel = GroupChatModel();
        requestGroupChatModel.delegate = self as! GroupChatModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_GROUP_CHAT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["group_id"] = group_id
        query["comment"] = self.comment

        if (query["comment"] == "") {
            self.validate = 1
            validator()
        }

        if (self.validate == 0) {
            print("バリデート")
            print(self.validate)
            //リクエスト実行
            if( !requestGroupChatModel.requestApi(url: requestUrl, addQuery: query) ){
            }
        }

    }
}


extension GroupChatViewController : GroupChatModelDelegate {
    func onFinally(model: GroupChatModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
    func onStart(model: GroupChatModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onComplete(model: GroupChatModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;

        print("カウントカウントカウントカウントカウント")
        print(self.cellCount)
        print(dataSourceOrder.count)
        print(self.page_no)

        if (Int(self.page_no)! > 3 && self.cellCount == dataSourceOrder.count) {
            self.isLoading = false
            self.isUpdate = true
        } else {
            self.cellCount = dataSourceOrder.count;
            self.page_no = String(model.page);
            print(self.page_no)
            var count: Int = 0;
            self.isLoading = false
        }
        self.activityIndicatorView.stopAnimating()
        
        
        
        
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
        textFiled.text = ""
        self.comment = ""

        tableView.reloadData()

    }
    func onFailed(model: GroupChatModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }

    
    func onError(model: GroupChatModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
//        ActivityIndicator.stopAnimating()
        self.activityIndicatorView.stopAnimating()
    }

}
