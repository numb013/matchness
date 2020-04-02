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
import EAIntroView
import CoreMotion
import HealthKit

class ProfileAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate,UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource,EAIntroDelegate{

    @IBOutlet weak var profileAddTableView: UITableView!
    @IBOutlet weak var datePickerBottom: NSLayoutConstraint!
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    var select_pcker_list: [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
    var image_main_param:UIImage = UIImage()
    var activityIndicatorView = UIActivityIndicatorView()

    var setDateviewTime = ""
    var vi = UIView()
    var selectPicker: Int = 0
    var selectPickerItem: Int = 0
    var pcker_list: [String] = [""]
    var selectRow = 0
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiUserDate> = [:]
    var dataSourceOrder: Array<String> = []
    private var requestAlamofire: Alamofire.Request?;
    private var response: DataResponse<Any>?;
    let userDefaults = UserDefaults.standard
    var userProfile : NSDictionary!
    var json_data:JSON = []
//    var user_id = ""
    var profileImage:UIImage = UIImage()
    var image_main:String = ""
    var base64String:String = ""
    var validate = 0
    var myTextView = UITextView()
    let store = HKHealthStore()

    //IDをキーにしてデータを保持
    public var errorData: Dictionary<String, ApiErrorAlert> = [String: ApiErrorAlert]();
    public var responseData: Dictionary<String, ApiProfileData> = [String: ApiProfileData]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var login_step_1 = userDefaults.object(forKey: "login_step_1") as? String
//        if (login_step_1 != nil) {
//            print("secont最初")
//            returnUserDataSecond()
//        }
        returnUserDataSecond()
        if HKHealthStore.isHealthDataAvailable()
        {
            let readDataTypes: Set<HKObjectType> = [
             HKObjectType.quantityType(forIdentifier:HKQuantityTypeIdentifier.stepCount)!,
             HKObjectType.quantityType(forIdentifier:HKQuantityTypeIdentifier.distanceWalkingRunning)!
            ]
            // 許可されているかどうかを確認
            store.requestAuthorization(toShare: nil, read: readDataTypes as? Set<HKObjectType>) { (success, error) -> Void in
                print(success)
                print("success")
            }
        }else{
            Alert.helthError(alertNum: self.errorData, viewController: self)
            print("OUT")
        }

        if (login_step_1 == nil) {
            // チュートリアル表示
            let page1 = EAIntroPage()
            let page2 = EAIntroPage()
            let page3 = EAIntroPage()
            let page4 = EAIntroPage()

            switch (UIScreen.main.nativeBounds.height) {
            case 480:
                // iPhone,3G,3GS
                page1.bgImage = UIImage(named: "t_01")
                page2.bgImage = UIImage(named: "t_02")
                page3.bgImage = UIImage(named: "t_03")
                page4.bgImage = UIImage(named: "t_04")
                break
            case 960:
                // iPhone 4,4S
                page1.bgImage = UIImage(named: "t_01")
                page2.bgImage = UIImage(named: "t_02")
                page3.bgImage = UIImage(named: "t_03")
                page4.bgImage = UIImage(named: "t_04")
                break
            case 1136:
                // iPhone 5,5s,5c,SE
                print("heigh_3")
                page1.bgImage = UIImage(named: "t_01")
                page2.bgImage = UIImage(named: "t_02")
                page3.bgImage = UIImage(named: "t_03")
                page4.bgImage = UIImage(named: "t_04")
                break
            case 1334:
                // iPhone 6,6s,7,8
                print("heigh_4")
                page1.bgImage = UIImage(named: "t_01")
                page2.bgImage = UIImage(named: "t_02")
                page3.bgImage = UIImage(named: "t_03")
                page4.bgImage = UIImage(named: "t_04")
                break
            case 2208:
                // iPhone 6 Plus,6s Plus,7 Plus,8 Plus
                print("heigh_5")
                page1.bgImage = UIImage(named: "t_01")
                page2.bgImage = UIImage(named: "t_02")
                page3.bgImage = UIImage(named: "t_03")
                page4.bgImage = UIImage(named: "t_04")
                break
            case 2436:
                //iPhone X
                print("heigh_6")
                page1.bgImage = UIImage(named: "t_01")
                page2.bgImage = UIImage(named: "t_02")
                page3.bgImage = UIImage(named: "t_03")
                page4.bgImage = UIImage(named: "t_04")
                break
            case 1792:
                //iPhone XR
                print("heigh_7")
                page1.bgImage = UIImage(named: "t_01")
                page2.bgImage = UIImage(named: "t_02")
                page3.bgImage = UIImage(named: "t_03")
                page4.bgImage = UIImage(named: "t_04")
                break
            case 2688:
                //iPhone XR
                print("heigh_7")
                page1.bgImage = UIImage(named: "t_01")
                page2.bgImage = UIImage(named: "t_02")
                page3.bgImage = UIImage(named: "t_03")
                page4.bgImage = UIImage(named: "t_04")
                break
            default:
                print("heigh_8")
                break
            }

            let introView = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3, page4])
            introView?.skipButton.setTitle("スキップ", for: UIControl.State.normal) //スキップボタン欲しいならここで実装！
            // タップされたときのaction
            introView?.skipButton.addTarget(self,
                    action: #selector(TutorialViewController.buttonTapped(sender:)),
                    for: .touchUpInside)

