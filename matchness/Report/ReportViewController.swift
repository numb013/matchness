//
//  ReportViewController.swift
//  matchness
//
//  Created by user on 2019/07/17.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    let userDefaults = UserDefaults.standard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!
    private var requestAlamofire: Alamofire.Request?;
    var selectPicker: Int = 0
    var selectPickerItem: Int = 0
    var pcker_list: [String] = []
    var selectRow = 0
    var title_text = ""
    var report_type_1 = 0
    var target_id = 0
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
        self.tableView.register(UINib(nibName: "TextAreaTableViewCell", bundle: nil), forCellReuseIdentifier: "TextAreaTableViewCell")
        self.tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")

        
        
        pickerView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "通報理由"
        }
        if section == 1 {
            return "その他"
        }
        if section == 2 {
            return ""
        }

        return "詳細"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.tintColor = #colorLiteral(red: 0.9499146342, green: 0.9500735402, blue: 0.9498936534, alpha: 1)
        header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
//    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 35
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "profileCell")
        print("AAAAAAAAAA")
        print(indexPath)
        print(indexPath.section)
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = ApiConfig.REPORT_LIST[self.report_type_1]
                cell.detail?.text = ""
                return cell
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextAreaTableViewCell") as! TextAreaTableViewCell
                cell.textLabel!.numberOfLines = 0
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textArea.delegate = self
                cell.textArea.tag = 1
                cell.textArea?.font = UIFont.systemFont(ofSize: 14)
//                cell.textArea!.text = myData?.profile_text
                cell.textArea!.text = ""
                return cell
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell") as! ButtonTableViewCell
                cell.pushButton.addTarget(self, action: #selector(addButton(_:)), for: .touchUpInside)
                return cell

            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 150
        } else if indexPath.section == 2 {
            return 100
        }
        return 60
    }
    
    
    
    
    @objc private func pushButton(_ sender:UIButton)
    {

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissPicker()

print("セレクトセレクトセレクトセレクトセレクト")
print(indexPath)

        if indexPath.section == 0 {
            if indexPath.row == 0 {
            self.selectPicker = 1
            self.pcker_list = ApiConfig.REPORT_LIST
//            self.selectRow = 0
            }
        }
        pickerView.selectRow(self.selectRow, inComponent: 0, animated: false)
        PickerPush()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func pickerSelectButton(_ sender: Any) {
       print("bbbb")
        print("セレクトピッカー")
        print(self.selectPicker)
        print(self.selectPicker)

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
            self.pickerBottom.constant = -180
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
        print(tag)
        print(textField.text!)
        if tag == 0 {
            self.title_text = textField.text!
        }
        if tag == 1 {
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
        if tag == 1 {
            self.title_text = textField.text!
        }

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

        if tag == 0 {
            self.title_text = textField.text!
        }
        if tag == 1 {
            self.title_text = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addButton(_ sender: Any) {
        print("ハッスルクエスト")
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_REPORT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["target_id"] = String(self.target_id)
        query["report_type_1"] = String(self.report_type_1)
        query["text"] = self.title_text
        var headers: [String : String] = [:]

        var api_key = userDefaults.object(forKey: "api_token") as? String

        print("えーピアイトークンーピアイトークン")
        print(api_key)
        if ((api_key) != nil) {
            headers = [
                "Accept" : "application/json",
                "Authorization" : "Bearer " + api_key!,
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }
        print("ヘッダーヘッダーヘッダーヘッダーヘッダー")
        print(headers)
        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            print("リクエストRRRRRRRRRRRRRRRRRR")
            print(requestUrl)
//            print(method)
            print(query)
            print("リクエストBBBBBBBBBBBBBBBBBBBBB")
            switch response.result {
            case .success:
                var json:JSON;
                do{
                    //レスポンスデータを解析
                    json = try SwiftyJSON.JSON(data: response.data!);
                } catch {
                    // error
                    print("json error: \(error.localizedDescription)");
//                     self.onFaild(response as AnyObject);
                    break;
                }
                print("取得した値はここにきて")
                print(json)

                self.dismiss(animated: true, completion: nil)
                print("！！！！！！！！！！")

                // アラート作成
                let alert = UIAlertController(title: "通報", message: "通報しました。", preferredStyle: .alert)
                // アラート表示
                self.present(alert, animated: true, completion: {
                    // アラートを閉じる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                })

            case .failure:
                //  リクエスト失敗 or キャンセル時
                print("リクエスト失敗 or キャンセル時")
                return;
            }
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
