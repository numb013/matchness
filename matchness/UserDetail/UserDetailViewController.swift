//
//  UserDetailViewController.swift
//  matchness
//
//  Created by user on 2019/02/05.
//  Copyright © 2019年 a2c. All rights reserved.
//

import UIKit
import ImageViewer
import Alamofire
import SwiftyJSON

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var targetString: String?
    var targetGroupId: Int?
    var targetUserId: Int?
    var amount: String?
    var pay_point_id: String?
    var payment_id: String?
}

struct detailParam: Codable {
    let status: String?
    let message: String?
    let is_like: Int?
    let is_matche: Int?
}


class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,GalleryItemsDataSource {

    let userDefaults = UserDefaults.standard
    @IBOutlet weak var UserDtailTable: UITableView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var LikeRequest: UIButton!

    private var requestAlamofire: Alamofire.Request?;
    var activityIndicatorView = UIActivityIndicatorView()
    var favorite_block_status = Int()
    var galleyItem: GalleryItem!
    var user_id:Int = 0
    var target_id:Int = 0
    var target_name:String = ""
    var requestUrl_1 = ""
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiUserDetailDate> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;
    var profile_text = ""
    var is_matche = 0
    struct DataItem {
        let imageView: UIImage
        let galleryItem: GalleryItem
    }

    var items: [DataItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDtailTable?.delegate = self
        UserDtailTable?.dataSource = self

        self.UserDtailTable?.register(UINib(nibName: "UserDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDetailTableViewCell")
        self.UserDtailTable?.register(UINib(nibName: "UserDetailInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDetailInfoTableViewCell")
        requestApi()
    }

    func requestApi() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestUserDetailModel = UserDetailModel();
        requestUserDetailModel.delegate = self as! UserDetailModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_DETAIL;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        print("ユーザーIDユーザーIDユーザーIDユーザーID")
        print("ターゲットターゲットターゲットID")
        print(user_id)
        
        query["target_id"] = "\(user_id)"
//        view.backgroundColor = .lightGray
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        view.addSubview(activityIndicatorView)
        
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
        
        //リクエスト実行
        if( !requestUserDetailModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        // ナビゲーションを透明にする処理
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 透明にしたナビゲーションを元に戻す処理
//        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
//        self.navigationController!.navigationBar.shadowImage = nil
    }
    
    @IBOutlet weak var gradationView: GradationView!

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 9
        }
        return 1
    }
    
    // Sectioのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionLabel:String? = nil
        if section == 1 {
            sectionLabel = "自己紹介"
        } else if section == 2 {
            sectionLabel = "プロフィール"
        }
        return sectionLabel
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var detail = self.dataSource["0"]

        print("カカかかかかかかかかかかっか")
            print(detail)
        
        if (detail != nil) {
            if (self.dataSource["0"]!.favorite_block_status! == nil) {
                self.favorite_block_status = 99
            } else {
                self.favorite_block_status = detail?.favorite_block_status! ?? 99
            }
        }