            introView!.skipButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            introView!.skipButton.layer.position = CGPoint(x: 0, y:0)
//            introView!.contentMode = UIView.ContentMode.scaleAspectFit

            var width = self.view.bounds.width
            var height = self.view.bounds.height

            introView?.delegate = self
            introView?.show(in: self.view, animateDuration: 1.0)
            self.userDefaults.set("1", forKey: "login_step_1")
        }


                
        print("通ってる？？？")

        profileAddTableView.delegate = self
        profileAddTableView.dataSource = self
        pickerView.dataSource = self as! UIPickerViewDataSource
        pickerView.delegate   = self as! UIPickerViewDelegate
        pickerView.showsSelectionIndicator = true

        self.profileAddTableView.register(UINib(nibName: "ProfileEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEditTableViewCell")
        self.profileAddTableView.register(UINib(nibName: "TextFiledTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFiledTableViewCell")
        self.profileAddTableView.register(UINib(nibName: "TextAreaTableViewCell", bundle: nil), forCellReuseIdentifier: "TextAreaTableViewCell")
        self.profileAddTableView.register(UINib(nibName: "profileAddImageTableViewCell", bundle: nil), forCellReuseIdentifier: "profileAddImageTableViewCell")

        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date_is = dateFormater.date(from: "2000/01/01 00:00:00")
        
        // datePickerの設定
        datePickerView.date = date_is!
        datePickerView.datePickerMode = .date
        datePickerView.locale = Locale(identifier: "ja")
        datePickerView.addTarget(self, action: #selector(setText), for: .valueChanged)
        datePickerView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.

        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        view.addSubview(activityIndicatorView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        configureObserver()  //Notification発行
    }

    @objc func buttonTapped(sender : AnyObject) {
        self.userDefaults.set("1", forKey: "login_step_1")
        loadView()
        viewDidLoad()
    }
    
    func delegate() {
        pickerView.delegate   = self as! UIPickerViewDelegate
        pickerView.dataSource = self as! UIPickerViewDataSource
    }
    
//    func returnUserData()
//    {
//        let graphRequest : GraphRequest = GraphRequest(
//            graphPath: "me",
//            parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
//            graphRequest.start(completionHandler: {
//            (connection, result, error) -> Void in
//            if ((error) != nil)
//            {
//                // エラー処理
//                print("Error: \(error)")
//            }
//            else
//            {
//                // プロフィール情報をディクショナリに入れる
//                self.userProfile = result as! NSDictionary
//                print("aaaaaaaaaaaaaaaaaaaaaa")
//                print(self.userProfile)
//                print(self.userProfile.object(forKey: "picture") as AnyObject)
//
//                /****************
//                 APIへリクエスト（ユーザー取得）
//                 *****************/
//                //ロジック生成
//                let requestProfileAddModel = ProfileAddModel();
//                requestProfileAddModel.delegate = self as! ProfileAddModelDelegate;
//                let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_ADD;
//
//                //パラメーター
//                var params: Dictionary<String,String> = Dictionary<String,String>();
//                params["name"] = self.userProfile.object(forKey: "name") as? String
//                params["email"] = self.userProfile.object(forKey: "email") as? String
//                params["fb_id"] = self.userProfile.object(forKey: "id") as? String
//
//                let headers = [
//                    "Accept" : "application/json",
//                    "Authorization" : "",
//                    "Content-Type" : "application/x-www-form-urlencoded"
//                ]
//
//                self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseString{ response in
//                        print("ログインリクエストTTTTTTTTT")
//                        print(requestUrl)
//                        print(params)
//                        print("ログインUUUUUUU")
//                        print(response.result)
//                        print(response.data)
//                    switch response.result {
//                    case .success:
//                        var json:JSON;
//                        do{
//                            //レスポンスデータを解析
//                            json = try SwiftyJSON.JSON(data: response.data!);
//
//                        } catch {
//                            // error
//                            print(error)
//                            print("json error: \(error.localizedDescription)");
//                            break;
//                        }
//                        print("成功し取得した値はここにきて")
//
//                        print(json)
//                        print("first22222222222222222222222222")
//                        let items: JSON = json["data"];
//                        let recommend: JSON = items["list"];
//                        for (key, item):(String, JSON) in json {
//                            //データを変換
//                            let data: ApiProfileData? = ApiProfileData(json: item);
//                            print("1111first22")
//                            print(data)
//                            //Optionalチェック
//                            guard let info: ApiProfileData = data else {
//                                continue;
//                            }
//                            guard let name = info.name else {
//                                continue;
//                            }
//                            print(info)
//                            //サブカテゴリーIDをキーにして保存
//                            self.responseData[key] = info;
//                        }
//                        self.userDefaults.set(self.responseData["0"]?.api_token, forKey: "api_token")
//                        self.userDefaults.set(self.responseData["0"]?.id, forKey: "matchness_user_id")
//                        self.userDefaults.synchronize()
//
//
//                        print("first困難でました！！！！")
//                        print(self.responseData)
//
//                        if (self.responseData["0"]?.is_user == 1) {
//
//                            let storyboard: UIStoryboard = self.storyboard!
//                            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
//                            let multiple = storyboard.instantiateViewController(withIdentifier: "start")
//                            multiple.modalPresentationStyle = .fullScreen
//                            //ここが実際に移動するコードとなります
//                            self.present(multiple, animated: true, completion: nil)
//
//
//                        } else {
//
//                            print(self.responseData["0"]?.api_token)
//                            print(self.responseData["name"])
//    //                        print(self.responseData["birthday"])
//                            self.viewPlofile()
//                        }
//
//
//                    case .failure:
//                        //  リクエスト失敗 or キャンセル時
//                        print("リクエスト失敗!! or キャンセル時!!!")
//                        print(response)
//                    }
//                }
//            }
//        })
//    }



    func returnUserDataSecond() {
        print("ハッスルクエスト")
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ME;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var headers: [String : String] = [:]
        var api_key = userDefaults.object(forKey: "api_token") as? String

        if ((api_key) != nil) {
            headers = [
                "Accept" : "application/json",
                "Authorization" : "Bearer " + api_key!,
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }

        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
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
                self.viewPlofile()

            case .failure:
                //  リクエスト失敗 or キャンセル時
                print("リクエスト失敗 or キャンセル時22")
                return;
            }
        }
    }
    
    func viewPlofile() {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date_is = dateFormater.date(from: "2000/01/01 00:00:00")

        responseData["0"]?.name = ""
        responseData["0"]?.birthday = dateFormater.string(from: date_is!)
        responseData["0"]?.work = 0
        responseData["0"]?.prefecture_id = 0
        responseData["0"]?.fitness_parts_id = 0
        responseData["0"]?.weight = 4 //デフォルト4
        responseData["0"]?.sex = 0
        responseData["0"]?.blood_type = 0
        profileAddTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 6
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1){
            return "プロフィール"
        } else if (section == 0) {
            return "画像"
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
            let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "profileAddImageTableViewCell") as! profileAddImageTableViewCell
//            var profileImageURL = userDefaults.object(forKey: "profileImageURL") as? String
            
            
            if (self.image_main_param.size.width != 0) {
                cell.mainImage.image = self.image_main_param
            } else {
                cell.mainImage.image = UIImage(named: "no_image")
            }
                

//            if (self.image_main_param.size.width != 0) {
//                cell.mainImage.image = self.image_main_param
//            } else if (profileImageURL == nil) {
//                var pic = self.userProfile.object(forKey: "picture") as AnyObject
//                var pic1:Any = pic["data"]
//                print((pic1 as AnyObject).object(forKey: "url") as! String)
//                let profileImageURL : String = "http://k.yimg.jp/images/top/sp2/cmn/logo-ns-131205.png"
//    //            let profileImageURL : String = (pic1 as AnyObject).object(forKey: "url") as! String
//                self.userDefaults.set(profileImageURL, forKey: "profileImageURL")
//                self.profileImage = UIImage(data: NSData(contentsOf: NSURL(string: profileImageURL)! as URL)! as Data)!
//                cell.mainImage.image = self.profileImage
//            } else {
//                //            let profileImageURL : String = (userDefaults.object(forKey: "profileImageURL") as? String)!
//                let profileImageURL : String = "http://k.yimg.jp/images/top/sp2/cmn/logo-ns-131205.png"
//                self.profileImage = UIImage(data: NSData(contentsOf: NSURL(string: profileImageURL)! as URL)! as Data)!
//                cell.mainImage.image = self.profileImage
//                cell.mainImage.image = UIImage(named: "no_image")
//            }


            cell.mainImage.isUserInteractionEnabled = true
            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage(_:)))
