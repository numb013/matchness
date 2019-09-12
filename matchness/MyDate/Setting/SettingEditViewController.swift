//
//  SettingEditViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/08.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class SettingEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var UserSettingTable: UITableView!
    
    let pickerView = UIPickerView()
    let datePickerView = UIDatePicker()
    var setDateviewTime = ""
    var vi = UIView()
    var isDate = Date()
    var selectPicker: Int = 0
    var selectPickerItem: Int = 0
    var pcker_list: [String] = []
    var setDay = Date()
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiUserDetailDate> = [:]
    var dataSourceOrder: Array<String> = []

    var selectRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserSettingTable.delegate = self
        UserSettingTable.dataSource = self
        // Do any additional setup after loading the view.

        pickerView.showsSelectionIndicator = true
        
        self.UserSettingTable.register(UINib(nibName: "SettingEditTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingEditTableViewCell")

        // datePickerの設定
        datePickerView.date = isDate
        datePickerView.datePickerMode = .date
        datePickerView.locale = Locale(identifier: "ja")
        datePickerView.addTarget(self, action: #selector(setText), for: .valueChanged)
        datePickerView.backgroundColor = UIColor.white

        
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestSettingEditModel = SettingEditModel();
        requestSettingEditModel.delegate = self as! SettingEditModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ME;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var api_key = userDefaults.object(forKey: "api_token") as? String
        query["api_token"] = api_key
        //リクエスト実行
        if( !requestSettingEditModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        print("マイデータ")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "設定"
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
        print("こいいいいいい")
        print(self.dataSource)
        var myData = self.dataSource["0"]
        
        let cell = UserSettingTable.dequeueReusableCell(withIdentifier: "SettingEditTableViewCell") as! SettingEditTableViewCell
        if indexPath.row == 0 {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.title?.text = "ニックネーム"
            print("ニックネームニックネームニックネームニックネーム")
            print(self.dataSource["0"]?.work)
            cell.detail?.text = myData?.name
            return cell
        }
        if indexPath.row == 1 {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.title?.text = "職業"
            cell.detail?.text = ApiConfig.WORK_LIST[myData?.work ?? 0]
            return cell
        }
        if indexPath.row == 2 {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.title?.text = "居住地"
            cell.detail?.text = ApiConfig.PREFECTURE_LIST[myData?.prefecture_id ?? 0]
            return cell
        }
        if indexPath.row == 3 {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.title?.text = "誕生日"

            let f = DateFormatter()
            f.dateStyle = .long
            f.locale = Locale(identifier: "ja")
//                self.setDateviewTime = f.string(from: self.dataSource["0"]!.birthday)
            let dateFormater = DateFormatter()
//                dateFormater.locale = Locale(identifier: "ja_JP")
//                dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
//                var date = dateFormater.date(from: self.dataSource["0"]?.birthday ?? "2016-10-03 03:12:12 +0000")
////                print(date?.description ?? "nilですよ")    // 2016-10-03 03:12:12 +0000
//                var date_data = date?.description
       
//                dateFormater.locale = Locale(identifier: "ja_JP")
//                var date = dateFormater.date(from: self.dataSource["0"]?.birthday ?? "2016-10-03 03:12:12 +0000")
 
//                dateFormater.dateFormat = "yyyy年MM月dd日"
//                var date_text = dateFormater.string(from: date!)
            
            
            cell.detail?.text = "2016-10-03 03:12:12"
            return cell
        }
        
        if indexPath.row == 4 {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.title?.text = "痩せたい部位"
            cell.detail?.text = ApiConfig.FITNESS_LIST[myData?.fitness_parts_id ?? 0]
            return cell
        }
        if indexPath.row == 5 {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.title?.text = "体重(非公開)"
            cell.detail?.text = ApiConfig.WEIGHT_LIST[myData?.weight ?? 0]
            return cell

        }

        if indexPath.row == 6 {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.title?.text = "性別"
            cell.detail?.text = ApiConfig.SEX_LIST[myData?.sex ?? 0]
            return cell
        }

        if indexPath.row == 7 {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.title?.text = "血液型"
            cell.detail?.text = ApiConfig.BLOOD_LIST[myData?.blood_type ?? 2]
            return cell
        }


        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
print("タップ")

        cancelPressed()
        cancelDatePressed()
        if indexPath.row == 0 {
            self.selectPicker = 0
        }
        if indexPath.row == 1 {
            self.selectPicker = 1
            self.pcker_list = ApiConfig.WORK_LIST
            self.selectRow = self.dataSource["0"]?.work ?? 0
        }
        if indexPath.row == 2 {
            self.selectPicker = 2
            self.pcker_list = ApiConfig.PREFECTURE_LIST
            self.selectRow = self.dataSource["0"]?.prefecture_id ?? 0
        }
        if indexPath.row == 4 {
            self.selectPicker = 4
            self.pcker_list = ApiConfig.FITNESS_LIST
            self.selectRow = self.dataSource["0"]?.fitness_parts_id ?? 0
        }
        if indexPath.row == 5 {
            self.selectPicker = 5
            self.pcker_list = ApiConfig.WEIGHT_LIST
            self.selectRow = self.dataSource["0"]?.weight ?? 0
        }
        if indexPath.row == 6 {
            self.selectPicker = 6
            self.pcker_list = ApiConfig.SEX_LIST
            self.selectRow = self.dataSource["0"]?.sex ?? 0
        }
        if indexPath.row == 7 {
            self.selectPicker = 7
            self.pcker_list = ApiConfig.BLOOD_LIST
            self.selectRow = self.dataSource["0"]?.blood_type ?? 0
        }
        pickerView.selectRow(self.selectRow, inComponent: 0, animated: false)
        print(indexPath.section)
        print(indexPath.row)

        if indexPath.row == 3 {
            datePickerPush()
        } else {
            PickerPush()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
    func PickerPush(){
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.bounds.size.height)
        // Connect data:
        pickerView.delegate   = self
        pickerView.dataSource = self
        vi = UIView(frame: pickerView.bounds)
        vi.backgroundColor = UIColor.white
        vi.addSubview(pickerView)
        view.addSubview(vi)
        let screenSize = UIScreen.main.bounds.size
        vi.frame.origin.y = screenSize.height
        UIView.animate(withDuration: 0.3) {
            self.vi.frame.origin.y = screenSize.height - self.vi.bounds.size.height
        }
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(SettingEditViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SettingEditViewController.cancelPressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        vi.addSubview(toolBar)
        print("push")
    }
    
    func datePickerPush(){
        datePickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: datePickerView.bounds.size.height)
        // Connect data:
        pickerView.delegate   = self
        pickerView.dataSource = self
        vi = UIView(frame: datePickerView.bounds)
        vi.backgroundColor = UIColor.white
        vi.addSubview(datePickerView)
        view.addSubview(vi)
        let screenSize = UIScreen.main.bounds.size
        vi.frame.origin.y = screenSize.height
        UIView.animate(withDuration: 0.3) {
            self.vi.frame.origin.y = screenSize.height - self.vi.bounds.size.height
        }
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(SettingEditViewController.doneDatePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SettingEditViewController.cancelDatePressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        vi.addSubview(toolBar)
        print("push")
    }
    
    @objc func donePressed() {
        print("bbbb")
        print("セレクトピッカー")
        print(self.selectPicker)
        if self.selectPicker == 0 {
            
        }
        if self.selectPicker == 1 {
            self.dataSource["0"]?.work = self.selectPickerItem
        }
        if self.selectPicker == 2 {
            self.dataSource["0"]?.prefecture_id = self.selectPickerItem
        }
        if self.selectPicker == 3 {
            self.dataSource["0"]?.work = self.selectPickerItem
        }
        if self.selectPicker == 4 {
            self.dataSource["0"]?.fitness_parts_id = self.selectPickerItem
        }
        if self.selectPicker == 5 {
            self.dataSource["0"]?.weight = self.selectPickerItem
        }
        if self.selectPicker == 6 {
            self.dataSource["0"]?.sex = self.selectPickerItem
        }
        if self.selectPicker == 7 {
            self.dataSource["0"]?.blood_type = self.selectPickerItem
        }
        UserSettingTable.reloadData()
        self.vi.removeFromSuperview()
    }
    
    // Cancel
    @objc func cancelPressed() {
        print("aaaaa")
        //        UITextField.text = ""
        self.vi.endEditing(true)
        self.vi.removeFromSuperview()
    }
    
    @objc func doneDatePressed() {
        print("セットセットセットセット")
        print(self.setDateviewTime)
        self.vi.removeFromSuperview()
    }
    
    @objc func cancelDatePressed() {
        self.vi.removeFromSuperview()
    }




    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pcker_list.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(self.pcker_list[row])
        return self.pcker_list[row]
    }

    // ドラムロール選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectPickerItem = row
        print("選択ピッカー選択ピッカー選択ピッカー")
    }


    // datePickerの日付けをtextFieldのtextに反映させる
    @objc private func setText() {
        let f = DateFormatter()
        f.dateStyle = .long
        f.locale = Locale(identifier: "ja")
        self.setDateviewTime = f.string(from: datePickerView.date)
        print("lplplplplplplplplplplplplplplplpl")
        print(datePickerView.date)
    }
    
    
    @IBAction func editProfilButton(_ sender: Any) {
print("編集ボタン！！！！")
        print(self.dataSource["0"])
print("編集ボタン??????")

        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestSettingEditModel = SettingEditModel();
        requestSettingEditModel.delegate = self as! SettingEditModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_PROFILE_EDIT;

        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["id"] = String(self.dataSource["0"]?.id ?? 0)
        query["work"] = String(self.dataSource["0"]?.work ?? 0)
        query["age"] = String(self.dataSource["0"]?.age ?? 0)
        query["sex"] = String(self.dataSource["0"]?.sex ?? 0)
        query["fitness_parts_id"] = String(self.dataSource["0"]?.fitness_parts_id ?? 0)
        query["blood_type"] = String(self.dataSource["0"]?.blood_type ?? 0)
        query["weight"] = String(self.dataSource["0"]?.weight ?? 0)
        query["prefecture_id"] = String(self.dataSource["0"]?.prefecture_id ?? 0)
        //リクエスト実行
        if( !requestSettingEditModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        print("マイデータ")
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


extension SettingEditViewController : SettingEditModelDelegate {
    
    func onStart(model: SettingEditModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onComplete(model: SettingEditModel, count: Int) {
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
        
        UserSettingTable.reloadData()
    }
    func onFailed(model: SettingEditModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }
    
}
