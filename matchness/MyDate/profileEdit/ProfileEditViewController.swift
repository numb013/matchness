//
//  ProfileEditViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/08.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var UserProfileTable: UITableView!
    
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

    var editType: Int = 0
    var selectRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserProfileTable.delegate = self
        UserProfileTable.dataSource = self
        // Do any additional setup after loading the view.

        pickerView.showsSelectionIndicator = true
        
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

        
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestProfileEditModel = ProfileEditModel();
        requestProfileEditModel.delegate = self as! ProfileEditModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ME;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var api_key = userDefaults.object(forKey: "api_token") as? String
        query["api_token"] = api_key
        //リクエスト実行
        if( !requestProfileEditModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        print("マイデータ")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 8
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "イメージ"
        } else if (section == 1){
            return "自己紹介"
        } else if (section == 2){
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

        
        print("AAAAAAAAAA")
        print(indexPath)
        print(indexPath.section)

        if indexPath.section == 0 {

            let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfilImageTableViewCell") as! ProfilImageTableViewCell


            var number = Int.random(in: 1 ... 18)
            cell.mainImage.image = UIImage(named: "\(number)")
            cell.image_1.image = UIImage(named: "\(number)")
            cell.image_2.image = UIImage(named: "\(number)")
            cell.image_3.image = UIImage(named: "\(number)")
            cell.image_4.image = UIImage(named: "\(number)")


            return cell
            
        }
        
        if indexPath.section == 1 {
            let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "TextAreaTableViewCell") as! TextAreaTableViewCell

            cell.textLabel!.numberOfLines = 0
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.textArea.delegate = self
            cell.textArea.tag = 1
            cell.textArea?.font = UIFont.systemFont(ofSize: 14)
            cell.textArea!.text = myData?.profile_text
                return cell
        }

        if indexPath.section == 2 {

            if indexPath.row == 0 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "TextFiledTableViewCell") as! TextFiledTableViewCell
                cell.title?.text = "ニックネーム"
                cell.textFiled.delegate = self
                cell.textFiled.tag = 0
                print("ニックネームニックネームニックネームニックネーム")
                cell.textFiled?.text = myData?.name
                return cell
            }
            
            if indexPath.row == 1 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "職業"
                cell.detail?.text = ApiConfig.WORK_LIST[myData?.work ?? 0]
                return cell
            }
            if indexPath.row == 2 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "居住地"
                cell.detail?.text = ApiConfig.PREFECTURE_LIST[myData?.prefecture_id ?? 0]
                return cell
            }
            if indexPath.row == 3 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "誕生日"

                let dateFormater = DateFormatter()
                dateFormater.locale = Locale(identifier: "ja_JP")
                dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"