//            recognizer.targetUserId = Int(message.target_id!)
            cell.mainImage.addGestureRecognizer(recognizer)
            return cell
        }

        if indexPath.section == 1 {

            if indexPath.row == 0 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "TextFiledTableViewCell") as! TextFiledTableViewCell
                cell.title?.text = "* ニックネーム "
                cell.textFiled.delegate = self
                cell.textFiled.tag = 0
                cell.textFiled.placeholder = "※15文字まで"
                print("ニックネームニックネームニックネームニックネーム")
                cell.textFiled?.text = myData?.name
                return cell
            }
            if indexPath.row == 1 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                self.select_pcker_list[indexPath.row] = myData?.sex ?? 0
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "* 性別"
                cell.detail?.text = ApiConfig.SEX_LIST[myData?.sex ?? 0]
                return cell
            }

            if indexPath.row == 2 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "* 誕生日"
                let dateFormater = DateFormatter()
                dateFormater.locale = Locale(identifier: "ja_JP")
                dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let date = dateFormater.date(from: self.responseData["0"]?.birthday ?? "2000/01/01 00:00:00")
                dateFormater.dateFormat = "yyyy年MM月dd日"
                let date_text = dateFormater.string(from: date!)
                cell.detail?.text = String(date_text)
                return cell
            }
            
            if indexPath.row == 3 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                self.select_pcker_list[indexPath.row] = myData?.fitness_parts_id ?? 0
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "* 痩せたい箇所"
                cell.detail?.text = ApiConfig.FITNESS_LIST[myData?.fitness_parts_id ?? 0]
                return cell
            }
            if indexPath.row == 4 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                self.select_pcker_list[indexPath.row] = myData?.weight ?? 4
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "* 体重(非公開)"
                cell.detail?.text = ApiConfig.WEIGHT_LIST[myData?.weight ?? 4] + "kg"
                return cell
            }
            if indexPath.row == 5 {
                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                self.select_pcker_list[indexPath.row] = myData?.prefecture_id ?? 0
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "* 居住地"
                cell.detail?.text = ApiConfig.PREFECTURE_LIST[myData?.prefecture_id ?? 0]
                return cell
            }