        if indexPath.section == 0 {
            let cell = UserDtailTable.dequeueReusableCell(withIdentifier: "UserDetailTableViewCell") as! UserDetailTableViewCell

            self.target_id = detail?.id ?? 0
            self.target_name = String(detail?.name ?? "")
            chatButton.isHidden = true

            print("ボタンボタンボタンボタンボタン")
            print(self.is_matche)

            if self.is_matche != 1 {
                if (detail?.is_like == 1) {
                    if (detail?.is_matche == 1) {
                        LikeRequest.isEnabled = false
                        LikeRequest.isHidden = true
                        LikeRequest.backgroundColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
                        chatButton.isHidden = false
                    } else {
                        LikeRequest.isEnabled = false
                        LikeRequest.backgroundColor =  #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
                        LikeRequest.backgroundColor =  #colorLiteral(red: 0.4803626537, green: 0.05874101073, blue: 0.1950398982, alpha: 1)
                        LikeRequest.setTitle("いいね済み", for: .normal)
                    }
                }
            } else {
                LikeRequest.isEnabled = false
                LikeRequest.isHidden = true
                LikeRequest.backgroundColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
                chatButton.isHidden = false
            }

            if (detail != nil) {
                if (detail!.profile_image[0].id == nil) {
                    cell.UserMainImage.image = UIImage(named: "no_image")
                } else {
                    let profileImageURL = image_url + detail!.profile_image[0].path!
                    let url = NSURL(string: profileImageURL);
                    let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
                    var image0 = UIImage(data:imageData! as Data)
                    cell.UserMainImage.image = UIImage(data:imageData! as Data)
                    galleyItem = GalleryItem.image{ $0(image0) }
                    
                    cell.UserMainImage.image = image0
                    cell.UserMainImage.isUserInteractionEnabled = true
                    var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
                    recognizer.targetString = "1"
                    cell.UserMainImage.addGestureRecognizer(recognizer)
                    items.append(DataItem(imageView: image0!, galleryItem: galleyItem))
                }


//                if (detail!.profile_image[1].id == nil) {
//                    cell.UserSubImage1.image = UIImage(named: "no_image")
//                } else {
//                    let profileImageURL = image_url + detail!.profile_image[1].path!
//                    let url = NSURL(string: profileImageURL);
//                    let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
//                    var image1 = UIImage(data:imageData! as Data)
//                    galleyItem = GalleryItem.image{ $0(image1) }
//                    cell.UserSubImage1.image = image1
//                    cell.UserSubImage1.isUserInteractionEnabled = true
//                    var recognizer1 = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
//                    recognizer1.targetString = "2"
//                    cell.UserSubImage1.addGestureRecognizer(recognizer1)
//                    items.append(DataItem(imageView: image1!, galleryItem: galleyItem))
//                }
//
//                if (detail!.profile_image[2].id == nil) {
//                    cell.UserSubImage2.image = UIImage(named: "no_image")
//                } else {
//                    let profileImageURL = image_url + detail!.profile_image[2].path!
//                    let url = NSURL(string: profileImageURL);
//                    let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
//                    var image2 = UIImage(data:imageData! as Data)
//                    galleyItem = GalleryItem.image{ $0(image2) }
//                    cell.UserSubImage2.image = image2
//                    cell.UserSubImage2.isUserInteractionEnabled = true
//                    var recognizer2 = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
//                    recognizer2.targetString = "3"
//                    cell.UserSubImage2.addGestureRecognizer(recognizer2)
//                    items.append(DataItem(imageView: image2!, galleryItem: galleyItem))
//                }
//
//                if (detail!.profile_image[3].id == nil) {
//                    cell.UserSubImage3.image = UIImage(named: "no_image")
//                } else {
//                    let profileImageURL = image_url + detail!.profile_image[3].path!
//                    let url = NSURL(string: profileImageURL);
//                    let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
//                    var image3 = UIImage(data:imageData! as Data)
//                    galleyItem = GalleryItem.image{ $0(image3) }
//                    cell.UserSubImage3.image = image3
//                    cell.UserSubImage3.isUserInteractionEnabled = true
//                    var recognizer3 = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
//                    recognizer3.targetString = "4"
//                    cell.UserSubImage3.addGestureRecognizer(recognizer3)
//                    items.append(DataItem(imageView: image3!, galleryItem: galleyItem))
//                }
//
//
//                if (detail!.profile_image[4].id == nil) {
//                    cell.UserSubImage4.image = UIImage(named: "no_image")
//                } else {
//                    let profileImageURL = image_url + detail!.profile_image[4].path!
//                    let url = NSURL(string: profileImageURL);
//                    let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
//                    var image4 = UIImage(data:imageData! as Data)
//                    galleyItem = GalleryItem.image{ $0(image4) }
//                    cell.UserSubImage4.image = image4
//                    cell.UserSubImage4.isUserInteractionEnabled = true
//                    var recognizer4 = MyTapGestureRecognizer(target: self,action: #selector(self.onTap(_:)))
//                    recognizer4.targetString = "5"
//                    cell.UserSubImage4.addGestureRecognizer(recognizer4)
//                    items.append(DataItem(imageView: image4!, galleryItem: galleyItem))
//                }
            }

            // いいねボタン設定
//            var target:Int = detail?.id ?? 0
//            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onLike(_:)))
//            recognizer.targetString = String(target)
//            cell.LikeButton.addGestureRecognizer(recognizer)

            return cell
        }

