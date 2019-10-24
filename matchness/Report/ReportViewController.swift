//
//  ReportViewController.swift
//  matchness
//
//  Created by user on 2019/07/17.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!

    
    var selectPicker: Int = 0
    var selectPickerItem: Int = 0
    var pcker_list: [String] = []
    var selectRow = 0
    var title_text = ""
    var report_type_1 = 1
    var target_id = 1
    var vi = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate   = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        self.tableView.register(UINib(nibName: "ProfileEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEditTableViewCell")
        
        self.tableView.register(UINib(nibName: "TextFiledTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFiledTableViewCell")
        
        pickerView.backgroundColor = UIColor.white
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
                return cell
            }
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "期間"
                return cell
            }
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "獲得ポイント"
                return cell
            }
            
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "男女の割合"
                return cell
            }
            if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "開始タイプ"
//                cell.detail?.text = ApiConfig.EVENT_START_TYPE[Int(self.start_type) ?? 0]
                return cell
            }
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissPicker()
        if indexPath.row == 0 {
            self.selectPicker = 1
            self.pcker_list = ApiConfig.FITNESS_LIST
//            self.selectRow = 0
        }
        if indexPath.row == 1 {
            self.selectPicker = 1
            self.pcker_list = ApiConfig.FITNESS_LIST
//            self.selectRow = 0
        }

        pickerView.selectRow(self.selectRow, inComponent: 0, animated: false)
        PickerPush()
        tableView.deselectRow(at: indexPath, animated: true)
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
            self.report_type_1 = self.selectPickerItem
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
            self.pickerBottom.constant = -280
            self.pickerView.updateConstraints()
            self.tableView.updateConstraints()
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissPicker(){
        UIView.animate(withDuration: 0.5,animations: {
            self.pickerBottom.constant = 200
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
        print(self.pcker_list.count)
        return self.pcker_list.count
    }
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        print("p3p3p3p3p3")
        print(self.pcker_list)
        return self.pcker_list[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectPickerItem = row
        print("選択ピッカー選択ピッカー選択ピッカー")
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
        let requestReportModel = ReportModel();
        requestReportModel.delegate = self as! ReportModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_GROUP;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["target_id"] = String(self.target_id)
        query["report_type_1"] = String(self.report_type_1)
        query["text"] = self.title_text
        //リクエスト実行
        if( !requestReportModel.requestApi(url: requestUrl, addQuery: query) ){
            
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


//
//extension ReportViewController : ReportModelDelegate {
//
//    func onStart(model: ReportModel) {
//        print("こちら/UserDetail/UserDetailViewのonStart")
//    }
//    func onComplete(model: ReportModel, count: Int) {
//        print("UserDetail着てきてきてきて")
//        //更新用データを設定
//        self.dataSource = model.responseData;
//        self.dataSourceOrder = model.responseDataOrder;
//
//        print(self.dataSourceOrder)
//        print("UserDetail耳耳耳意味耳みm")
//
//
//        //一つもなかったら
//        //        if( dataSourceOrder.isEmpty ){
//        //            return;
//        //        }
//
//        //cellの件数更新
//        self.cellCount = dataSourceOrder.count;
//        //        self.cellCount = 10;
//
//
//        //
//        var count: Int = 0;
//        //        for(key, code) in dataSourceOrder.enumerated() {
//        //            count+=1;
//        //            if let jenre: ApiUserDateParam = dataSource[code] {
//        //                //取得したデータを元にコレクションを再構築＆更新
//        //                mapMenuView.addTagGroup(model: model, jenre: jenre);
//        //            }
//        //        }
//
//        tableView.reloadData()
//        self.dismiss(animated: true, completion: nil)
//        //        self.performSegue(withIdentifier: "toGroupTop", sender: nil)
//    }
//    func onFailed(model: ReportModel) {
//        print("こちら/MultipleModel/UserDetailViewのonFailed")
//    }
//}
//
