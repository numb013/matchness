//
//  UserDetailViewController.swift
//  matchness
//
//  Created by user on 2019/02/05.
//  Copyright © 2019年 a2c. All rights reserved.
//

import UIKit
import ImageViewer

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var targetString: String?
    var targetGroupId: Int?
    var targetUserId: Int?
}

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,GalleryItemsDataSource {

    let userDefaults = UserDefaults.standard
    @IBOutlet weak var UserDtailTable: UITableView!
    var galleyItem: GalleryItem!
    var user_id:Int = 0

    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiUserDetailDate> = [:]
    var dataSourceOrder: Array<String> = []
    
    
    struct DataItem {
        let imageView: UIImage
        let galleryItem: GalleryItem
    }

    var items: [DataItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDtailTable.delegate = self
        UserDtailTable.dataSource = self

        self.UserDtailTable.register(UINib(nibName: "UserDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDetailTableViewCell")
        self.UserDtailTable.register(UINib(nibName: "UserDetailInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDetailInfoTableViewCell")

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
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String

        print("ユーザーIDユーザーIDユーザーIDユーザーID")
        print(matchness_user_id)

        query["user_id"] = matchness_user_id
        query["target_id"] = "\(user_id)"

        print("ハッスル2")
        print(query)


        //リクエスト実行
        if( !requestUserDetailModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
print("ユーザー詳細")
print(user_id)
        
        
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 5
        } else {
            return 1
        }
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


        print("こいいいいいいこいいいいいい")
        print(self.dataSource["0"])
        var detail = self.dataSource["0"]

        print(detail)
        
        if indexPath.section == 0 {
            let cell = UserDtailTable.dequeueReusableCell(withIdentifier: "UserDetailTableViewCell") as! UserDetailTableViewCell

//            var number = Int.random(in: 1 ... 18)
//            let image = UIImage(named: "\(number)")
//            galleyItem = GalleryItem.image{ $0(image) }

//            // 画像（拡大前の）を表示
//            let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: view.frame.width - 100*2, height: 200))
//            imageView.image = image
//            imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
//            view.addSubview(imageView)

//            // 画像をタップしたら拡大
//            imageView.isUserInteractionEnabled = true
//            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
//            imageView.addGestureRecognizer(recognizer)


            var number = Int.random(in: 1 ... 18)
            var image0 = UIImage(named: "\(number)")
            galleyItem = GalleryItem.image{ $0(image0) }
            cell.UserMainImage.image = image0

            
            number = Int.random(in: 1 ... 18)
            var image1 = UIImage(named: "\(number)")
            galleyItem = GalleryItem.image{ $0(image1) }
            cell.UserSubImage1.image = image1
            cell.UserSubImage1.isUserInteractionEnabled = true
            var recognizer1 = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            recognizer1.targetString = "1"
            cell.UserSubImage1.addGestureRecognizer(recognizer1)
            items.append(DataItem(imageView: image1!, galleryItem: galleyItem))

            
            number = Int.random(in: 1 ... 18)
            var image2 = UIImage(named: "\(number)")
            galleyItem = GalleryItem.image{ $0(image2) }
            cell.UserSubImage2.image = image2
            cell.UserSubImage2.isUserInteractionEnabled = true
            var recognizer2 = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            recognizer2.targetString = "2"

            cell.UserSubImage2.addGestureRecognizer(recognizer2)
            items.append(DataItem(imageView: image2!, galleryItem: galleyItem))

            number = Int.random(in: 1 ... 18)
            var image3 = UIImage(named: "\(number)")
            galleyItem = GalleryItem.image{ $0(image3) }
            cell.UserSubImage3.image = image3
            cell.UserSubImage3.isUserInteractionEnabled = true
            var recognizer3 = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            recognizer3.targetString = "3"
            cell.UserSubImage3.addGestureRecognizer(recognizer3)
            items.append(DataItem(imageView: image3!, galleryItem: galleyItem))

            number = Int.random(in: 1 ... 18)
            var image4 = UIImage(named: "\(number)")
            galleyItem = GalleryItem.image{ $0(image4) }
            cell.UserSubImage4.image = image4
            cell.UserSubImage4.isUserInteractionEnabled = true
            var recognizer4 = MyTapGestureRecognizer(
                target: self,
                action: #selector(self.onTap(_:))
            )
            recognizer4.targetString = "4"
            cell.UserSubImage4.addGestureRecognizer(recognizer4)
            items.append(DataItem(imageView: image4!, galleryItem: galleyItem))

            cell.UserName.text = detail?.name
            cell.LoginTime.text = "居住地 : " + ApiConfig.PREFECTURE_LIST[detail?.prefecture_id ?? 0]


            // いいねボタン設定
            var target:Int = detail?.id ?? 0
            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onLike(_:)))
            recognizer.targetString = String(target)
            cell.LikeButton.addGestureRecognizer(recognizer)

            return cell
        }

        if indexPath.section == 1 {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "userDetailInfo")
            cell.textLabel!.numberOfLines = 0
            cell.backgroundColor =  UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none

            cell.textLabel!.text = detail?.profile_text
            return cell
        }

        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailInfoTableViewCell") as! UserDetailInfoTableViewCell
            if indexPath.row == 0 {
                cell.title?.text = "ニックネーム"
                print("ニックネームニックネームニックネームニックネーム")
                print(self.dataSource["0"]?.work)
                cell.detail?.text = detail?.name
                return cell
            }
            if indexPath.row == 1 {
                cell.title?.text = "職業"
                cell.detail?.text = ApiConfig.WORK_LIST[detail?.work ?? 0]
                return cell
            }
            if indexPath.row == 2 {
                cell.title?.text = "誕生日"
                
                let f = DateFormatter()
                f.dateStyle = .long
                f.locale = Locale(identifier: "ja")
                //                self.setDateviewTime = f.string(from: self.dataSource["0"]!.birthday)
                let dateFormater = DateFormatter()
                //                dateFormater.locale = Locale(identifier: "ja_JP")
                //                dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
                //                var date = dateFormater.date(from: self.dataSource["0"]?.birthday ?? "2016-10-03 03:12:12 +0000")
                ////                print(date?.description ?? "nilですよ")    // 2016-10-03 03:12:12 +0000
                //                var date_data = date?.description
                
                //                dateFormater.locale = Locale(identifier: "ja_JP")
                //                var date = dateFormater.date(from: self.dataSource["0"]?.birthday ?? "2016-10-03 03:12:12 +0000")
                
                //                dateFormater.dateFormat = "yyyy年MM月dd日"
                //                var date_text = dateFormater.string(from: date!)
                
                
                cell.detail?.text = "2016-10-03 03:12:12"
                return cell
            }
            
            if indexPath.row == 3 {
                cell.title?.text = "痩せたい部位"
                cell.detail?.text = ApiConfig.FITNESS_LIST[detail?.fitness_parts_id ?? 0]
                return cell
            }
            if indexPath.row == 4 {
                cell.title?.text = "血液型"
                cell.detail?.text = ApiConfig.BLOOD_LIST[detail?.blood_type ?? 2]
                return cell
            }

        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailInfo")
        return cell!
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 1 {
//            return 70
//        }
//        if indexPath.section == 2 {
//            return 55
//        }
//        return 533
//    }
    
    
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

    @objc func onLike(_ sender: MyTapGestureRecognizer) {
        print("タップタップタップいいね")
        var target_id = sender.targetString!
        
        let requestUserDetailModel = UserDetailModel();
        requestUserDetailModel.delegate = self as! UserDetailModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_LIKE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String

        print("ユーザーIDユーザーIDユーザーIDユーザーID")
        print(matchness_user_id)
        
        query["user_id"] = matchness_user_id
        query["target_id"] = "\(user_id)"

        //リクエスト実行
        if( !requestUserDetailModel.requestApi(url: requestUrl, addQuery: query) ){
            
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

extension UserDetailViewController : UserDetailModelDelegate {
    
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
        
        UserDtailTable.reloadData()
    }
    func onFailed(model: UserDetailModel) {
        print("こちら/UserDetail/UserDetailViewのonFailed")
    }
    
}