//            if indexPath.row == 6 {
//                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
//                self.select_pcker_list[indexPath.row] = myData?.blood_type ?? 0
//                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
//                cell.title?.text = "* 血液型"
//                cell.detail?.text = ApiConfig.BLOOD_LIST[myData?.blood_type ?? 0]
//                return cell
//            }
//            if indexPath.row == 7 {
//                let cell = profileAddTableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
//                self.select_pcker_list[indexPath.row] = myData?.work ?? 0
//                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
//                cell.title?.text = "* 職業"
//                cell.detail?.text = ApiConfig.WORK_LIST[myData?.work ?? 0]
//                return cell
//            }


        }
        
//        if indexPath.section == 2 {
//            let width1 = self.view.frame.width - 20
//            myTextView.frame = CGRect(x:((self.view.bounds.width-width1)/2),y:10, width:width1,height:140)
//            myTextView.layer.masksToBounds = true
//            myTextView.layer.cornerRadius = 3.0
//            myTextView.layer.borderWidth = 1
//            myTextView.layer.borderColor = #colorLiteral(red: 0.7948118448, green: 0.7900883555, blue: 0.7984435558, alpha: 1)
//            myTextView.textAlignment = NSTextAlignment.left
//
//            let custombar = UIView(frame: CGRect(x:0, y:0,width:(UIScreen.main.bounds.size.width),height:40))
//            custombar.backgroundColor = UIColor.groupTableViewBackground
//            let commitBtn = UIButton(frame: CGRect(x:(UIScreen.main.bounds.size.width)-80,y:0,width:80,height:40))
//            commitBtn.setTitle("閉じる", for: .normal)
//            commitBtn.setTitleColor(UIColor.blue, for:.normal)
//            commitBtn.addTarget(self, action:#selector(ProfileEditViewController.onClickCommitButton), for: .touchUpInside)
//            custombar.addSubview(commitBtn)
//            myTextView.inputAccessoryView = custombar
//            myTextView.keyboardType = .default
//            myTextView.delegate = self
//
//            cell.addSubview(myTextView)
//            return cell
//        }
        
        return cell
    }
    
    @objc func onTapImage(_ sender: MyTapGestureRecognizer) {
        print("画像タップ")
        selectImage()
    }

    
    private func selectImage() {
        let alertController: UIAlertController = UIAlertController(title: "アラート表示", message: "保存してもいいですか？", preferredStyle:  UIAlertController.Style.alert)
        //        let alertController = UIAlertController(title: "画像を選択", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラを起動", style: .default) { (UIAlertAction) -> Void in
            self.selectFromCamera()
        }
        let libraryAction = UIAlertAction(title: "カメラロールから選択", style: .default) { (UIAlertAction) -> Void in
            self.selectFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func selectFromCamera() {
        print("カメラ許可")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラ許可をしていない時の処理")
        }
    }
    
    private func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 50% に縮小
        let resizedImage = self.resizeImage(image: info[UIImagePickerController.InfoKey.editedImage] as! UIImage, ratio: 0.5)
