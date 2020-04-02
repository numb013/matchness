//
//  ProfileEditViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/08.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import FirebaseStorage
import SDWebImage

class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let userDefaults = UserDefaults.standard
    @IBOutlet weak var UserProfileTable: UITableView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!
    @IBOutlet weak var detaPickerBottom: NSLayoutConstraint!
    var setDateviewTime = ""
    var vi = UIView()
    var isDate = Date()
    var selectPicker: Int = 0
    var selectPickerItem: Int = 0
    var select_pcker_list: [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
    var pcker_list: [String] = []
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiUserDetailDate> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    var delete_str = ""
    var editType: Int = 0
    var selectRow = 0
    var selectTextFild = 0
    var scroll = 0
//    var ActivityIndicator: UIActivityIndicatorView!
    var image_type = ""

    var activityIndicatorView = UIActivityIndicatorView()
    
    var image_main_param:UIImage = UIImage()
//    var image_1_param:UIImage = UIImage()
//    var image_2_param:UIImage = UIImage()
//    var image_3_param:UIImage = UIImage()
//    var image_4_param:UIImage = UIImage()

    var image_main:String = ""
//    var image_1:String = ""
//    var image_2:String = ""
//    var image_3:String = ""
//    var image_4:String = ""
    var base64String:String = ""
    var myTextView = UITextView()
    var validate = 0
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;

    override func viewDidLoad() {
        super.viewDidLoad()
        UserProfileTable.delegate = self
        UserProfileTable.dataSource = self
        // Do any additional setup after loading the view.
        pickerView.delegate   = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        myTextView.delegate = self
        
        myTextView.tag = 1111111
        
        self.UserProfileTable.register(UINib(nibName: "ProfileEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEditTableViewCell")
        self.UserProfileTable.register(UINib(nibName: "TextFiledTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFiledTableViewCell")
        self.UserProfileTable.register(UINib(nibName: "TextAreaTableViewCell", bundle: nil), forCellReuseIdentifier: "TextAreaTableViewCell")
        self.UserProfileTable.register(UINib(nibName: "ProfilImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfilImageTableViewCell")

        // datePickerの設定
        datePickerView.date = isDate
        datePickerView.datePickerMode = .date
        datePickerView.locale = Locale(identifier: "ja")
        datePickerView.addTarget(self, action: #selector(setText), for: .valueChanged)
        datePickerView.backgroundColor = UIColor.white

        
        //        view.backgroundColor = .lightGray
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        view.addSubview(activityIndicatorView)
        
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestProfileEditModel = ProfileEditModel();
        requestProfileEditModel.delegate = self as! ProfileEditModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_INFO;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var api_key = userDefaults.object(forKey: "api_token") as? String
        query["api_token"] = api_key
        //リクエスト実行
        if( !requestProfileEditModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        print("マイデータ")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()  //Notification発行
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        print("EEWEWEEEEEEEEEEEEEEEEEE")
//        print(scrollView.contentOffset.y)
//        if (scrollView.contentOffset.y  > 300) {
//            print("MMMMMMMMMMMMMMMMMMM")
//            self.scroll = 1
//        } else {
//            self.scroll = 0
//        }
//        print(self.scroll)
//    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 2 {
            return 1
        } else if section == 1 {
            return 8
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "画像"
        } else if (section == 2){
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
        
        print("こいいいいいい")
        print(self.dataSource)
        var myData = self.dataSource["0"]

        if indexPath.section == 0 {
            print("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ")
            
            let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfilImageTableViewCell") as! ProfilImageTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if (myData != nil) {
            //メイン画像
                if (self.image_main_param.size.width != 0) {
                    cell.mainImage.image = self.image_main_param
                } else if (myData!.profile_image[0].id != nil) {
                    let profileImageURL = image_url  + myData!.profile_image[0].path!
                    let url = NSURL(string: profileImageURL);
                    let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
                    cell.mainImage.image = UIImage(data:imageData! as Data)
                }
            } else {
                cell.mainImage.image = UIImage(named: "no_image")
            }
            cell.mainImage.isUserInteractionEnabled = true
            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTapMainImage(_:)))
            recognizer.targetString = "0"
            cell.mainImage.addGestureRecognizer(recognizer)

//
//            //サブ1画像
//            if (myData != nil) {
//                if (self.image_1_param.size.width != 0) {
//                    cell.image_1.image = self.image_1_param
//                } else if (myData!.profile_image[1].id != nil) {
//                    let profileImageURL = image_url + myData!.profile_image[1].path!
//                    let url = NSURL(string: profileImageURL);
//                    let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
//                    cell.image_1.image = UIImage(data:imageData! as Data)
//                } else {
//                    cell.image_1.image = UIImage(named: "no_image")
//                }
//            } else {
//                cell.image_1.image = UIImage(named: "no_image")
//            }
//            cell.image_1.isUserInteractionEnabled = true
//            var recognizer_1 = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage_1(_:)))
//            recognizer_1.targetString = "1"
//            cell.image_1.addGestureRecognizer(recognizer_1)
//
//
//
//            //サブ2画像
//            if (myData != nil) {
//                print("DDDDDDDDDD")
//                print(myData!.profile_image[2].id)
//
//                if (self.image_2_param.size.width != 0) {
//                    cell.image_2.image = self.image_2_param
//                } else if (myData!.profile_image[2].id != nil) {
//                    let profileImageURL = image_url + myData!.profile_image[2].path!
//                    let url = NSURL(string: profileImageURL);
//                    let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
//                    cell.image_2.image = UIImage(data:imageData! as Data)
//                } else {
//                    cell.image_2.image = UIImage(named: "no_image")
//                }
//            } else {
//                print("GGGGGGGGGGGGGGGGGG")
//                cell.image_2.image = UIImage(named: "no_image")
//            }
//            cell.image_2.isUserInteractionEnabled = true
//            var recognizer_2 = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage_2(_:)))
//            recognizer_2.targetString = "2"
//            cell.image_2.addGestureRecognizer(recognizer_2)
//
//            //サブ3画像
//            if (myData != nil) {
//                if (self.image_3_param.size.width != 0) {
//                    cell.image_3.image = self.image_3_param
//                } else if (myData!.profile_image[3].id != nil) {
//                    let profileImageURL = image_url + myData!.profile_image[3].path!
//                    let url = NSURL(string: profileImageURL);
//                    let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
//                    cell.image_3.image = UIImage(data:imageData! as Data)
//                } else {
//                    cell.image_3.image = UIImage(named: "no_image")
//                }
//            } else {
//                cell.image_3.image = UIImage(named: "no_image")
//            }
//            cell.image_3.isUserInteractionEnabled = true
//            var recognizer_3 = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage_3(_:)))
//            recognizer_3.targetString = "3"
//            cell.image_3.addGestureRecognizer(recognizer_3)
//
//            //サブ4画像
//            if (myData != nil) {
//                if (self.image_4_param.size.width != 0) {
//                    cell.image_4.image = self.image_4_param
//                } else if (myData!.profile_image[4].id != nil) {
//                    let profileImageURL = image_url + myData!.profile_image[4].path!
//                    let url = NSURL(string: profileImageURL);
//                    let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
//                    cell.image_4.image = UIImage(data:imageData! as Data)
//                } else {
//                    cell.image_4.image = UIImage(named: "no_image")
//                }
//            } else {
//                cell.image_4.image = UIImage(named: "no_image")
//            }
//            cell.image_4.isUserInteractionEnabled = true
//            var recognizer_4 = MyTapGestureRecognizer(target: self, action: #selector(self.onTapImage_4(_:)))
//            recognizer_4.targetString = "4"
//            cell.image_4.addGestureRecognizer(recognizer_4)

            return cell
        }
        
        if indexPath.section == 2 {
            myTextView.text = myData?.profile_text
            let width1 = self.view.frame.width - 20
            myTextView.frame = CGRect(x:((self.view.bounds.width-width1)/2),y:10, width:width1,height:140)
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

        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "TextFiledTableViewCell") as! TextFiledTableViewCell
                cell.title?.text = "ニックネーム ※15文字まで"
                cell.textFiled.delegate = self
                cell.textFiled?.text = myData?.name
                cell.selectionStyle = .none
                return cell
            }

            if indexPath.row == 1 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                self.select_pcker_list[indexPath.row] = myData?.sex ?? 0
//                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "性別"
                cell.detail?.text = ApiConfig.SEX_LIST[myData?.sex ?? 0]
                return cell
            }

            if indexPath.row == 2 {
              let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

              cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
              cell.title?.text = "誕生日"

              let dateFormater = DateFormatter()
              dateFormater.locale = Locale(identifier: "ja_JP")
              dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
              let date = dateFormater.date(from: self.dataSource["0"]?.birthday ?? "2000-01-01 03:12:12 +0000")
              print("誕生日誕生日誕生日")

              dateFormater.dateFormat = "yyyy年MM月dd日"
              let date_text = dateFormater.string(from: date ?? Date())
              
              cell.detail?.text = String(date_text)
              return cell
            }
            if indexPath.row == 3 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                self.select_pcker_list[indexPath.row] = myData?.fitness_parts_id ?? 0
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "痩せたい箇所"
                cell.detail?.text = ApiConfig.FITNESS_LIST[myData?.fitness_parts_id ?? 0]
                return cell
            }
            if indexPath.row == 4 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                self.select_pcker_list[indexPath.row] = myData?.weight ?? 0

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "体重(非公開)"
                cell.detail?.text = ApiConfig.WEIGHT_LIST[myData?.weight ?? 0] + "kg"
                return cell
            }
            
            if indexPath.row == 5 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                self.select_pcker_list[indexPath.row] = myData?.prefecture_id ?? 0
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "居住地"
                cell.detail?.text = ApiConfig.PREFECTURE_LIST[myData?.prefecture_id ?? 0]
                return cell
            }

            if indexPath.row == 6 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                self.select_pcker_list[indexPath.row] = myData?.blood_type ?? 0
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "血液型"
                cell.detail?.text = ApiConfig.BLOOD_LIST[myData?.blood_type ?? 2]
                return cell
            }

            if indexPath.row == 7 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell
                self.select_pcker_list[indexPath.row] = myData?.work ?? 0
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "職業"
                cell.detail?.text = ApiConfig.WORK_LIST[myData?.work ?? 0]
                return cell
            }

        }
        return cell
    }

    
    @objc func onTapMainImage(_ sender: MyTapGestureRecognizer) {
        print("画像タップmain")
        self.image_type = sender.targetString!
        selectImage(image_type: image_type)
    }
