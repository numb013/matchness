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
    var group_id:String = ""
    var comment:String = ""
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var selectRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textFiled.delegate = self
        // Do any additional setup after loading the view.
        
//        sendButton.isEnabled = false
        self.tableView.register(UINib(nibName: "GroupChatTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupChatTableViewCell")
        apiRequest()
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
        print("こいいいいいい")
        print(self.dataSource)
        var myData = self.dataSource[String(indexPath.row)]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChatTableViewCell") as! GroupChatTableViewCell
        cell.comment?.text = myData?.comment
        cell.name?.text = myData?.name
        cell.created_at?.text = myData?.created_at
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("テキスト１")
        var tag = textField.tag
        print(textField.text!)
        if tag == 0 {
            self.comment = textField.text!
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var tag = textField.tag
        print("テキスト2")
        print(textField.text!)

        print(textField.text!)
        if tag == 0 {
            self.comment = textField.text!
        }
        textField.resignFirstResponder()
        return
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("テキスト3")
        print(textField.text!)

        // キーボードを閉じる
        self.comment = textField.text!
        textField.resignFirstResponder()
        sendButton.isEnabled = true
        return true
    }

    @IBAction func sendGroupChat(_ sender: Any) {

        textFiled.endEditing(true)
        sendButton.isEnabled = false
print("コメントコメントコメントコメントコメントコメント")
        print(self.comment)

        let requestGroupChatModel = GroupChatModel();
        requestGroupChatModel.delegate = self as! GroupChatModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_GROUP_CHAT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["group_id"] = group_id
        query["comment"] = self.comment
        //リクエスト実行
        if( !requestGroupChatModel.requestApi(url: requestUrl, addQuery: query) ){
        }
    }
}


extension GroupChatViewController : GroupChatModelDelegate {
    func onStart(model: GroupChatModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onComplete(model: GroupChatModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;

        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
        var count: Int = 0;
        textFiled.text = ""
//        sendButton.isEnabled = false
        self.comment = ""
        tableView.reloadData()
    }
    func onFailed(model: GroupChatModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }
    
}