//        let imageData = NSData(data: (resizedImage).pngData()!) as NSData
//        self.userImage.image = resizedImage
        self.image_main_param = resizedImage
        let jpegCompressionQuality: CGFloat = 0.9 // Set this to whatever suits your purpose


        self.base64String = (resizedImage.jpegData(compressionQuality: jpegCompressionQuality)?.base64EncodedString())!
        // Upload base64String to your database
        print("gagagagagagagagagagag")
        print(base64String)
        self.image_main = self.base64String
        print("trtrtrtrtrtrtrtrtrtrtrt")
//        print(base64String)

        profileAddTableView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 画像を指定された比率に縮小
    func resizeImage(image: UIImage, ratio: CGFloat) -> UIImage {
        let size = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x:0, y:0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
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
            self.pcker_list = ApiConfig.SEX_LIST
            self.selectRow = self.responseData["0"]?.sex ?? 0
        }
        if indexPath.row == 3 {
            self.selectPicker = 3
            self.pcker_list = ApiConfig.FITNESS_LIST
            self.selectRow = self.responseData["0"]?.fitness_parts_id ?? 0
        }
        if indexPath.row == 4 {
            self.selectPicker = 4
            self.pcker_list = ApiConfig.WEIGHT_LIST
            self.selectRow = self.responseData["0"]?.weight ?? 4
        }
        if indexPath.row == 5 {
            self.selectPicker = 5
            self.pcker_list = ApiConfig.PREFECTURE_LIST
            self.selectRow = self.responseData["0"]?.prefecture_id ?? 0
        }
