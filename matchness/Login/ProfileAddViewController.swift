//
//  ProfileAddViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/07/31.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON
import Foundation

class ProfileAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileAddTableView: UITableView!
    @IBOutlet weak var datePickerBottom: NSLayoutConstraint!
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var setDateviewTime = ""
    var vi = UIView()
    var isDate = Date()
    var selectPicker: Int = 0
    var selectPickerItem: Int = 0
    var pcker_list: [String] = [""]

    var setDay = Date()
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiUserDate> = [:]
    var dataSourceOrder: Array<String> = []
    private var requestAlamofire: Alamofire.Request?;
    private var response: DataResponse<Any>?;
    let userDefaults = UserDefaults.standard
    var userProfile : NSDictionary!
    var json_data:JSON = []
    var user_id = ""


    //IDをキーにしてデータを保持
    public var responseData: Dictionary<String, ApiProfileData> = [String: ApiProfileData]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("通ってる？？？")

        profileAddTableView.delegate = self
        profileAddTableView.dataSource = self
        pickerView.dataSource = self as! UIPickerViewDataSource
        pickerView.delegate   = self as! UIPickerViewDelegate
        pickerView.showsSelectionIndicator = true

        self.profileAddTableView.register(UINib(nibName: "ProfileEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEditTableViewCell")
        self.profileAddTableView.register(UINib(nibName: "TextFiledTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFiledTableViewCell")
        self.profileAddTableView.register(UINib(nibName: "TextAreaTableViewCell", bundle: nil), forCellReuseIdentifier: "TextAreaTableViewCell")

        // datePickerの設定
        datePickerView.date = isDate
        datePickerView.datePickerMode = .date
        datePickerView.locale = Locale(identifier: "ja")
        datePickerView.addTarget(self, action: #selector(setText), for: .valueChanged)
        datePickerView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        returnUserData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("YYYYYYYYYYYYYYYY")
//        pickerView.reloadAllComponents()
//    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        print("YYYYYYYYYYYYYYYY")
//        super.viewDidAppear(animated)
//        pickerView.delegate   = self
//        pickerView.dataSource = self
//    }

    override func viewWillAppear(_ animated: Bool) {
        print("ここにこに")
        super.viewWillAppear(animated)
    }

    
    func delegate() {
        pickerView.delegate   = self as! UIPickerViewDelegate
        pickerView.dataSource = self as! UIPickerViewDataSource
    }
    
    func returnUserData()
    {
        let graphRequest : GraphRequest = GraphRequest(
            graphPath: "me",
            parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
        graphRequest.start(completionHandler: {
            (connection, result, error) -> Void in
            if ((error) != nil)
            {
                // エラー処理
                print("Error: \(error)")
            }
            else
            {
                // プロフィール情報をディクショナリに入れる
                self.userProfile = result as! NSDictionary
                print("aaaaaaaaaaaaaaaaaaaaaa")
                print(self.userProfile)
                print(self.userProfile.object(forKey: "picture") as AnyObject)
                
                /****************
                 APIへリクエスト（ユーザー取得）
                 *****************/
                //ロジック生成
                let requestProfileAddModel = ProfileAddModel();
                requestProfileAddModel.delegate = self as! ProfileAddModelDelegate;
                let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_ADD;
                
                //パラメーター
                var params: Dictionary<String,String> = Dictionary<String,String>();
                params["name"] = self.userProfile.object(forKey: "name") as? String
                params["email"] = self.userProfile.object(forKey: "email") as? String
                params["fb_id"] = self.userProfile.object(forKey: "id") as? String
                
                let headers = [
                    "Accept" : "application/json",
                    "Authorization" : "",
                    "Content-Type" : "application/x-www-form-urlencoded"
                ]
                
                self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseString{ response in
                    print("ログインリクエストTTTTTTTTT")
                    print(requestUrl)
                    print(params)
                    print("ログインUUUUUUU")
                    print(response.result)
                    print(response.data)
                    switch response.result {
                    case .success:
                        var json:JSON;
                        do{
                            //レスポンスデータを解析
                            json = try SwiftyJSON.JSON(data: response.data!);
                        } catch {
                            // error
                            print("json error: \(error.localizedDescription)");
                            break;
                        }
                        print("成功し取得した値はここにきて")
                        
                        print(json)
                        print("22222222222222222222222222")
                        let items: JSON = json["data"];
                        let recommend: JSON = items["list"];
                        for (key, item):(String, JSON) in json {
                            //データを変換
                            let data: ApiProfileData? = ApiProfileData(json: item);
                            
                            print(data)
                            
                            //Optionalチェック
                            guard let info: ApiProfileData = data else {
                                continue;
                            }
                            guard let name = info.name else {
                                continue;
                            }
                            print(info)
                            //サブカテゴリーIDをキーにして保存
                            self.responseData[key] = info;
                        }
                        self.userDefaults.set(self.responseData["0"]?.api_token, forKey: "api_token")
                        self.userDefaults.set(self.responseData["0"]?.id, forKey: "matchness_user_id")
                        self.userDefaults.set("1", forKey: "login_status")
                        self.userDefaults.synchronize()
                        print("困難でました！！！！")
                        print(self.responseData)
                        print(self.responseData["0"]?.api_token)
                        print(self.responseData["name"])
//                        print(self.responseData["birthday"])
                        self.viewPlofile()
                        
                    case .failure:
                        //  リクエスト失敗 or キャンセル時
                        print("リクエスト失敗!! or キャンセル時!!!")
                        print(response)
                    }
                }
            }
        })
        
    }
    
    
    
    func viewPlofile() {
        var pic = self.userProfile.object(forKey: "picture") as AnyObject
        var pic1:Any = pic["data"]
        print((pic1 as AnyObject).object(forKey: "url") as! String)
        let profileImageURL : String = (pic1 as AnyObject).object(forKey: "url") as! String
        //// プロフィール画像の取得（よくあるように角を丸くする）
        //let profileImageURL : String = ((self.userProfile.object(forKey: "picture") as AnyObject).object("data") as AnyObject).objectForKey("url") as! String
        
        var profileImage = UIImage(data: NSData(contentsOf: NSURL(string: profileImageURL)! as URL)! as Data)
        
        print("画像画像画像画像")
        print(profileImage)
        
        self.userImage.clipsToBounds = true
        self.userImage.layer.cornerRadius = 60
        self.userImage.image = self.trimPicture(rawPic: profileImage!)

        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        responseData["0"]?.name = self.userProfile.object(forKey: "name") as? String
        responseData["0"]?.birthday = dateFormater.string(from: isDate)
        responseData["0"]?.work = 0
        responseData["0"]?.prefecture_id = 0
        responseData["0"]?.fitness_parts_id = 0
        responseData["0"]?.weight = 0
        responseData["0"]?.sex = 0
        responseData["0"]?.blood_type = 0
        
        print("タイム2222222")
        print(responseData["0"]?.birthday)

        print("kokokokokjiijijij")
        print(self.responseData["0"])
        
        //名前とemail
        //        self.currentUserName.text = self.userProfile.object(forKey: "name") as? String
        //        self.currentUserEmail.text = self.userProfile.object(forKey: "email") as? String
        profileAddTableView.reloadData()
    }
    
    
    func trimPicture(rawPic:UIImage) -> UIImage {
        var rawImageW = rawPic.size.width
        var rawImageH = rawPic.size.height
        
        var posX = (rawImageW - 200) / 2
        var posY = (rawImageH - 200) / 2
        //        let trimArea : CGRect = CGRectMake(posX, posY, 200, 200)
        //        let trimArea = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let trimArea = CGRect(x : 0, y : 0, width : 150, height : 150)
        
        var rawImageRef:CGImage = rawPic.cgImage!
        let trimmedImageRef = rawImageRef.cropping(to: trimArea)
        var trimmedImage : UIImage = UIImage(cgImage : trimmedImageRef!)
        return trimmedImage
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 8
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "自己紹介"
        } else if (section == 1){
            return "プロフィール"
        }
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
        print("AAAAAAAAAA")
        print(indexPath)
        print(indexPath.section)
        

        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"

        print("こいいいいいい")
        print(self.responseData["0"])
        var myData = self.responseData["0"]

        if indexPath.section == 0 {
            let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "TextAreaTableViewCell") as! TextAreaTableViewCell

            cell.textLabel!.numberOfLines = 0
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.textArea.delegate = self
            cell.textArea.tag = 1
            cell.textArea?.font = UIFont.systemFont(ofSize: 14)
            cell.textArea!.text = myData?.profile_text
            return cell
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "TextFiledTableViewCell") as! TextFiledTableViewCell

                cell.title?.text = "ニックネーム"
                cell.textFiled.delegate = self
                cell.textFiled.tag = 0
                print("ニックネームニックネームニックネームニックネーム")
                cell.textFiled?.text = myData?.name
                return cell
            }
            if indexPath.row == 1 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "職業"
                cell.detail?.text = ApiConfig.WORK_LIST[myData?.work ?? 0]
                return cell
            }
            if indexPath.row == 2 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "居住地"
                cell.detail?.text = ApiConfig.PREFECTURE_LIST[myData?.prefecture_id ?? 0]
                return cell
            }
            if indexPath.row == 3 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "誕生日"
                
                let dateFormater = DateFormatter()
                dateFormater.locale = Locale(identifier: "ja_JP")
                dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"


                self.responseData["0"]?.birthday = dateFormater.string(from: self.isDate)


                let date = dateFormater.date(from: self.responseData["0"]?.birthday ?? "2016-10-03 03:12:12 +0000")

                print("タイム444444444")
                print(date)

                print("誕生日誕生日誕生日")
                dateFormater.dateFormat = "yyyy年MM月dd日"
                let date_text = dateFormater.string(from: date ?? Date())
                cell.detail?.text = String(date_text)
                return cell
            }
            
            if indexPath.row == 4 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "痩せたい部位"
                cell.detail?.text = ApiConfig.FITNESS_LIST[myData?.fitness_parts_id ?? 0]
                return cell
            }
            if indexPath.row == 5 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "体重(非公開)"
                cell.detail?.text = ApiConfig.WEIGHT_LIST[myData?.weight ?? 0]
                return cell
                
            }
            
            if indexPath.row == 6 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "性別"
                cell.detail?.text = ApiConfig.SEX_LIST[myData?.sex ?? 0]
                return cell
            }
            
            if indexPath.row == 7 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "血液型"
                cell.detail?.text = ApiConfig.BLOOD_LIST[myData?.blood_type ?? 2]
                return cell
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップタップタップタップ")
        self.pcker_list = []
        dismissPicker()
        dismissDatePicker()
        if indexPath.row == 0 {
            self.selectPicker = 0
        }
        if indexPath.row == 1 {
            self.selectPicker = 1
            self.pcker_list = ApiConfig.WORK_LIST
        }
        if indexPath.row == 2 {
            self.selectPicker = 2
            self.pcker_list = ApiConfig.PREFECTURE_LIST
        }
        if indexPath.row == 4 {
            self.selectPicker = 4
            self.pcker_list = ApiConfig.FITNESS_LIST
        }
        if indexPath.row == 5 {
            self.selectPicker = 5
            self.pcker_list = ApiConfig.WEIGHT_LIST
        }
        if indexPath.row == 6 {
            self.selectPicker = 6
            self.pcker_list = ApiConfig.SEX_LIST
        }
        if indexPath.row == 7 {
            self.selectPicker = 7
            self.pcker_list = ApiConfig.BLOOD_LIST
        }
        
        print(indexPath.section)
        print(indexPath.row)
        if indexPath.row == 3 {

            print("タイム33333333333")
            print(self.responseData["0"])

            let dateFormater = DateFormatter()
            dateFormater.locale = Locale(identifier: "ja_JP")
            dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date = dateFormater.date(from: self.responseData["0"]?.birthday ?? "2016-10-03 03:12:12 +0000")
            datePickerView.date = date!
            print("デートピッカーーーーーーーー")
            datePickerPush()


        } else {
            self.pickerView.reloadAllComponents()
            PickerPush()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func pickerSelectButton(_ sender: Any) {
        print("bbbb")
        print("セレクトピッカーセレクトピッカーセレクトピッカー")
        print(self.selectPicker)
        if self.selectPicker == 0 {

        }
        if self.selectPicker == 1 {
            self.responseData["0"]?.work = self.selectPickerItem
        }
        if self.selectPicker == 2 {
            self.responseData["0"]?.prefecture_id = self.selectPickerItem
        }
        if self.selectPicker == 3 {
            self.responseData["0"]?.work = self.selectPickerItem
        }
        if self.selectPicker == 4 {
            self.responseData["0"]?.fitness_parts_id = self.selectPickerItem
        }
        if self.selectPicker == 5 {
            self.responseData["0"]?.weight = self.selectPickerItem
        }
        if self.selectPicker == 6 {
            self.responseData["0"]?.sex = self.selectPickerItem
        }
        if self.selectPicker == 7 {
            self.responseData["0"]?.blood_type = self.selectPickerItem
        }

        profileAddTableView.reloadData()
        self.vi.removeFromSuperview()
        dismissPicker()
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
            self.profileAddTableView.updateConstraints()
            self.view.layoutIfNeeded()
        })
    }

    func dismissPicker(){
        UIView.animate(withDuration: 0.5,animations: {
            self.pickerBottom.constant = 300
            self.pickerView.updateConstraints()
            self.profileAddTableView.updateConstraints()
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func dateSelectButton(_ sender: Any) {
        print("セットセットセットセット")
        print(self.setDateviewTime)
        self.vi.removeFromSuperview()
        profileAddTableView.reloadData()
        dismissDatePicker()
    }

    @IBAction func dateCloseButton(_ sender: Any) {
        dismissDatePicker()
    }

    func datePickerPush(){
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5,animations: {
            self.datePickerBottom.constant = -280
            self.datePickerView.updateConstraints()
            self.profileAddTableView.updateConstraints()
            self.view.layoutIfNeeded()
        })
    }

    func dismissDatePicker(){
        UIView.animate(withDuration: 0.5,animations: {
            self.datePickerBottom.constant = 300
            self.datePickerView.updateConstraints()
            self.profileAddTableView.updateConstraints()
            self.view.layoutIfNeeded()
        })
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
print("1111111111111111")
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
print("2222222222222222")
        return self.pcker_list.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
print("333333333333333")
            print(self.pcker_list)
        print(row)
        return self.pcker_list[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectPickerItem = row
        print("選択ピッカー選択ピッカー選択ピッカー")
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 60
    }


    // datePickerの日付けをtextFieldのtextに反映させる
    @objc private func setText() {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.setDateviewTime = dateFormater.string(from: datePickerView.date)
        self.responseData["0"]?.birthday = self.setDateviewTime
        print("タイム１１１１１１")
        print(datePickerView.date)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("テキスト１")
        var tag = textField.tag
        print(textField.text!)
        if tag == 0 {
            self.responseData["0"]?.name = textField.text!
        }
        if tag == 1 {
            self.responseData["0"]?.profile_text = textField.text!
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var tag = textField.tag
        print(textField.text!)
        if tag == 0 {
            self.responseData["0"]?.name = textField.text!
        }
        if tag == 1 {
            self.responseData["0"]?.profile_text = textField.text!
        }

        textField.resignFirstResponder()
        return
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var tag = textField.tag
        // キーボードを閉じる
        if tag == 0 {
            self.responseData["0"]?.name = textField.text!
        }
        if tag == 1 {
            self.responseData["0"]?.profile_text = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func profileEdit(_ sender: Any) {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestProfileAddModel = ProfileAddModel();
        requestProfileAddModel.delegate = self as! ProfileAddModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_PROFILE_EDIT;
        var setData = self.responseData
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["id"] = String(self.responseData["0"]?.id ?? "0")
        query["profile_text"] = self.responseData["0"]?.profile_text
        query["name"] = self.responseData["0"]?.name
        query["birthday"] = self.responseData["0"]?.birthday
        query["work"] = String(self.responseData["0"]?.work ?? 0)
        query["age"] = String(self.responseData["0"]?.age ?? 0)
        query["sex"] = String(self.responseData["0"]?.sex ?? 0)
        query["fitness_parts_id"] = String(self.responseData["0"]?.fitness_parts_id ?? 0)
        query["blood_type"] = String(self.responseData["0"]?.blood_type ?? 0)
        query["weight"] = String(self.responseData["0"]?.weight ?? 0)
        query["prefecture_id"] = String(self.responseData["0"]?.prefecture_id ?? 0)
        
        //リクエスト実行
        if( !requestProfileAddModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        //self.performSegue(withIdentifier: "toRegistComp", sender: nil)
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


extension ProfileAddViewController : ProfileAddModelDelegate {
    func onStart(model: ProfileAddModel) {
        print("こちら/ ProfileAdd/ ProfileAddViewのonStart")
    }
    func onComplete(model: ProfileAddModel, count: Int) {
        var count: Int = 0;
        performSegue(withIdentifier: "toRegistComp", sender: nil)
    }
    func onFailed(model: ProfileAddModel) {
        print("こちら/ProfileAddModel/ProfileAddModeliewのonFailed")
    }

}