        if indexPath.section == 1 {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "userDetailInfo")
            cell.textLabel!.numberOfLines = 0
            cell.backgroundColor =  UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if detail != nil {
                if (detail?.profile_text == "") {
                    self.profile_text = "自己紹介の入力はありません。"
                    cell.textLabel!.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                } else {
                    cell.textLabel!.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                    self.profile_text = detail!.profile_text!
                }
            }
            
//            cell.textLabel!.font.withSize(6)
            cell.textLabel!.text = self.profile_text
            return cell
        }

        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailInfoTableViewCell") as! UserDetailInfoTableViewCell
            if indexPath.row == 0 {
                cell.title?.text = "ニックネーム"
                print("ニックネームニックネームニックネームニックネーム")

                cell.detail?.adjustsFontSizeToFitWidth = true
                cell.detail?.numberOfLines = 0

                cell.detail?.text = detail?.name
                return cell
            }

            if indexPath.row == 1 {
                cell.title?.text = "性別"
                cell.detail?.text = ApiConfig.SEX_LIST[detail?.sex ?? 0]
                return cell
            }
            if indexPath.row == 2 {
                cell.title?.text = "年齢"
                cell.detail?.text = (detail?.age! ?? "0") + "歳"
                return cell
            }
            
            if indexPath.row == 3 {
                cell.title?.text = "痩せたい箇所"
                cell.detail?.text = ApiConfig.FITNESS_LIST[detail?.fitness_parts_id ?? 0]
                return cell
            }
            if indexPath.row == 4 {
                cell.title?.text = "血液型"
                cell.detail?.text = ApiConfig.BLOOD_LIST[detail?.blood_type ?? 2]
                return cell
            }
            if indexPath.row == 5 {
                cell.title?.text = "職業"
                cell.detail?.text = ApiConfig.WORK_LIST[detail?.work ?? 0]
                return cell
            }
            if indexPath.row == 6 {
                cell.title?.text = "居住区"
                
                cell.detail?.text = ApiConfig.PREFECTURE_LIST[detail?.prefecture_id ?? 0]
                return cell
            }
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailInfo")
        return cell!
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let message_users:[String:String] = [
//            "room_code":(self.dataSource["0"]?.room_code!)!,
//            "user_id":String(self.dataSource["0"]!.my_id!),
//            "user_name":self.dataSource["0"]!.my_name!,
//            "point":String(self.dataSource["0"]!.my_point!),
//            "my_image":self.dataSource["0"]!.my_profile_image!,
//            "target_imag":self.dataSource["0"]!.target_imag!,
//        ]
//
//        print("ファースト送信送信送信送信送信送信送信送信送信")
//        print(message_users)
//        //self.performSegue(withIdentifier: "toSecond", sender: self)
//        self.performSegue(withIdentifier: "toMessage", sender: message_users)
//    }
//

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 1 {
                tableView.estimatedRowHeight = 200 //セルの高さ
                return UITableView.automaticDimension //自動設定
            }
            if indexPath.section == 2 {
                return 55
            }
        tableView.estimatedRowHeight = 200 //セルの高さ
        return UITableView.automaticDimension //自動設定
     }
    
    
    func imageViewTapped(_ sender: UITapGestureRecognizer) {
        print("タップ")
    }

    func itemCount() -> Int {
        return items.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        print("index")
        print(index)
        
        return items[index].galleryItem
    }
    
    @objc func onTap(_ sender: MyTapGestureRecognizer) {
        print("タップタップタップ")

        var number = sender.targetString!
        print(sender.targetString!)
        var nStr1:Int = Int(number)!
        var nStr = (nStr1 - Int(1))
        let galleryViewController = GalleryViewController(startIndex: nStr, itemsDataSource: self, configuration: [.deleteButtonMode(.none), .seeAllCloseButtonMode(.none), .thumbnailsButtonMode(.none)])
        self.present(galleryViewController, animated: true, completion: nil)
    }

    @IBAction func chatButton(_ sender: Any) {
        print("チャットボタン")
        let message_users:[String:String] = [
            "room_code":(self.dataSource["0"]?.room_code!)!,
            "user_id":String(self.dataSource["0"]!.my_id!),
            "user_name":self.dataSource["0"]!.my_name!,
            "point":String(self.dataSource["0"]!.my_point!),
            "my_image":self.dataSource["0"]!.my_profile_image!,
            "target_imag":self.dataSource["0"]!.target_imag!,
        ]
        print("送信送信送信送信送信送信送信送信送信")
        print(message_users)
        //self.performSegue(withIdentifier: "toSecond", sender: self)
        self.performSegue(withIdentifier: "toMessage", sender: message_users)
    }

    @IBAction func addLikeButton(_ sender: Any) {
        print("タップタップタップいいね")

        LikeRequest.isEnabled = false
        LikeRequest.backgroundColor =  #colorLiteral(red: 0.4803626537, green: 0.05874101073, blue: 0.1950398982, alpha: 1)
        LikeRequest.setTitle("いいね済み", for: .normal)

        self.target_id = self.dataSource["0"]!.id!
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_LIKE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["target_id"] = "\(user_id)"
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

        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                print("取得!!!!!!!!!!!")
                guard let data = response.data else { return }
                 guard let detailParam = try? JSONDecoder().decode(detailParam.self, from: data) else {
                    print("アウトアウトアウトアウト")
                     return
                 }

                if detailParam.status != "NG" {
                    var alert = UIAlertController(title: "いいね", message: "いいねしました", preferredStyle: .alert)

                    if  detailParam.is_matche == 1  {
                        self.is_matche = 1
                        alert = UIAlertController(title: "マッチングしました", message: "メッセージが送れようになりました", preferredStyle: .alert)
                    }
                    self.present(alert, animated: true, completion: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.requestApi()
                            alert.dismiss(animated: true, completion: nil)
                        })
                    })
                } else {
                    self.LikeRequest.isEnabled = true
                    self.LikeRequest.backgroundColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
                    self.LikeRequest.setTitle("いいね", for: .normal)

                    let alertController:UIAlertController =
                        UIAlertController(title:"ポイントが不足しています",message: "いいねするにはポイント5p必要です", preferredStyle: .alert)
                    // Default のaction
                    let defaultAction:UIAlertAction =
                        UIAlertAction(title: "ポイント変換ページへ",style: .destructive,handler:{
                            (action:UIAlertAction!) -> Void in
                            // 処理
                            print("ポイント変換ページへ")
                            let storyboard: UIStoryboard = self.storyboard!
                            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                            let multiple = storyboard.instantiateViewController(withIdentifier: "pointChange")
                            multiple.modalPresentationStyle = .fullScreen
                            //ここが実際に移動するコードとなります
                            self.present(multiple, animated: false, completion: nil)
                        })

                    // Cancel のaction
                    let cancelAction:UIAlertAction =
                        UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                            (action:UIAlertAction!) -> Void in
                            // 処理
                            print("キャンセル")
                        })
                    // actionを追加
                    alertController.addAction(cancelAction)
                    alertController.addAction(defaultAction)
                    // UIAlertControllerの起動
                    self.present(alertController, animated: true, completion: nil)
                }

            case .failure:
                //  リクエスト失敗 or キャンセル時
                let alert = UIAlertController(title: "サーバーエラー", message: "しばらくお待ちください", preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                })
                return;
            }
        }
    }

    
    
    func apiNoticeRequest() {
        print("APIへリクエスト（ユーザー取得")
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_LIKE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["target_id"] = "\(user_id)"
        var headers: [String : String] = [:]
        var api_key = userDefaults.object(forKey: "api_token") as? String
        if ((api_key) != nil) {
            headers = [
                "Accept" : "application/json",
                "Authorization" : "Bearer " + api_key!,
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }

    }
    

    @IBAction func reportButtom(_ sender: Any) {
               // UIAlertController
               let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

                if (self.favorite_block_status == 1) {
                      let actionChoise1 = UIAlertAction(title: "お気に入り解除", style: .default){
                         action in
                      self.userFavoriteBlock(3)
                     }
                    alertController.addAction(actionChoise1)
                } else {
                      let actionChoise1 = UIAlertAction(title: "お気に入り", style: .default){
                         action in
                      self.userFavoriteBlock(1)
                     }
                    alertController.addAction(actionChoise1)
                }
                if (self.favorite_block_status == 2) {
                     let actionChoise2 = UIAlertAction(title: "ブロック解除", style: .default){
                        action in
                     self.userFavoriteBlock(3)
                    }
                    alertController.addAction(actionChoise2)
                } else {
                     let actionChoise2 = UIAlertAction(title: "ブロックする", style: .default){
                        action in
                     self.userFavoriteBlock(2)
                    }
                    alertController.addAction(actionChoise2)
                }
                let actionNoChoise = UIAlertAction(title: "通報する", style: .destructive){
                   action in
                self.createReport(self.target_id)
               }
               let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel){
                   (action) -> Void in
                    print("Cancel")
                }
               // actionを追加

        //       alertController.addAction(actionChoise2)
               alertController.addAction(actionNoChoise)
               alertController.addAction(actionCancel)
               // UIAlertControllerの起動
               present(alertController, animated: true, completion: nil)

    }

    func userFavoriteBlock(_ status:Int){
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        print("ユーザーIDユーザーIDユーザーIDユーザーID")
        //リクエスト先
        if (status == 3) {
            print("解除９解除９解除９解除９解除９")
            self.requestUrl_1 = ApiConfig.REQUEST_URL_API_DELETE_FAVORITE_BLOCK;
        } else {
            self.requestUrl_1 = ApiConfig.REQUEST_URL_API_ADD_FAVORITE_BLOCK;
        }
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["target_id"] = "\(user_id)"
        query["status"] = String(status)
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
        self.requestAlamofire = Alamofire.request(self.requestUrl_1, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            print("リクエストRRRRRRRRRRRRRRRRRR")
            print(self.requestUrl_1)
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
                print(status)
                var alert_title = ""
                var alert_text = ""
                
                // アラート作成
                if status == 0 {
                    print("ブロック")
                    alert_title = "ブロック"
                    alert_text = "ブロックしました"

                } else if status == 1 {
                    print("お気に入り")
                    alert_title = "お気に入り"
                    alert_text = "お気に入りしました"
                } else if status == 2 {
                    alert_title = "ブロック解除"
                    alert_text = "ブロック解除しました"
                } else if status == 3 {
                    alert_title = "お気に入り解除"
                    alert_text = "お気に入り解除しました"
                }
                let alert = UIAlertController(title: alert_title, message: alert_text, preferredStyle: .alert)

                // アラート表示
                self.present(alert, animated: true, completion: {
                    // アラートを閉じる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
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

    func createReport(_ target_id:Int){
        print("toReporttoReporttoReporttoReporttoReport")
        print(target_id)

//        let storyboard: UIStoryboard = self.storyboard!
//        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
//        let multiple = storyboard.instantiateViewController(withIdentifier: "report")
//        multiple.modalPresentationStyle = .fullScreen
//        //ここが実際に移動するコードとなります
//        self.present(multiple, animated: true, completion: nil)
        let report_param:[String:String] = ["target_id":String(target_id), "target_name": self.target_name]
        self.performSegue(withIdentifier: "reportsegu", sender: report_param)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessage" {
            let mvc = segue.destination as! MessageViewController
            print("sendersendersendersender")
            print(sender)

            mvc.message_users = sender as! [String : String]
        } else {
            let vc = segue.destination as! ReportViewController
            vc.report_param = sender as! [String : Any]
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backFromUserDetailView(segue:UIStoryboardSegue){
        NSLog("ReportViewController#backUserDetail")
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

extension UserDetailViewController : UserDetailModelDelegate {
    func onFinally(model: UserDetailModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
    func onStart(model: UserDetailModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: UserDetailModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        
        print(self.dataSourceOrder)
        print("UserDetail耳耳耳意味耳みm")
        
        //一つもなかったら
        //        if( dataSourceOrder.isEmpty ){
        //            return;
        //        }
        
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
        //        self.cellCount = 10;
        
        print("ががががががががが")
        print(self.dataSource)
        print(self.dataSourceOrder)
        
        
        //
        var count: Int = 0;
        //        for(key, code) in dataSourceOrder.enumerated() {
        //            count+=1;
        //            if let jenre: ApiUserDateParam = dataSource[code] {
        //                //取得したデータを元にコレクションを再構築＆更新
        //                mapMenuView.addTagGroup(model: model, jenre: jenre);
        //            }
        //        }
//        ActivityIndicator.stopAnimating()
        self.activityIndicatorView.stopAnimating()
        UserDtailTable?.reloadData()
    }
    func onFailed(model: UserDetailModel) {
        print("こちら/UserDetail/UserDetailViewのonFailed")
    }
    
    func onError(model: UserDetailModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }

}
