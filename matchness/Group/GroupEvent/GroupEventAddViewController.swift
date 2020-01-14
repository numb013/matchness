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
    var select_pcker_list: [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
    var ActivityIndicator: UIActivityIndicatorView!
    var setDateviewTime = ""
    var vi = UIView()
    var isDate = Date()
    var newDate:NSDate = Date() as NSDate
    var start_date = ""
    var selectPicker: Int = 0
    var selectPickerItem: Int = 0
    var pcker_list: [String] = []
    var selectRow = 0
    var title_text = ""
    var event_peple:Int = 0
    var event_period:Int = 0
    var present_point:Int = 0
    var event_type:Int = 0
    var start_type:Int = 0
    var dataSource: Dictionary<String, ApiGroupList> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]

    var cellCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate   = self
        pickerView.dataSource = self
        
        self.tableView.register(UINib(nibName: "ProfileEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEditTableViewCell")
        
        self.tableView.register(UINib(nibName: "TextFiledTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFiledTableViewCell")
        // datePickerの設定
        datePickerView.date = isDate
        datePickerView.datePickerMode = .date
        datePickerView.locale = Locale(identifier: "ja")
        datePickerView.addTarget(self, action: #selector(setText), for: .valueChanged)
        datePickerView.backgroundColor = UIColor.white

        let date:NSDate = NSDate() //当日の日付を得る
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD" // 日付フォーマットの設定
        var time = date.timeIntervalSince1970
        time += 60*60*24 //２４時間後の時間を加算(６０秒*６０分*２４時間)
        self.newDate = NSDate.init(timeIntervalSince1970:time)
        datePickerView.minimumDate = newDate as Date
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
                cell.detail?.text = ApiConfig.EVENT_PEPLE_LIST[self.event_peple ?? 0] + "人"
                return cell
            }

            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "開始日"

                let dateFormater = DateFormatter()
                dateFormater.locale = Locale(identifier: "ja_JP")
                dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let date = dateFormater.date(from: self.start_date ?? dateFormater.string(from: self.newDate as Date))
                print("タイム444444444")
                print(self.newDate)
                dateFormater.dateFormat = "yyyy年MM月dd日"
                let date_text = dateFormater.string(from: date ?? self.newDate as Date)
                cell.detail?.text = String(date_text)

                return cell
            }

            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "期間"
                cell.detail?.text = ApiConfig.EVENT_PERIOD_LIST[self.event_period ?? 0] + "日"
                return cell
            }


            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "プレゼントポイント"
                cell.detail?.text = ApiConfig.EVENT_PRESENT_POINT[self.present_point ?? 0] + "ポイント"
                return cell
            }
            
            if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "男女の割合"
                cell.detail?.text = ApiConfig.EVENT_TYPE_LIST[self.event_type ?? 0]
                return cell
            }
            if indexPath.row == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "開始タイプ"
                cell.detail?.text = ApiConfig.EVENT_START_TYPE[self.start_type ?? 0]
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
            self.selectRow = self.event_peple ?? 0
        }
        if indexPath.row == 3 {
            self.selectPicker = 3
            self.pcker_list = ApiConfig.EVENT_PERIOD_LIST
            self.selectRow = self.event_period ?? 0
        }
        if indexPath.row == 4 {
            self.selectPicker = 4
            self.pcker_list = ApiConfig.EVENT_PRESENT_POINT
            self.selectRow = self.present_point ?? 0
        }
        if indexPath.row == 5 {
            self.selectPicker = 5
            self.pcker_list = ApiConfig.EVENT_TYPE_LIST
            self.selectRow = self.event_type ?? 0
        }
        if indexPath.row == 6 {
            self.selectPicker = 6
            self.pcker_list = ApiConfig.EVENT_START_TYPE
            self.selectRow = self.start_type ?? 0
        }

        if indexPath.row == 2 {
//            print("タイム33333333333")
//            let dateFormater = DateFormatter()
//            dateFormater.locale = Locale(identifier: "ja_JP")
//            dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
//
//            let date = dateFormater.date(from: self.start_date ?? "2000-01-01 03:12:12 +0000")
//
//
//            datePickerView.date = date!
            print("デートピッカーーーーーーーー")
            datePickerPush()
        } else {
            pickerView.selectRow(self.selectRow, inComponent: 0, animated: false)
            PickerPush()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
        @IBAction func pickerSelectButton(_ sender: Any) {
               print("bbbb")
                print("セレクトピッカーAAAAAA")
                print(self.selectPicker)
                if self.selectPicker == 0 {
        
                }
                if self.selectPicker == 1 {
                    self.event_peple = self.select_pcker_list[self.selectPicker] ?? 0
                }
                if self.selectPicker == 3 {
                    self.event_period = self.select_pcker_list[self.selectPicker] ?? 0
                }
                if self.selectPicker == 4 {
                    self.present_point = self.select_pcker_list[self.selectPicker] ?? 0
                }
                if self.selectPicker == 5 {
                    self.event_type = self.select_pcker_list[self.selectPicker] ?? 0
                }
                if self.selectPicker == 6 {
                    self.start_type = self.select_pcker_list[self.selectPicker] ?? 0
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

            if (self.pcker_list.count > row) {
                if (self.selectPicker == 1) {
                    return self.pcker_list[row] + "人"
                }
                if (self.selectPicker == 3) {
                    return self.pcker_list[row] + "日"
                }
                if (self.selectPicker == 4) {
                    return self.pcker_list[row] + "ポイント"
                }
                return self.pcker_list[row]
            } else {
                return ""
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            print("選択ピッカー選択ピッカー選択ピッカー")
            print(self.selectPicker)
            print(row)
            self.select_pcker_list[self.selectPicker] = row
        }

    // datePickerの日付けをtextFieldのtextに反映させる
    @objc private func setText() {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.setDateviewTime = dateFormater.string(from: datePickerView.date)
        self.start_date = self.setDateviewTime
        print("時間時間時間")
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
        query["title"] = self.title_text
        query["start_date"] = self.start_date
        query["event_peple"] = String(self.event_peple)
        query["start_type"] = String(self.start_type)
        query["present_point"] = String(self.present_point)
        query["event_type"] = String(self.event_type)
        query["event_period"] = String(self.event_period)
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String
        print(userDefaults.object(forKey: "matchness_user_id") as? String)
        print(matchness_user_id)
        print("queryqueryqueryqueryqueryqueryqueryquery")
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
    func onFinally(model: GroupEventAddModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
    
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
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;

        var count: Int = 0;

        tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
        //        self.performSegue(withIdentifier: "toGroupTop", sender: nil)
    }
    func onFailed(model: GroupEventAddModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }

    func onError(model: GroupEventAddModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }

}

