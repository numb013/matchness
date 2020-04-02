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

    var activityIndicatorView = UIActivityIndicatorView()
    
    var validate = 0
    var select_pcker_list: [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
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
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "詳細"
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        header.tintColor = #colorLiteral(red: 0.9499146342, green: 0.9500735402, blue: 0.9498936534, alpha: 1)
//        header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//    }
//    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 35
//    }
//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "profileCell")
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFiledTableViewCell") as! TextFiledTableViewCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
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
                cell.title?.text = "参加人数 (自分を含めた人数)"
                cell.detail?.text = ApiConfig.EVENT_PEPLE_LIST[self.event_peple ?? 0] + "人"
                return cell
            }

            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "期間"
                cell.detail?.text = ApiConfig.EVENT_PERIOD_LIST[self.event_period ?? 0] + "日"
                return cell
            }

            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "プレゼントポイント"
                cell.detail?.text = ApiConfig.EVENT_PRESENT_POINT[self.present_point ?? 0] + "P"
                return cell
            }
            
//            if indexPath.row == 4 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
//
//                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
//                cell.title?.text = "男女の割合"
//                cell.detail?.text = ApiConfig.EVENT_TYPE_LIST[self.event_type ?? 0]
//                return cell
//            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissPicker()
//        if indexPath.row == 0 {
//            self.selectPicker = 0
//        }
        if indexPath.row == 1 {
            self.selectPicker = 1
            self.pcker_list = ApiConfig.EVENT_PEPLE_LIST
            self.selectRow = self.event_peple ?? 0
        }
        if indexPath.row == 2 {
            self.selectPicker = 2
            self.pcker_list = ApiConfig.EVENT_PERIOD_LIST
            self.selectRow = self.event_period ?? 0
        }
        if indexPath.row == 3 {
            self.selectPicker = 3
            self.pcker_list = ApiConfig.EVENT_PRESENT_POINT
            self.selectRow = self.present_point ?? 0
        }
//        if indexPath.row == 4 {
//            self.selectPicker = 4
//            self.pcker_list = ApiConfig.EVENT_TYPE_LIST
//            self.selectRow = self.event_type ?? 0
//        }
        pickerView.selectRow(self.selectRow, inComponent: 0, animated: false)
        PickerPush()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    @IBAction func pickerSelectButton(_ sender: Any) {
       print("bbbb")
        print("セレクトピッカーAAAAAA")
        print(self.selectPicker)
        if self.selectPicker == 1 {
            self.event_peple = self.select_pcker_list[self.selectPicker] ?? 0
        }
        if self.selectPicker == 2 {
            self.event_period = self.select_pcker_list[self.selectPicker] ?? 0
        }
        if self.selectPicker == 3 {
            self.present_point = self.select_pcker_list[self.selectPicker] ?? 0
        }
//        if self.selectPicker == 4 {
//            self.event_type = self.select_pcker_list[self.selectPicker] ?? 0
//        }

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
            self.pickerBottom.constant = -230
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
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        print("p3p3p3p3p3")
        print(self.selectPicker)

        if (self.pcker_list.count > row) {
            if (self.selectPicker == 1) {
                return self.pcker_list[row] + "人"
            }
            if (self.selectPicker == 2) {
                return self.pcker_list[row] + "日"
            }
            if (self.selectPicker == 3) {
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
    
    func validator(){
        self.activityIndicatorView.stopAnimating()
        // アラート作成
        let alert = UIAlertController(title: "入力エラー", message: "タイトルは必須になります", preferredStyle: .alert)
        // アラート表示
        self.present(alert, animated: true, completion: {
            // アラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                alert.dismiss(animated: true, completion: nil)
                self.validate = 0
            })
        })
    }

    @IBAction func addButton(_ sender: Any) {

        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        view.addSubview(activityIndicatorView)

        
        let alertController:UIAlertController =
            UIAlertController(title:"グループを作成していいですか？",message: "作成するには300pポント必要になります",preferredStyle: .alert)
        // Default のaction
        let defaultAction:UIAlertAction =
            UIAlertAction(title: "作成する",style: .default){
                (action:UIAlertAction!) -> Void in
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
        //        query["start_date"] = self.start_date
                query["event_peple"] = String(self.event_peple)
                query["present_point"] = String(self.present_point)
                query["event_type"] = String(self.event_type)
                query["event_period"] = String(self.event_period)
                print("queryqueryqueryqueryqueryqueryqueryquery")
                print(query)

                if (query["title"] == "") {
                    self.validate = 1
                    self.validator()
                }

                if (self.validate == 0) {
                    //リクエスト実行
                    if( !requestGroupEventAddModel.requestApi(url: requestUrl, addQuery: query) ){
                        
                    }
                }
            }
        // Cancel のaction
        let cancelAction:UIAlertAction =
            UIAlertAction(title: "キャンセル",style: .destructive){
                (action:UIAlertAction!) -> Void in
                // 処理
                print("キャンセル")
            }
        // actionを追加
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        // UIAlertControllerの起動
        present(alertController, animated: true, completion: nil)

    }
    
    func close() {
        print("閉じる閉じる閉じる閉じる閉じる")
        self.dismiss(animated: true, completion: nil)
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
        self.cellCount = 0;

        var count: Int = 0;

        
        
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;

        let alertController:UIAlertController =
            UIAlertController(title:"グループを作成しました",message: "リクエストユーザを承認して開始しよう",preferredStyle: .alert)
        // Default のaction

        let cancelAction:UIAlertAction =
            UIAlertAction(title: "閉じる",style: .cancel,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                print("キャンセル")
//                self.ActivityIndicator.stopAnimating()
                self.activityIndicatorView.stopAnimating()
                self.dismiss(animated: true, completion: nil)
                self.close()
            })
        // actionを追加
        alertController.addAction(cancelAction)
        // UIAlertControllerの起動
        present(alertController, animated: true, completion: nil)

    }




    func onFailed(model: GroupEventAddModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }

    func onError(model: GroupEventAddModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.error(alertNum: self.errorData, viewController: self)
        self.activityIndicatorView.stopAnimating()
    }

}