//        if indexPath.row == 6 {
//            self.selectPicker = 6
//            self.pcker_list = ApiConfig.BLOOD_LIST
//            self.selectRow = self.responseData["0"]?.blood_type ?? 0
//        }
//        if indexPath.row == 7 {
//            self.selectPicker = 7
//            self.pcker_list = ApiConfig.WORK_LIST
//            self.selectRow = self.responseData["0"]?.work ?? 0
//        }
        
        print(indexPath.section)
        print(indexPath.row)
        if indexPath.row == 2 {
            print("タイム33333333333")
            print(self.responseData["0"])
            let dateFormater = DateFormatter()
            dateFormater.locale = Locale(identifier: "ja_JP")
            dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date = dateFormater.date(from: self.responseData["0"]?.birthday ?? "2000/01/01 00:00:00")
            datePickerView.date = date!
            print("デートピッカーーーーーーーー")
            datePickerPush()
        } else {
            if (indexPath.row != 0) {
                pickerView.selectRow(self.selectRow, inComponent: 0, animated: false)
                self.pickerView.reloadAllComponents()
                PickerPush()
            }
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
            self.responseData["0"]?.sex = self.select_pcker_list[self.selectPicker] ?? 0
        }
        if self.selectPicker == 3 {
            self.responseData["0"]?.fitness_parts_id = self.select_pcker_list[self.selectPicker] ?? 0
        }
        if self.selectPicker == 4 {
            self.responseData["0"]?.weight = self.select_pcker_list[self.selectPicker] ?? 4
        }
        if self.selectPicker == 5 {
            self.responseData["0"]?.prefecture_id = self.select_pcker_list[self.selectPicker] ?? 0
        }
