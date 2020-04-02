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

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate {

    let userDefaults = UserDefaults.standard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!
    @IBOutlet weak var user_name: UILabel!
    
    private var requestAlamofire: Alamofire.Request?;
    var selectPicker: Int = 0
    var selectPickerItem: Int = 0
    var pcker_list: [String] = []
    var selectRow = 0
    var title_text = ""
    var report_type_1 = 0
    var report_param = [String:Any]()
    var vi = UIView()
    var myTextView = UITextView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate   = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        self.tableView.register(UINib(nibName: "ProfileEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEditTableViewCell")
        
        self.tableView.register(UINib(nibName: "TextFiledTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFiledTableViewCell")
//        self.tableView.register(UINib(nibName: "TextAreaTableViewCell", bundle: nil), forCellReuseIdentifier: "TextAreaTableViewCell")
        self.tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")

        pickerView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
//        self.user_name.text = report_param["target_name"] as! String
        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()  //Notification発行
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
                let width1 = self.view.frame.width - 20
                myTextView.frame = CGRect(x:((self.view.bounds.width-width1)/2),y:10, width:width1,height:130)
                myTextView.layer.masksToBounds = true
                myTextView.layer.cornerRadius = 3.0
                myTextView.layer.borderWidth = 1
                myTextView.layer.borderColor = #colorLiteral(red: 0.7948118448, green: 0.7900883555, blue: 0.7984435558, alpha: 1)
                myTextView.textAlignment = NSTextAlignment.left


                let custombar = UIView(frame: CGRect(x:0, y:0,width:(UIScreen.main.bounds.size.width),height:40))
                custombar.backgroundColor = UIColor.groupTableViewBackground
                let commitBtn = UIButton(frame: CGRect(x:(UIScreen.main.bounds.size.width)-80,y:0,width:80,height:40))
                commitBtn.setTitle("閉じる", for: .normal)
                commitBtn.setTitleColor(UIColor.blue, for:.normal)
                commitBtn.addTarget(self, action:#selector(ProfileEditViewController.onClickCommitButton), for: .touchUpInside)
                custombar.addSubview(commitBtn)
                myTextView.inputAccessoryView = custombar
                myTextView.keyboardType = .default
                myTextView.delegate = self


                cell.addSubview(myTextView)

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
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                print("通報通報通報通報通報通報通報")
                print(ApiConfig.REPORT_LIST)
                
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
            self.pickerBottom.constant = -250
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
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String {
        
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
    
    @objc func onClickCommitButton (sender: UIButton) {
        if(myTextView.isFirstResponder){
            myTextView.resignFirstResponder()
        }
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

    /// Notification発行
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
        print("Notificationを発行")
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
    
    
    
    @IBAction func addButton(_ sender: Any) {
        print("ハッスルクエスト")
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_REPORT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["target_id"] = report_param["target_id"] as! String
        query["report_type_1"] = String(self.report_type_1)
        query["text"] = myTextView.text
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
                print("取得した値はここにきて(通報)")
                print(json)
                
//                self.dismiss(animated: true, completion: nil)
                print("！！！！！！！！！！")
                
                // アラート作成
                let alert = UIAlertController(title: "通報", message: "通報しました。", preferredStyle: .alert)
                // アラート表示
                self.present(alert, animated: true, completion: {
                    // アラートを閉じる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        alert.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true)
                    })
                })
//                self.dismiss(animated: true)
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