//
//    @objc func onTapImage_1(_ sender: MyTapGestureRecognizer) {
//        print("画像タップ1")
//        self.image_type = sender.targetString!
//        selectImage(image_type: image_type)
//    }
//    @objc func onTapImage_2(_ sender: MyTapGestureRecognizer) {
//        print("画像タップ2")
//        self.image_type = sender.targetString!
//        selectImage(image_type: image_type)
//    }
//    @objc func onTapImage_3(_ sender: MyTapGestureRecognizer) {
//        print("画像タップ3")
//        self.image_type = sender.targetString!
//        selectImage(image_type: image_type)
//    }
//    @objc func onTapImage_4(_ sender: MyTapGestureRecognizer) {
//        print("画像タップ4")
//        self.image_type = sender.targetString!
//        selectImage(image_type: image_type)
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップ")
        print(indexPath.row)

        dismissPicker()
        dismissDatePicker()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                print("カメラ")
                selectImage(image_type: "11")
                // self.selectPicker = 0
            }
        }
//        if indexPath.row == 1 {
//            self.selectPicker = 1
//            self.pcker_list = ApiConfig.SEX_LIST
//            self.selectRow = self.dataSource["0"]?.sex ?? 0
//        }
        if indexPath.row == 3 {
            self.selectPicker = 3
            self.pcker_list = ApiConfig.FITNESS_LIST
            self.selectRow = self.dataSource["0"]?.fitness_parts_id ?? 0
        }
        if indexPath.row == 4 {
            self.selectPicker = 4
            self.pcker_list = ApiConfig.WEIGHT_LIST
            self.selectRow = self.dataSource["0"]?.weight ?? 0
        }
        if indexPath.row == 5 {
            self.selectPicker = 5
            self.pcker_list = ApiConfig.PREFECTURE_LIST
            self.selectRow = self.dataSource["0"]?.prefecture_id ?? 0
        }
        if indexPath.row == 6 {
            self.selectPicker = 6
            self.pcker_list = ApiConfig.BLOOD_LIST
            self.selectRow = self.dataSource["0"]?.blood_type ?? 0
        }
        if indexPath.row == 7 {
            self.selectPicker = 7
            self.pcker_list = ApiConfig.WORK_LIST
            self.selectRow = self.dataSource["0"]?.work ?? 0
            print("都道府県タップタップタップタップタップ")
            print(self.dataSource["0"]?.work)
            print(self.selectRow)
        }

        print(indexPath.section)
        print(indexPath.row)

        if indexPath.row == 2 {
            let dateFormater = DateFormatter()
            dateFormater.locale = Locale(identifier: "ja_JP")
            dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            print("デートピッカーーーーーーーー")
            print(self.dataSource["0"]?.birthday)
            let date = dateFormater.date(from: self.dataSource["0"]?.birthday ?? "2000-01-01 03:12:12 +0000")
            datePickerView.date = date!

            datePickerPush()
        } else if indexPath.row != 0 && indexPath.row != 1 {
            print("ピッカーーーーーーーー")
            pickerView.selectRow(self.selectRow, inComponent: 0, animated: false)
            PickerPush()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 500
//        } else if indexPath.section == 2 {
//            return 160
//        }
//        return 60
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 1 {
                return 60
            }
            if indexPath.section == 2 {
                return 160
            }
        return 370
//        tableView.estimatedRowHeight = 300 //セルの高さ
//        return UITableView.automaticDimension //自動設定
     }
    
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return nil
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                return nil
            } else {
                return indexPath
            }
        } else {
            return indexPath
        }

