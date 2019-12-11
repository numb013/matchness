//
//  GroupEventAddViewController.swift
//  matchness
//
//  Created by user on 2019/07/17.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class GroupEventAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!

    @IBOutlet weak var datePickerButton: NSLayoutConstraint!

    var setDateviewTime = ""
    var vi = UIView()
    var isDate = Date()
    var selectPicker: Int = 0
    var selectPickerItem: Int = 0
    var pcker_list: [String] = []
    var selectRow = 0
    var title_text = ""
    var event_peple:String = "0"
    var event_period:String = "0"
    var present_point:String = "0"
    var event_type:String = "0"
    var start_type:String = "0"
    
    
    var dataSource: Dictionary<String, ApiGroupList> = [:]
    var dataSourceOrder: Array<String> = []
    var cellCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate   = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        self.tableView.register(UINib(nibName: "ProfileEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEditTableViewCell")
        
        self.tableView.register(UINib(nibName: "TextFiledTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFiledTableViewCell")
        
        // datePickerの設定
        datePickerView.date = isDate
        datePickerView.datePickerMode = .date
        datePickerView.locale = Locale(identifier: "ja")
        datePickerView.addTarget(self, action: #selector(setText), for: .valueChanged)
        datePickerView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "詳細"
    }
    
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
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "profileCell")
        print("AAAAAAAAAA")
        print(indexPath)
        print(indexPath.section)
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFiledTableViewCell") as! TextFiledTableViewCell
                cell.title?.text = "タイトル"
                cell.textFiled.delegate = self
                cell.textFiled.tag = 0
                print("ニックネームニックネームニックネームニックネーム")
                cell.textFiled?.text = self.title_text
                return cell
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "人数"
                cell.detail?.text = ApiConfig.EVENT_PEPLE_LIST[Int(self.event_peple) ?? 0] + "人"
                return cell
            }
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "期間"
                cell.detail?.text = ApiConfig.EVENT_PERIOD_LIST[Int(self.event_period) ?? 0] + "日"
                return cell
            }
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "プレゼントポイント"
                cell.detail?.text = ApiConfig.EVENT_PRESENT_POINT[Int(self.present_point) ?? 0] + "ポイント"
                return cell
            }
            
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "男女の割合"
                cell.detail?.text = ApiConfig.EVENT_TYPE_LIST[Int(self.event_type) ?? 0]
                return cell
            }
            if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "開始タイプ"
                cell.detail?.text = ApiConfig.EVENT_START_TYPE[Int(self.start_type) ?? 0]
                return cell
            }
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissPicker()
        dismissDatePicker()
        if indexPath.row == 0 {
            self.selectPicker = 0
        }
        if indexPath.row == 1 {
            self.selectPicker = 1
            self.pcker_list = ApiConfig.EVENT_PEPLE_LIST
            self.selectRow = Int(self.event_peple) ?? 0
        }
        if indexPath.row == 2 {
            self.selectPicker = 2
            self.pcker_list = ApiConfig.EVENT_PERIOD_LIST
            self.selectRow = Int(self.event_period) ?? 0
        }
        if indexPath.row == 3 {
            self.selectPicker = 3
            self.pcker_list = ApiConfig.EVENT_PRESENT_POINT
            self.selectRow = Int(self.present_point) ?? 0
        }
        if indexPath.row == 4 {
            self.selectPicker = 4
            self.pcker_list = ApiConfig.EVENT_TYPE_LIST
            self.selectRow = Int(self.event_type) ?? 0
        }
        if indexPath.row == 5 {
            self.selectPicker = 5
            self.pcker_list = ApiConfig.EVENT_START_TYPE
            self.selectRow = Int(self.start_type) ?? 0
        }
        
        pickerView.selectRow(self.selectRow, inComponent: 0, animated: false)
        PickerPush()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
        @IBAction func pickerSelectButton(_ sender: Any) {
               print("bbbb")
                print("セレクトピッカー")
                print(self.selectPicker)
                if self.selectPicker == 0 {
        
                }
                if self.selectPicker == 1 {
                    self.event_peple = String(self.selectPickerItem)
                }
                if self.selectPicker == 2 {
                    self.event_period = String(self.selectPickerItem)
                }
                if self.selectPicker == 3 {
                    self.present_point = String(self.selectPickerItem)
                }
                if self.selectPicker == 4 {
                    self.event_type = String(self.selectPickerItem)
                }
                if self.selectPicker == 5 {
                    self.start_type = String(self.selectPickerItem)
                }
                dismissPicker()
                tableView.reloadData()
                self.vi.removeFromSuperview()
        }

        @IBAction func pickerCloseButton(_ sender: Any) {
            dismissPicker()
        }
        
        func PickerPush(){
            print("ピッカーーーーーーーー")
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.5,animations: {
    //            self.datePickerView.date = self.setDay
                self.pickerBottom.constant = -280
                self.pickerView.updateConstraints()
                self.tableView.updateConstraints()
                self.view.layoutIfNeeded()
            })
        }
        
        func dismissPicker(){
            UIView.animate(withDuration: 0.5,animations: {
                self.pickerBottom.constant = 300
                self.pickerView.updateConstraints()
                self.tableView.updateConstraints()
                self.view.layoutIfNeeded()
            })
        }
        
        @IBAction func dateSelectButton(_ sender: Any) {
            print("セットセットセットセット")
            print(self.setDateviewTime)
            self.vi.removeFromSuperview()
            tableView.reloadData()
            dismissDatePicker()
        }
        @IBAction func dateCloseButton(_ sender: Any) {
            dismissDatePicker()
        }

        func datePickerPush(){
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.5,animations: {
                self.datePickerButton.constant = -280
                self.datePickerView.updateConstraints()
                self.tableView.updateConstraints()
                self.view.layoutIfNeeded()
            })
        }
        
        func dismissDatePicker(){
            UIView.animate(withDuration: 0.5,animations: {
                self.datePickerButton.constant = 300
                self.datePickerView.updateConstraints()
                self.tableView.updateConstraints()
                self.view.layoutIfNeeded()
            })
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            print("p1p1p1p1p")
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            print("p2p2p2p2p2")
            return self.pcker_list.count
        }
        // UIPickerViewに表示する配列
        func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
            print("p3p3p3p3p3")
            print(self.selectPicker)
            if (self.selectPicker == 1) {
                return self.pcker_list[row] + "人"
            }
            if (self.selectPicker == 2) {
                return self.pcker_list[row] + "日"
            }
            if (self.selectPicker == 3) {
                return self.pcker_list[row] + "ポイント"
            }
            return self.pcker_list[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.selectPickerItem = row
            print("選択ピッカー選択ピッカー選択ピッカー")
        }

    // datePickerの日付けをtextFieldのtextに反映させる
    @objc private func setText() {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.setDateviewTime = dateFormater.string(from: datePickerView.date)
//        self.dataSource["0"]?.birthday = self.setDateviewTime
        print("時間時間時間")
        print(datePickerView.date)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("テキスト１")
        var tag = textField.tag
        print(textField.text!)
        if tag == 0 {
            self.title_text = textField.text!
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var tag = textField.tag
        print(textField.text!)
        if tag == 0 {
            self.title_text = textField.text!
        }
        textField.resignFirstResponder()
        return
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        self.title_text = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addButton(_ sender: Any) {
        print("ハッスルクエスト")
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestGroupEventAddModel = GroupEventAddModel();
        requestGroupEventAddModel.delegate = self as! GroupEventAddModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_GROUP;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        
        query["master_id"] = self.userDefaults.object(forKey: "matchness_user_id") as? String
        query["title"] = self.title_text
        query["event_peple"] = self.event_peple
        query["start_type"] = self.start_type
        query["present_point"] = self.present_point
        query["event_type"] = self.event_type
        query["event_period"] = self.event_period
        
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String
        
        
        
        print(userDefaults.object(forKey: "matchness_user_id") as? String)
        print(matchness_user_id)
        print(query)
        
        
        
        //リクエスト実行
        if( !requestGroupEventAddModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
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



extension GroupEventAddViewController : GroupEventAddModelDelegate {
    
    func onStart(model: GroupEventAddModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: GroupEventAddModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        
        print(self.dataSourceOrder)
        print("UserDetail耳耳耳意味耳みm")
        
        
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
        self.dismiss(animated: true, completion: nil)
        //        self.performSegue(withIdentifier: "toGroupTop", sender: nil)
    }
    func onFailed(model: GroupEventAddModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }
}

