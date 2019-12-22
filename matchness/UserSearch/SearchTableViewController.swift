//
//  ProfileEditViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/08.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    var dataSource: Dictionary<String, ApiUserDate> = [:]
    var dataSourceOrder: Array<String> = []

    var freeword = ""
    var work: Int = 0
    var prefecture_id: Int = 0
    var blood_type: Int = 0
    var fitness_parts_id: Int = 0
    var search_age_id: Int = 0

    var editType: Int = 0
    var selectRow = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        pickerView.delegate   = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        if ((self.userDefaults.object(forKey: "searchFreeword")) != nil) {
            self.freeword = (self.userDefaults.object(forKey: "searchFreeword") as? String)!
        }
        if ((self.userDefaults.object(forKey: "searchWork")) != nil) {
            self.work = Int((self.userDefaults.object(forKey: "searchWork") as? String)!)!
        }
        if ((self.userDefaults.object(forKey: "searchPrefectureId")) != nil) {
            self.prefecture_id = Int((self.userDefaults.object(forKey: "searchPrefectureId") as? String)!)!
        }
        if ((self.userDefaults.object(forKey: "searchBloodType")) != nil) {
            self.blood_type = Int((self.userDefaults.object(forKey: "searchBloodType") as? String)!)!
        }
        if ((self.userDefaults.object(forKey: "searchFitnessPartsId")) != nil) {
            self.fitness_parts_id = Int((self.userDefaults.object(forKey: "searchFitnessPartsId") as? String)!)!
        }

//        self.work = Int((self.userDefaults.object(forKey: "searchWork") as? String)!)!
//        self.prefecture_id = Int((self.userDefaults.object(forKey: "searchPrefectureId") as? String)!)!
//        self.blood_type = Int((self.userDefaults.object(forKey: "searchBloodType") as? String)!)!
//        self.fitness_parts_id = Int((self.userDefaults.object(forKey: "searchFitnessPartsId") as? String)!)!