//        if self.selectPicker == 6 {
//            self.responseData["0"]?.work = self.select_pcker_list[self.selectPicker] ?? 0
//        }
//        if self.selectPicker == 7 {
//            self.responseData["0"]?.blood_type = self.select_pcker_list[self.selectPicker] ?? 0
//        }

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
            self.pickerBottom.constant = -250
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
            self.datePickerBottom.constant = -250
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
        if (self.pcker_list.count > row) {
            if (self.selectPicker == 4) {
                return self.pcker_list[row] + "kg"
            } else {
                return self.pcker_list[row]
            }
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else if indexPath.section == 2 {
            return 400
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
        self.responseData["0"]?.name = textField.text!
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var tag = textField.tag
        self.responseData["0"]?.name = textField.text!
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
        // キーボードを閉じる
        self.responseData["0"]?.name = textField.text!
        textField.resignFirstResponder()
        return true
    }
//
//    /// Notification発行
//    func configureObserver() {
//        let notification = NotificationCenter.default
//        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),name: UIResponder.keyboardWillShowNotification, object: nil)
//        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),name: UIResponder.keyboardWillHideNotification, object: nil)
//        print("Notificationを発行")
//    }

//    /// キーボードが表示時に画面をずらす。
//    @objc func keyboardWillShow(_ notification: Notification?) {
//        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
//            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
//        UIView.animate(withDuration: duration) {
//            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
//            self.view.transform = transform
//        }
//        print("keyboardWillShowを実行")
//    }
//
//    /// キーボードが降りたら画面を戻す
//    @objc func keyboardWillHide(_ notification: Notification?) {
//        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
//        UIView.animate(withDuration: duration) {
//            self.view.transform = CGAffineTransform.identity
//        }
//        print("keyboardWillHideを実行")
//    }
//    
    
   
    func validator(){
//        ActivityIndicator.stopAnimating()
        self.activityIndicatorView.stopAnimating()
        // アラート作成

        if (self.validate == 3) {
            let alert = UIAlertController(title: "入力エラー", message: "プロフィール画像を選択して下さい", preferredStyle: .alert)
            // アラート表示
            self.present(alert, animated: true, completion: {
                // アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    alert.dismiss(animated: true, completion: nil)
                    self.validate = 0
                })
            })
        } else if (self.validate == 2) {
            let alert = UIAlertController(title: "入力エラー", message: "ニックネームは15文字までになります", preferredStyle: .alert)
            // アラート表示
            self.present(alert, animated: true, completion: {
                // アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    alert.dismiss(animated: true, completion: nil)
                    self.validate = 0
                })
            })
        } else {
            let alert = UIAlertController(title: "全て必須項目になります", message: "選択されていない項目があります", preferredStyle: .alert)
            // アラート表示
            self.present(alert, animated: true, completion: {
                // アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    alert.dismiss(animated: true, completion: nil)
                    self.validate = 0
                })
            })
        }
    }
    
    
    @IBAction func profileEdit(_ sender: Any) {

        activityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .default).async {
            // 非同期処理などを実行
            Thread.sleep(forTimeInterval: 5)
            // 非同期処理などが終了したらメインスレッドでアニメーション終了
            DispatchQueue.main.async {
                // アニメーション終了
                self.activityIndicatorView.stopAnimating()
            }
        }
        
        
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
        query["profile_text"] = myTextView.text
        query["name"] = self.responseData["0"]?.name
        query["birthday"] = self.responseData["0"]?.birthday
//        query["work"] = String(self.responseData["0"]?.work ?? 0)
        query["sex"] = String(self.responseData["0"]?.sex ?? 0)
        query["fitness_parts_id"] = String(self.responseData["0"]?.fitness_parts_id ?? 0)
//        query["blood_type"] = String(self.responseData["0"]?.blood_type ?? 0)
        query["weight"] = String(self.responseData["0"]?.weight ?? 4)
        query["prefecture_id"] = String(self.responseData["0"]?.prefecture_id ?? 0)
        query["image_main"] = self.image_main

        
        if (query["image_main"] == "") {
            self.validate = 3
            validator()
        }
        
        if (query["name"]!.count > 15) {
            self.validate = 2
            validator()
        }

//        if (query["work"] == "0") {
//            self.validate = 1
//            validator()
//        }
        if (query["sex"] == "0") {
            self.validate = 1
            validator()
        }
        if (query["fitness_parts_id"] == "0") {
            self.validate = 1
            validator()
        }
//        if (query["blood_type"] == "0") {
//            self.validate = 1
//            validator()
//        }
        if (query["prefecture_id"] == "0") {
            self.validate = 1
            validator()
        }
        
        
print("作成作成作成作成作成作成作成")
print(query)

        
        if (self.validate == 0) {
            //リクエスト実行
            if( !requestProfileAddModel.requestApi(url: requestUrl, addQuery: query) ){
                
            }

        }
        //self.performSegue(withIdentifier: "toRegistComp", sender: nil)
    }
    
    func completeJamp() {
//        ActivityIndicator.stopAnimating()
        self.activityIndicatorView.stopAnimating()
        self.performSegue(withIdentifier: "toRegistComp", sender: nil)
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
        self.userDefaults.set("1", forKey: "login_step_2")
        print("スターーーーーーーーーと")
        completeJamp()
    }

    func onFailed(model: ProfileAddModel) {
        print("こちら/ProfileAddModel/ProfileAddModeliewのonFailed")
    }

    func onError(model: ProfileAddModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }

}