print("時間時間時間時間時間時間時間時間")
print(self.dataSource["0"]?.birthday)

                let date = dateFormater.date(from: self.dataSource["0"]?.birthday ?? "2016-10-03 03:12:12 +0000")
                print("誕生日誕生日誕生日")

                dateFormater.dateFormat = "yyyy年MM月dd日"
                let date_text = dateFormater.string(from: date ?? Date())
                
                cell.detail?.text = String(date_text)
                return cell
            }
            
            if indexPath.row == 4 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "痩せたい部位"
                cell.detail?.text = ApiConfig.FITNESS_LIST[myData?.fitness_parts_id ?? 0]
                return cell
            }
            if indexPath.row == 5 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "体重(非公開)"
                cell.detail?.text = ApiConfig.WEIGHT_LIST[myData?.weight ?? 0]
                return cell

            }

            if indexPath.row == 6 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "性別"
                cell.detail?.text = ApiConfig.SEX_LIST[myData?.sex ?? 0]
                return cell
            }

            if indexPath.row == 7 {
                let cell = UserProfileTable.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell") as! ProfileEditTableViewCell

                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell.title?.text = "血液型"
                cell.detail?.text = ApiConfig.BLOOD_LIST[myData?.blood_type ?? 2]
                return cell
            }
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップ")
        print(indexPath.row)

        cancelPressed()
        cancelDatePressed()
        if indexPath.row == 0 {
            print("カメラ")
            selectImage()
            // self.selectPicker = 0
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
            let dateFormater = DateFormatter()
            dateFormater.locale = Locale(identifier: "ja_JP")
            dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date = dateFormater.date(from: self.dataSource["0"]?.birthday ?? "2016-10-03 03:12:12 +0000")

            datePickerView.date = date!
            datePickerPush()
        } else {
            PickerPush()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 500
        } else if indexPath.section == 1 {
            return 100
        }
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
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(ProfileEditViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ProfileEditViewController.cancelPressed))
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
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(ProfileEditViewController.doneDatePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ProfileEditViewController.cancelDatePressed))
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
        UserProfileTable.reloadData()
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
        UserProfileTable.reloadData()
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
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.setDateviewTime = dateFormater.string(from: datePickerView.date)
        self.dataSource["0"]?.birthday = self.setDateviewTime
        print("時間時間時間")
        print(datePickerView.date)
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("テキスト１")
        var tag = textField.tag
        print(tag)
        print(textField.text!)
        if tag == 0 {
            self.dataSource["0"]?.name = textField.text!
        }
        if tag == 1 {
            self.dataSource["0"]?.profile_text = textField.text!
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var tag = textField.tag
        print(textField.text!)
        if tag == 0 {
            self.dataSource["0"]?.name = textField.text!
        }
        if tag == 1 {
            self.dataSource["0"]?.profile_text = textField.text!
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
            self.dataSource["0"]?.name = textField.text!
        }
        if tag == 1 {
            self.dataSource["0"]?.profile_text = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }

    @IBAction func editProfilButton(_ sender: Any) {
        print("編集ボタン！！！！")
        print(self.dataSource["0"])
        print("編集ボタン??????")
        self.editType = 1
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestProfileEditModel = ProfileEditModel();
        requestProfileEditModel.delegate = self as! ProfileEditModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_PROFILE_EDIT;

        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["id"] = String(self.dataSource["0"]?.id ?? 0)
        query["profile_text"] = self.dataSource["0"]?.profile_text
        query["name"] = self.dataSource["0"]?.name
        query["birthday"] = self.dataSource["0"]?.birthday
        query["work"] = String(self.dataSource["0"]?.work ?? 0)
        query["age"] = String(self.dataSource["0"]?.age ?? 0)
        query["sex"] = String(self.dataSource["0"]?.sex ?? 0)
        query["fitness_parts_id"] = String(self.dataSource["0"]?.fitness_parts_id ?? 0)
        query["blood_type"] = String(self.dataSource["0"]?.blood_type ?? 0)
        query["weight"] = String(self.dataSource["0"]?.weight ?? 0)
        query["prefecture_id"] = String(self.dataSource["0"]?.prefecture_id ?? 0)
        //リクエスト実行
        if( !requestProfileEditModel.requestApi(url: requestUrl, addQuery: query) ){
            
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
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
        else{
            print("カメラロール許可をしていない時の処理1111")
        }
    }
    
    private func selectFromLibrary() {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }

    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        


        let resizedImage = self.resizeImage(image: info[UIImagePickerController.InfoKey.editedImage] as! UIImage, ratio: 0.5) // 50% に縮小


        if let pickedImage = info[.originalImage]
            as? UIImage {
            
//            cameraView.contentMode = .scaleAspectFit
//            cameraView.image = pickedImage
        }
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        print("Tap the [Save] to save a picture")
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("Canceled")
    }
    
    
    // 写真を保存
//    @IBAction func savePicture(_ sender : AnyObject) {
//        let image:UIImage! = cameraView.image
//
//        if image != nil {
//            UIImageWriteToSavedPhotosAlbum(
//                image,
//                self,
//                #selector(ProfileEditViewController.image(_:didFinishSavingWithError:contextInfo:)),
//                nil)
//        }
//        else{
//            print("image Failed !")
//        }
//
//    }
    
    // 書き込み完了結果の受け取り
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: NSError!,
                     contextInfo: UnsafeMutableRawPointer) {
        
        if error != nil {
            print(error.code)
            print("Save Failed !")
        }
        else{
            print("Save Succeeded")
        }
    }
    
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let resizedImage = self.resizeImage(image: info[UIImagePickerController.InfoKey.editedImage] as! UIImage, ratio: 0.5) // 50% に縮小
//
//        let imageData = NSData(data: (resizedImage).pngData()!) as NSData
////        let storageRef = Storage.storage().reference()
//
//        let f = DateFormatter()
//        f.dateFormat = "yyyyMMddHms"
//        let now = Date()
//
//        var image_url : String? = ""
////        let referenceRef = storageRef.child("images/" + f.string(from: now) + ".jpg")
////        let meta = StorageMetadata()
////        meta.contentType = "image/jpeg"
////
////        referenceRef.putData(imageData as Data, metadata: meta, completion: { metaData, error in
////            if (error != nil) {
////                print("Uh-oh, an error occurred!")
////            } else {
////                print(metaData)
////                image_url = metaData?.name
////
////                let post1 = [
////                    "from": self.senderId,
////                    "name": self.senderDisplayName,
////                    "media_type": "image",
////                    "text": nil,
////                    "image_url": image_url,
////                    "create_at": f.string(from: now),
////                    "update_at": f.string(from: now),
////                    ] as [String : Any]
////                let post1Ref = self.ref.child("messages").child(self.roomId).childByAutoId()
////                post1Ref.setValue(post1)
////                self.finishSendingMessage(animated: true)
////            }
////        })
////
//        picker.dismiss(animated: true, completion: nil)
//    }
    
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
    
    func onStart(model: ProfileEditModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: ProfileEditModel, count: Int) {
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
            })
        // Cancel のaction
        let cancelAction:UIAlertAction =
            UIAlertAction(title: "閉じる",style: .cancel,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                print("キャンセル")
            })
        // actionを追加
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        // UIAlertControllerの起動
        present(alertController, animated: true, completion: nil)
        }


        UserProfileTable.reloadData()


    }
    func onFailed(model: ProfileEditModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }
    
}
