//
//  ProfileEditViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/08.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class GroupSearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!

    var vi = UIView()
    var isDate = Date()
    var selectPicker: Int = 0
    var selectPickerItem: Int = 0
    var pcker_list: [String] = []
    var cellCount: Int = 0
    var select_pcker_list: [Int] = [0, 0, 0, 0, 0, 0, 0, 0]

    
    var group_freeword = ""
    var event_period: Int = 0
    var event_peple: Int = 0
    var present_point: Int = 0
    var master_flag: Int = 0
    var request_flag: Int = 0
    var selectRow = 0
    var device = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        pickerView.delegate   = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        if ((self.userDefaults.object(forKey: "searchGroupFreeword")) != nil) {
            self.group_freeword = (self.userDefaults.object(forKey: "searchGroupFreeword") as? String)!
        }
        if ((self.userDefaults.object(forKey: "searchEventPeriod")) != nil) {
            self.event_period = Int((self.userDefaults.object(forKey: "searchEventPeriod") as? String)!)!
        }
        if ((self.userDefaults.object(forKey: "searchEventPeple")) != nil) {
            self.event_peple = Int((self.userDefaults.object(forKey: "searchEventPeple") as? String)!)!
        }
        if ((self.userDefaults.object(forKey: "searchPresentPoint")) != nil) {
            self.present_point = Int((self.userDefaults.object(forKey: "searchPresentPoint") as? String)!)!
        }
        if ((self.userDefaults.object(forKey: "searchMasterFlag")) != nil) {
            self.master_flag = Int((self.userDefaults.object(forKey: "searchMasterFlag") as? String)!)!
        }
        if ((self.userDefaults.object(forKey: "searchRequestFlag")) != nil) {
            self.request_flag = Int((self.userDefaults.object(forKey: "searchRequestFlag") as? String)!)!
        }

        switch (UIScreen.main.nativeBounds.height) {
        case 2436:
            //iPhone X
            self.device = 2
            print("heigh_6")
            break
        case 1792:
            //iPhone XR
            self.device = 3
            break
        case 2688:
            //iPhone XR
            self.device = 3
            break
        default:
            self.device = 1
            break
        }
        
        self.tableView.register(UINib(nibName: "ProfileEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEditTableViewCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return ""
//    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.tintColor = #colorLiteral(red: 0.9499146342, green: 0.9500735402, blue: 0.9498936534, alpha: 1)
        header.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        pickerView.delegate   = self
        pickerView.dataSource = self

        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "profileCell")

        print("0000000000")
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "参加人数"
                cell.detail?.text = ApiConfig.EVENT_PEPLE_LIST[self.event_peple ?? Int((userDefaults.object(forKey: "search EventPeple") as? String)!)!] + "人"

                return cell
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "期間"
                cell.detail?.text = ApiConfig.EVENT_PERIOD_LIST[self.event_period ?? Int((userDefaults.object(forKey: "searchEvent Period") as? String)!)!] + "日"

                return cell
            }
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "賞金"
                cell.detail?.text = ApiConfig.EVENT_PRESENT_POINT[self.present_point ?? Int((userDefaults.object(forKey: "searchPresentPoint") as? String)!)!] + "P"
                return cell
            }

            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "主催グループ"
                cell.detail?.text = ApiConfig.MASTER_FLG_LIST[self.master_flag ?? Int((userDefaults.object(forKey: "searchMasterFlag") as? String)!)!]
                return cell
            }
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "リクエストグループ"
                cell.detail?.text = ApiConfig.REQUEST_FLG_LIST[self.request_flag ?? Int((userDefaults.object(forKey: "searchRequestFlag") as? String)!)!]
                return cell
            }
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップ")
        print(indexPath.row)
        dismissPicker()
        if indexPath.row == 0 {
            self.selectPicker = 0
            self.pcker_list = ApiConfig.EVENT_PEPLE_LIST
            self.selectRow = self.event_peple ?? 0
        }
        if indexPath.row == 1 {
            self.selectPicker = 1
            self.pcker_list = ApiConfig.EVENT_PERIOD_LIST
            self.selectRow = self.event_period ?? 0
        }
        if indexPath.row == 2 {
            self.selectPicker = 2
            self.pcker_list = ApiConfig.EVENT_PRESENT_POINT
            self.selectRow = self.present_point ?? 0
        }
        if indexPath.row == 3 {
            self.selectPicker = 3
            self.pcker_list = ApiConfig.MASTER_FLG_LIST
            self.selectRow = self.master_flag ?? 0
        }
        if indexPath.row == 4 {
            self.selectPicker = 4
            self.pcker_list = ApiConfig.REQUEST_FLG_LIST
            self.selectRow = self.request_flag ?? 0
        }


        pickerView.selectRow(self.selectRow, inComponent: 0, animated: false)
        print(indexPath.section)
        print(indexPath.row)

        print("ピッカーーーーーーーー")
        PickerPush()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func aaaa() {
        print("22222222222")
        tableView.reloadData()
    }

    @IBAction func pickerSelectButton(_ sender: Any) {
        print("セレクトピッカーセレクトピッカーbbbb")
        print("セレクトピッカー")
        print(self.selectPicker)
        print(self.selectPickerItem)
        if self.selectPicker == 0 {
            self.event_peple = self.select_pcker_list[self.selectPicker] ?? 0
        }
        if self.selectPicker == 1 {
            self.event_period = self.select_pcker_list[self.selectPicker] ?? 0
        }
        if self.selectPicker == 2 {
            self.present_point = self.select_pcker_list[self.selectPicker] ?? 0
        }
        if self.selectPicker == 3 {
            self.master_flag = self.select_pcker_list[self.selectPicker] ?? 0
        }
        if self.selectPicker == 4 {
            self.request_flag = self.select_pcker_list[self.selectPicker] ?? 0
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
        print(self.device)
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5,animations: {

            //1:ノーマル 2:XR
            if self.device == 2 {
                self.pickerBottom.constant = -180
            } else if self.device == 3 {
                self.pickerBottom.constant = -120
            } else {
                self.pickerBottom.constant = -300
            }
            

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

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print("p1p1p1p1p")
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("p2p2p2p2p2")
        return self.pcker_list.count
    }
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("p3p3p3p3p3")
        if (self.pcker_list.count > row) {
            if (self.selectPicker == 0) {
                return self.pcker_list[row] + "人"
            }
            if (self.selectPicker == 1) {
                return self.pcker_list[row] + "日"
            }
            if (self.selectPicker == 2) {
                return self.pcker_list[row] + "P"
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("テキスト１")
        var tag = textField.tag
        print(tag)
        print(textField.text!)
        self.group_freeword = textField.text!
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var tag = textField.tag
        print(textField.text!)
        self.group_freeword = textField.text!

        textField.resignFirstResponder()
        return
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        var tag = textField.tag
        print("キーボードを閉じるキーボードを閉じるキーボードを閉じる")
        print(tag)

        self.group_freeword = textField.text!
        textField.resignFirstResponder()
        return true
    }


    
    
    @IBAction func searchResetButton(_ sender: Any) {
        print("リセットリセットリセット")
        userDefaults.removeObject(forKey: "searchGroupFreeword")
        self.group_freeword = ""

        userDefaults.removeObject(forKey: "searchEventPeple")
        self.event_peple = 0
        
        userDefaults.removeObject(forKey: "searchEventPeriod")
        self.event_period = 0

        userDefaults.removeObject(forKey: "searchPresentPoint")
        self.present_point = 0

        userDefaults.removeObject(forKey: "searchMasterFlag")
        self.master_flag = 0

        userDefaults.removeObject(forKey: "searchRequestFlag")
        self.request_flag = 0

        self.select_pcker_list = [0, 0, 0, 0, 0, 0, 0, 0]
        tableView.reloadData()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        print("編集ボタン！！！！")

        print("編集ボタン??????")
//        self.editType = 1
//        /****************
//         APIへリクエスト（ユーザー取得）
//         *****************/
//        //ロジック生成
//        let requestUserSearchModel = UserSearchModel();
//        requestUserSearchModel.delegate = self as! UserSearchModelDelegate;
//        //リクエスト先
//        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_SEARCH;

        var event_period: Int = 0
        var event_peple: Int = 0
        var present_point: Int = 0
        var master_flag: Int = 0
        var request_flag: Int = 0
        
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["group_freeword"] = self.group_freeword
        query["event_peple"] = String(self.event_peple ?? 0)
        query["event_period"] = String(self.event_period ?? 0)
        query["present_point"] = String(self.present_point ?? 0)
        query["master_flag"] = String(self.master_flag ?? 0)
        query["request_flag"] = String(self.request_flag ?? 0)
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextVC = storyboard.instantiateViewController(withIdentifier: "WaitGroup") as! WaitGroupViewController

        nextVC.group_freeword = self.group_freeword
        nextVC.event_peple = String(self.event_peple)
        nextVC.event_period = String(self.event_period)
        nextVC.present_point = String(self.present_point)
        nextVC.master_flag = String(self.master_flag)
        nextVC.request_flag = String(self.request_flag)

print("検索検索検索検索検索検索検索検索")
print(query)

        if (self.group_freeword != nil) {
            UserDefaults.standard.set(self.group_freeword, forKey: "searchGroupFreeword")
        }
        if (self.event_peple != nil) {
            UserDefaults.standard.set(String(self.event_peple), forKey: "searchEventPeple")
        }
        if (self.event_period != nil) {
            UserDefaults.standard.set(String(self.event_period), forKey: "searchEventPeriod")
        }
        if (self.present_point != nil) {
            UserDefaults.standard.set(String(self.present_point), forKey: "searchPresentPoint")
        }
        if (self.master_flag != nil) {
            UserDefaults.standard.set(String(self.master_flag), forKey: "searchMasterFlag")
        }
        if (self.request_flag != nil) {
            UserDefaults.standard.set(String(self.request_flag), forKey: "searchRequestFlag")
        }
//        self.present(nextVC, animated: false, completion: nil)
//        self.navigationController?.pushViewController(nextVC, animated: true)
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true)
        self.dismiss(animated: true, completion: nil)
        //リクエスト実行
//        if( !requestUserSearchModel.requestApi(url: requestUrl, addQuery: query) ){
//
//        }
//        print("マイデータ")
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