//        switch indexPath.row {
//            case 0:
//                return indexPath
//            // 選択不可にしたい場合は"nil"を返す
//            case 1:
//                return nil
//
//            default:
//                return indexPath
//        }
    }
    
    @IBAction func pickerSelectButton(_ sender: Any) {
        print("セレクトピッカーセレクトピッカーbbbb")
        print("セレクトピッカー")
        print(self.selectPicker)
//        if self.selectPicker == 1 {
//            self.dataSource["0"]?.sex = self.select_pcker_list[self.selectPicker] ?? 0
//        }
//        if self.selectPicker == 3 {
//            self.dataSource["0"]?.work = self.select_pcker_list[self.selectPicker] ?? 0
//        }
        if self.selectPicker == 3 {
            self.dataSource["0"]?.fitness_parts_id = self.select_pcker_list[self.selectPicker] ?? 0
        }
        if self.selectPicker == 4 {
            self.dataSource["0"]?.weight = self.select_pcker_list[self.selectPicker] ?? 0
        }

        if self.selectPicker == 5 {
            self.dataSource["0"]?.prefecture_id = self.select_pcker_list[self.selectPicker] ?? 0
        }

        if self.selectPicker == 6 {
            self.dataSource["0"]?.blood_type = self.select_pcker_list[self.selectPicker] ?? 0
        }
        if self.selectPicker == 7 {
            self.dataSource["0"]?.work = self.select_pcker_list[self.selectPicker] ?? 0
        }
        dismissPicker()
        UserProfileTable.reloadData()
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
            self.UserProfileTable.updateConstraints()
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissPicker(){
        UIView.animate(withDuration: 0.5,animations: {
            self.pickerBottom.constant = 300
            self.pickerView.updateConstraints()
            self.UserProfileTable.updateConstraints()
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func dateSelectButton(_ sender: Any) {
        print("セットセットセットセット")
        print(self.setDateviewTime)
        self.vi.removeFromSuperview()
        UserProfileTable.reloadData()
        dismissDatePicker()
    }
    @IBAction func dateCloseButton(_ sender: Any) {
        dismissDatePicker()
    }

    func datePickerPush(){
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5,animations: {
            self.detaPickerBottom.constant = -280
            self.datePickerView.updateConstraints()
            self.UserProfileTable.updateConstraints()
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissDatePicker(){
        UIView.animate(withDuration: 0.5,animations: {
            self.detaPickerBottom.constant = 300
            self.datePickerView.updateConstraints()
            self.UserProfileTable.updateConstraints()
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
        print(self.selectPicker)
        print(self.pcker_list.count)
        print(row)
        if (self.selectPicker == 4) {
            return self.pcker_list[row] + "kg"
        }

        if (self.pcker_list.count > row) {
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
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.setDateviewTime = dateFormater.string(from: datePickerView.date)
        self.dataSource["0"]?.birthday = self.setDateviewTime
        print(datePickerView.date)
    }

    
    func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("テキスト１")
        print(textView.text)
        var tag = textView.tag
        print(tag)
        print(textView.text!)
        if tag == 0 {
            self.dataSource["0"]?.name = textView.text!
        }
        if tag == 1 {
            self.dataSource["0"]?.profile_text = textView.text!
        }
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


    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("ガガガがガガガがガガガがガガガがガガガがガガガが")
        print(textField.tag)
        self.selectTextFild = 1
    }


    /// キーボードが表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        dismissPicker()
        dismissDatePicker()
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            print(duration)
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.view.transform = transform
            self.selectTextFild = 0
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func onClickCommitButton (sender: UIButton) {
        if(myTextView.isFirstResponder){
            myTextView.resignFirstResponder()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("テキスト１")
        var tag = textField.tag
        self.dataSource["0"]?.name = textField.text!
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var tag = textField.tag
        self.dataSource["0"]?.name = textField.text!
        textField.resignFirstResponder()
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        self.dataSource["0"]?.name = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    func validator(){
        self.activityIndicatorView.stopAnimating()
        // アラート作成
        if (self.validate == 2) {
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
    
    @IBAction func editProfilButton(_ sender: Any) {
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

        self.editType = 1
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestProfileEditModel = ProfileEditModel();
        requestProfileEditModel.delegate = self as! ProfileEditModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_PROFILE_UPDATE;

        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["id"] = String(self.dataSource["0"]?.id ?? 0)
        query["profile_text"] = self.myTextView.text
        query["name"] = self.dataSource["0"]?.name
        query["birthday"] = self.dataSource["0"]?.birthday
        query["work"] = String(self.dataSource["0"]?.work ?? 0)
        query["sex"] = String(self.dataSource["0"]?.sex ?? 0)
        query["fitness_parts_id"] = String(self.dataSource["0"]?.fitness_parts_id ?? 0)
        query["blood_type"] = String(self.dataSource["0"]?.blood_type ?? 0)
        query["weight"] = String(self.dataSource["0"]?.weight ?? 0)
        query["prefecture_id"] = String(self.dataSource["0"]?.prefecture_id ?? 0)
        query["edit"] = "1"
        query["delete_image"] = self.delete_str
//        query["profile_image"] = str.extend(self.dataSource["0"]!.profile_image)

        query["image_main"] = self.image_main
//        query["image_1"] = self.image_1
//        query["image_2"] = self.image_2
//        query["image_3"] = self.image_3
//        query["image_4"] = self.image_4

        if (query["name"]!.count > 15) {
            self.validate = 2
            validator()
        }
//
//        if (query["work"] == "0") {
//            self.validate = 1
//            validator()
//        }
//        if (query["sex"] == "0") {
//            self.validate = 1
//            validator()
//        }
//        if (query["fitness_parts_id"] == "0") {
//            self.validate = 1
//            validator()
//        }
//        if (query["blood_type"] == "0") {
//            self.validate = 1
//            validator()
//        }
//        if (query["prefecture_id"] == "0") {
//            self.validate = 1
//            validator()
//        }
        
        if (self.validate == 0) {
            //リクエスト実行
            if( !requestProfileEditModel.requestApi(url: requestUrl, addQuery: query) ){
                
            }
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

    
    
//    //添付ファイルボタンが押された時の挙動
//    override func didPressAccessoryButton(_ sender: UIButton!) {
//        print("カメラ")
//        selectImage()
//    }
    

    
        private func selectImage(image_type : String) {
            let alertController: UIAlertController = UIAlertController(title: "アラート表示", message: "保存してもいいですか？", preferredStyle:  UIAlertController.Style.alert)
            //        let alertController = UIAlertController(title: "画像を選択", message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "カメラを起動", style: .default) { (UIAlertAction) -> Void in
                self.selectFromCamera()
            }
            let libraryAction = UIAlertAction(title: "カメラロールから選択", style: .default) { (UIAlertAction) -> Void in
                self.selectFromLibrary()
            }

            let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (UIAlertAction) -> Void in
                //self.selectFromLibrary()
                self.delete_str = self.delete_str + self.dataSource["0"]!.profile_image[Int(image_type)!].path! + ","
                print("削除削除削除削除削除削除削除削除削除削除")
                print(self.delete_str)
                self.dataSource["0"]!.profile_image[Int(image_type)!].id = nil

                self.UserProfileTable.reloadData()
            }

            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
            alertController.addAction(libraryAction)
            alertController.addAction(cancelAction)
        
            if (self.dataSource["0"]!.profile_image[Int(image_type)!].id != nil && image_type != "0") {
                alertController.addAction(deleteAction)
            }
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

            let jpegCompressionQuality: CGFloat = 0.9 // Set this to whatever suits your purpose
            self.base64String = (resizedImage.jpegData(compressionQuality: jpegCompressionQuality)?.base64EncodedString())!
            
            if (self.image_type == "0") {
                self.image_main_param = resizedImage
                self.image_main = self.base64String
            }
//            else if (self.image_type == "1") {
//                self.image_1_param = resizedImage
//                self.image_1 = self.base64String
//            } else if (self.image_type == "2") {
//                self.image_2_param = resizedImage
//                self.image_2 = self.base64String
//            } else if (self.image_type == "3") {
//                self.image_3_param = resizedImage
//                self.image_3 = self.base64String
//            } else if (self.image_type == "4") {
//                self.image_4_param = resizedImage
//                self.image_4 = self.base64String
//            }

            if (self.dataSource["0"]!.profile_image[Int(self.image_type)!].id != nil ) {
                self.delete_str = self.delete_str + self.dataSource["0"]!.profile_image[Int(image_type)!].path! + ","
            }

            UserProfileTable.reloadData()
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
}

extension ProfileEditViewController : ProfileEditModelDelegate {
    func onFinally(model: ProfileEditModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onStart(model: ProfileEditModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: ProfileEditModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;

        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
        var count: Int = 0;
        if self.editType == 1 {
        print("更新")
        let alertController:UIAlertController =
            UIAlertController(title:"プロフィールが更新されました",message: "プロフィールが更新されました",preferredStyle: .alert)
        // Default のaction
        let defaultAction:UIAlertAction =
            UIAlertAction(title: "更新されました",style: .destructive,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                print("更新されました")
//                self.ActivityIndicator.stopAnimating()
                self.activityIndicatorView.stopAnimating()
                self.UserProfileTable.reloadData()
            })
        // Cancel のaction
        let cancelAction:UIAlertAction =
            UIAlertAction(title: "閉じる",style: .cancel,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                print("キャンセル")
//                self.ActivityIndicator.stopAnimating()
                self.activityIndicatorView.stopAnimating()
                self.UserProfileTable.reloadData()
            })
        // actionを追加
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        // UIAlertControllerの起動
        present(alertController, animated: true, completion: nil)
        }

//        self.image_1_param = UIImage()
//        self.image_2_param = UIImage()
//        self.image_3_param = UIImage()
//        self.image_4_param = UIImage()

        UserProfileTable.reloadData()
    }
    func onFailed(model: ProfileEditModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }
    
    func onError(model: ProfileEditModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
//        ActivityIndicator.stopAnimating()
        self.activityIndicatorView.stopAnimating()
    }

}