print("workworkworkworkworkworkwork")
print(work)

        self.tableView.register(UINib(nibName: "ProfileEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEditTableViewCell")

        self.tableView.register(UINib(nibName: "TextFiledTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFiledTableViewCell")

        self.tableView.register(UINib(nibName: "TextAreaTableViewCell", bundle: nil), forCellReuseIdentifier: "TextAreaTableViewCell")

        self.tableView.register(UINib(nibName: "ProfilImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfilImageTableViewCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
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

        print("こいいいいいい")
        print(self.dataSource)
        var myData = self.dataSource["0"]

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFiledTableViewCell") as! TextFiledTableViewCell

                cell.title?.text = "フリーワード"
                cell.textFiled.delegate = self
                cell.textFiled.tag = 0
                cell.textFiled?.text = myData?.name
                return cell
            }
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "職業"
                cell.detail?.text = ApiConfig.WORK_LIST[self.work ?? Int((userDefaults.object(forKey: "searchWork") as? String)!)!]
                return cell
            }
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "居住地"
                cell.detail?.text = ApiConfig.PREFECTURE_LIST[self.prefecture_id ?? 0]
                return cell
            }
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "痩せたい部位"
                cell.detail?.text = ApiConfig.FITNESS_LIST[self.fitness_parts_id ?? Int((userDefaults.object(forKey: "searchFitnessPartsId") as? String)!)!]
                return cell
            }
            
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "血液型"
                cell.detail?.text = ApiConfig.BLOOD_LIST[self.blood_type ?? Int((userDefaults.object(forKey: "searchBloodType") as? String)!)!]
                return cell
            }
            if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "年齢"
                cell.detail?.text = ApiConfig.SEARCH_AGE_LIST[self.search_age_id ?? Int((userDefaults.object(forKey: "searchBloodType") as? String)!)!]
                return cell
            }
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップ")
        print(indexPath.row)

        dismissPicker()
        if indexPath.row == 1 {
            self.selectPicker = 1
            self.pcker_list = ApiConfig.WORK_LIST
            self.selectRow = self.work ?? 0
        }
        if indexPath.row == 2 {
            self.selectPicker = 2
            self.pcker_list = ApiConfig.PREFECTURE_LIST
            self.selectRow = self.prefecture_id ?? 0
        }
        if indexPath.row == 3 {
            self.selectPicker = 3
            self.pcker_list = ApiConfig.FITNESS_LIST
            self.selectRow = self.fitness_parts_id ?? 0
        }
        if indexPath.row == 4 {
            self.selectPicker = 4
            self.pcker_list = ApiConfig.BLOOD_LIST
            self.selectRow = self.blood_type ?? 0
        }
        if indexPath.row == 5 {
            self.selectPicker = 5
            self.pcker_list = ApiConfig.SEARCH_AGE_LIST
            self.selectRow = self.search_age_id ?? 0
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



    @IBAction func pickerSelectButton(_ sender: Any) {
        print("セレクトピッカーセレクトピッカーbbbb")
        print("セレクトピッカー")
        print(self.selectPicker)
        print(self.selectPickerItem)

        if self.selectPicker == 1 {
            self.work = self.selectPickerItem
        }
        if self.selectPicker == 2 {
            self.prefecture_id = self.selectPickerItem
        }
        if self.selectPicker == 3 {
            self.fitness_parts_id = self.selectPickerItem
        }
        if self.selectPicker == 4 {
            self.blood_type = self.selectPickerItem
        }
        if self.selectPicker == 5 {
            self.search_age_id = self.selectPickerItem
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
            self.pickerBottom.constant = -120
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
        return self.pcker_list[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        print(row)

        self.selectPickerItem = row
        print("選択ピッカー選択ピッカー選択ピッカー")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("テキスト１")
        var tag = textField.tag
        print(tag)
        print(textField.text!)
        self.freeword = textField.text!
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var tag = textField.tag
        print(textField.text!)
        self.freeword = textField.text!

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

        self.freeword = textField.text!
        textField.resignFirstResponder()
        return true
    }

    
    
    @IBAction func searchButton(_ sender: Any) {
        print("編集ボタン！！！！")
        print(self.dataSource["0"])
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

        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["freeword"] = self.freeword
        query["work"] = String(self.work ?? 0)
        query["fitness_parts_id"] = String(self.fitness_parts_id ?? 0)
        query["blood_type"] = String(self.blood_type ?? 0)
        query["prefecture_id"] = String(self.prefecture_id ?? 0)


        
        let storyboard: UIStoryboard = self.storyboard!
        let nextVC = storyboard.instantiateViewController(withIdentifier: "userSearch") as! UserSearchViewController

        nextVC.freeword = self.freeword
        nextVC.work = String(self.work)
        nextVC.fitness_parts_id = String(self.fitness_parts_id)
        nextVC.blood_type = String(self.blood_type)
        nextVC.prefecture_id = String(self.prefecture_id)

        
        UserDefaults.standard.set(self.freeword, forKey: "searchFreeword")
        UserDefaults.standard.set(String(self.work), forKey: "searchWork")
        UserDefaults.standard.set(String(self.fitness_parts_id), forKey: "searchFitnessPartsId")
        UserDefaults.standard.set(String(self.blood_type), forKey: "searchBloodType")
        UserDefaults.standard.set(String(self.prefecture_id), forKey: "searchPrefectureId")
        
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

//
//extension SearchTableViewController : UserSearchModelDelegate {
//
//    func onStart(model: UserSearchModel) {
//        print("こちら/UserDetail/UserDetailViewのonStart")
//    }
//    func onComplete(model: UserSearchModel, count: Int) {
//        print("UserDetail着てきてきてきて")
//        //更新用データを設定
//        self.dataSource = model.responseData;
//        self.dataSourceOrder = model.responseDataOrder;
//
//        print(self.dataSourceOrder)
//        print("UserDetail耳耳耳意味耳みm")
//        print(self.dataSource)
//        print(self.dataSource["0"]?.name)
//        print(self.dataSource["0"]?.work)
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
//
//        if self.editType == 1 {
//        print("更新")
//        let alertController:UIAlertController =
//            UIAlertController(title:"プロフィールが更新されました",message: "プロフィールが更新されました",preferredStyle: .alert)
//        // Default のaction
//        let defaultAction:UIAlertAction =
//            UIAlertAction(title: "更新されました",style: .destructive,handler:{
//                (action:UIAlertAction!) -> Void in
//                // 処理
//                print("更新されました")
//            })
//        // Cancel のaction
//        let cancelAction:UIAlertAction =
//            UIAlertAction(title: "閉じる",style: .cancel,handler:{
//                (action:UIAlertAction!) -> Void in
//                // 処理
//                print("キャンセル")
//            })
//        // actionを追加
//        alertController.addAction(cancelAction)
//        alertController.addAction(defaultAction)
//        // UIAlertControllerの起動
//        present(alertController, animated: true, completion: nil)
//        }
//
//
////        tableView.reloadData()
//
//
//    }
//    func onFailed(model: UserSearchModel) {
//        print("こちら/UserSearchModel/UserDetailViewのonFailed")
//    }
//
//}
