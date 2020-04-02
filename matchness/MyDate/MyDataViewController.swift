//
//  MyDataViewController.swift
//  matchness
//
//  Created by user on 2019/02/05.
//  Copyright © 2019年 a2c. All rights reserved.
//

import UIKit
import CoreMotion
import MBCircularProgressBar
import HealthKit

class MyDataViewController: baseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserJob: UILabel!
    @IBOutlet weak var Menu: UICollectionView!
    @IBOutlet var stepCountLabel: UIButton!
    @IBOutlet weak var progressViewBar: MBCircularProgressBarView!
    @IBOutlet weak var myPoint: UILabel!
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;

    @IBOutlet weak var rankLabel: UILabel!
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    let userDefaults = UserDefaults.standard
    var dataSource: Dictionary<String, ApiMyData> = [:]
    var dataSourceOrder: Array<String> = []
    var cellCount: Int = 0
    var weight = 0

    var times: [String]!
    let dateFormatter = DateFormatter()
    let now = Date()
    var day = 0
    var counter = 0.0
    var step_1: [Double] = []
    var month_step = 0
    let store = HKHealthStore()
    
    
    let topMenu = ["AAA", "BBB", "CCC"]
    let systemMenu = ["足あと", "もらったいいね", "プロフィール", "お気に入り", "ポイント交換", "お知らせ", "ブロック", "設定", "ポイント購入履歴", "マイデータ"]

    override func viewDidLoad() {
        super.viewDidLoad()

        Menu.delegate = self
        Menu.dataSource = self
        
//        var number = Int.random(in: 1 ... 2)
//        UserImage.image = UIImage(named: "no_image")
        UserName.text = ""
        UserJob.text = ""
        getStepDate()
        getStepMonthDate()
        if let tabBarItem = self.tabBarController?.tabBar.items?[3] as? UITabBarItem {
            tabBarItem.badgeValue = nil
        }
        apiRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("マイページ戻りマイページ戻りマイページ戻りマイページ戻り")
        getStepMonthDate()
        apiRequest()
    }

    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestMyDataModel = MyDataModel();
        requestMyDataModel.delegate = self as! MyDataModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_MY_PAGE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var api_key = userDefaults.object(forKey: "api_token") as? String
        query["api_token"] = api_key
        query["step"] = String(self.month_step)
        //リクエスト実行
        if( !requestMyDataModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    func returnView() {
        var detail = self.dataSource["0"]


print("detaildetaildetaildetaildetaildetaildetail")
print(detail)

        if (detail?.profile_image == nil) {
            UserImage.image = UIImage(named: "no_image")
        } else {
            let profileImageURL = image_url + (detail?.profile_image!)!
            let url = NSURL(string: profileImageURL);
            let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
            UserImage.image = UIImage(data:imageData! as Data)
        }

        if detail != nil {
            UserName.text = detail?.name
            UserJob.text = ApiConfig.FITNESS_LIST[(detail?.fitness_parts_id ?? 0)!]
            myPoint.text = detail?.point
            rankLabel.text = ApiConfig.RANK_LIST[(detail?.rank ?? 0)!]
            self.weight = detail!.weight! ?? 4

            print("detaildetaildetaildetaildetail")
            print(detail)
            self.userDefaults.set(Int(detail!.point!), forKey: "point")
        }

    }

    
    func getStepDate() {
        getDayStep { (result) in
            DispatchQueue.main.async {
//                self.stepCountLabel.text = "\(result)"
                self.stepCountLabel.setTitle("\(Int(result))", for: .normal)

                print("1月月月月月月月月")
                print(result)

                self.progressViewBar.value = (CGFloat(Double(result) / 10000)*100)
            }
        }
    }

    func getStepMonthDate() {
        getMonthStep { (result) in
            DispatchQueue.main.async {
                self.month_step = Int(result)
            }
        }
    }

    
    // 今日の歩数を取得するための関数
    func getDayStep(completion: @escaping (Double) -> Void) {
        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let selectDate =  dateFormatter.string(from: from)
        var component = NSCalendar.current.dateComponents([.year, .month, .day], from: from)
        component.hour = 0
        component.minute = 0
        component.second = 0
        let start:NSDate = NSCalendar.current.date(from:component)! as NSDate
        //XX月XX日23時59分59秒に設定したものをendにいれる
        component.hour = 23
        component.minute = 59
        component.second = 59
        let end:NSDate = NSCalendar.current.date(from:component)! as NSDate


        let type = HKSampleType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: start as Date, end: end as Date, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .separateBySource) { (query, data, error) in
            if let sources = data?.sources?.filter({ $0.bundleIdentifier.hasPrefix("com.apple.health") }) {
                let sourcesPredicate = HKQuery.predicateForObjects(from: Set(sources))
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, sourcesPredicate])
                let query = HKStatisticsQuery(quantityType: type,
                                              quantitySamplePredicate: predicate,
                                              options: .cumulativeSum)
                { (query, statistics, error) in
                    var value: Double = 0
                    if error != nil {
                        print("something went wrong")
                    } else if let quantity = statistics?.sumQuantity() {
                        print("歩数歩数歩数歩数歩数歩数歩数歩数")
                        value = quantity.doubleValue(for: HKUnit.count())
                        completion(value)
                    }
                }
                self.store.execute(query)
            }
        }
        store.execute(query)
    }

    
    // 今日の歩数を取得するための関数
    func getMonthStep(completion: @escaping (Double) -> Void) {
//        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)
//        dateFormatter.dateFormat = "yyyy年MM月dd日"
//        let selectDate =  dateFormatter.string(from: from)
//        var component = NSCalendar.current.dateComponents([.year, .month, .day], from: from)
//        component.hour = 0
//        component.minute = 0
//        component.second = 0
//        let start:NSDate = NSCalendar.current.date(from:component)! as NSDate
//        //XX月XX日23時59分59秒に設定したものをendにいれる
//        component.hour = 23
//        component.minute = 59
//        component.second = 59
//        let end:NSDate = NSCalendar.current.date(from:component)! as NSDate

        
        let calendar = Calendar.current

        // 月初
        var comps = calendar.dateComponents([.year, .month], from: self.now)
        let start = calendar.date(from: comps)

        // 月末
        var add = DateComponents(month: 1, day: -1)
        let end = calendar.date(byAdding: add, to: start!)

        print("月初月初月初月初")
        print(start)

        print("月末月末月末月末")
        print(end)
        

        let type = HKSampleType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: start! as Date, end: end! as Date, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .separateBySource) { (query, data, error) in
            if let sources = data?.sources?.filter({ $0.bundleIdentifier.hasPrefix("com.apple.health") }) {
                let sourcesPredicate = HKQuery.predicateForObjects(from: Set(sources))
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, sourcesPredicate])
                let query = HKStatisticsQuery(quantityType: type,
                                              quantitySamplePredicate: predicate,
                                              options: .cumulativeSum)
                { (query, statistics, error) in
                    var value: Double = 0
                    if error != nil {
                        print("something went wrong")
                    } else if let quantity = statistics?.sumQuantity() {
                        print("歩数歩数歩数歩数歩数歩数歩数歩数")
                        value = quantity.doubleValue(for: HKUnit.count())
                        completion(value)
                    }
                }
                self.store.execute(query)
            }
        }
        store.execute(query)
    }
    
    
    
    //データの個数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return systemMenu.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //コレクションビューから識別子「TestCell」のセルを取得する。
        let cell = Menu.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath as IndexPath) as UICollectionViewCell

        // Tag番号を使ってLabelのインスタンス生成
        let label = cell.contentView.viewWithTag(2) as! UILabel
        label.text = systemMenu[indexPath.row]

        // Tag番号を使ってImageViewのインスタンス生成
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView

        let badge = cell.contentView.viewWithTag(3) as! UILabel
        badge.layer.cornerRadius = 13.0// 角の半径
        badge.clipsToBounds = true// この設定を入れないと角丸にならない
        
        if indexPath.row == 0 {
            let cellImage = UIImage(named: "foot")
            imageView.image = cellImage
            var count = userDefaults.object(forKey: "footprint") as! Int?
            if count != 0 {
                badge.text = String(count ?? 0)
                badge.backgroundColor = UIColor.red
            } else {
                badge.text = ""
                badge.backgroundColor = UIColor.clear
            }

        }
        if indexPath.row == 1 {
            let cellImage = UIImage(named: "like")
            imageView.image = cellImage

            var count = userDefaults.object(forKey: "like") as! Int?
            if count != 0 {
                badge.text = String(count ?? 0)
                badge.backgroundColor = UIColor.red
            } else {
                badge.text = ""
                badge.backgroundColor = UIColor.clear
            }
        }
        if indexPath.row == 2 {
            let cellImage = UIImage(named: "prolile")
            imageView.image = cellImage

            badge.text = ""
            badge.backgroundColor = UIColor.clear

        }
        if indexPath.row == 3 {
            let cellImage = UIImage(named: "favorite")
            imageView.image = cellImage
        }
        if indexPath.row == 4 {
            let cellImage = UIImage(named: "change")
            imageView.image = cellImage
        }
        if indexPath.row == 5 {
            let cellImage = UIImage(named: "notice")
            imageView.image = cellImage

            var count = userDefaults.object(forKey: "notice") as! Int?
            if count != 0 {
                badge.text = String(count ?? 0)
                badge.backgroundColor = UIColor.red
            } else {
                badge.text = ""
                badge.backgroundColor = UIColor.clear
            }

        }
        if indexPath.row == 6 {
            let cellImage = UIImage(named: "block")
            imageView.image = cellImage
            badge.text = ""
            badge.backgroundColor = UIColor.clear
        }
        if indexPath.row == 7 {
            let cellImage = UIImage(named: "setting")
            imageView.image = cellImage
        }
//        if indexPath.row == 8 {
//            let cellImage = UIImage(named: "out")
//            imageView.image = cellImage
//        }
        if indexPath.row == 8 {
            let cellImage = UIImage(named: "history")
            imageView.image = cellImage
        }
        if indexPath.row == 9 {
            let cellImage = UIImage(named: "stepdata")
            imageView.image = cellImage
        }

//        if indexPath.row == 11 {
//            let cellImage = UIImage(named: "stepdata")
//            imageView.image = cellImage
//        }

        if indexPath.row != 0 && indexPath.row != 1 && indexPath.row != 5 {
            badge.text = ""
            badge.backgroundColor = UIColor.clear
        }
        


        // 画像配列の番号で指定された要素の名前の画像をUIImageとする
        // UIImageをUIImageViewのimageとして設定

        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        print("collectionViewcollectionViewcollectionView")
        print(collectionView)

        // 例えば端末サイズの半分の width と height にして 2 列にする場合
        let width: CGFloat = UIScreen.main.bounds.width / 3.02
        let height = width - 35
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SDSDSDSDSDSDSDSDSD")
        print(indexPath.row)
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 6) {
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let multiple = storyboard.instantiateViewController(withIdentifier: "toMultiple") as? MultipleViewController
            multiple!.modalPresentationStyle = .fullScreen
            //ここが実際に移動するコードとなります
            multiple!.status = indexPath.row
            self.present(multiple!, animated: false, completion: nil)
        }

        if (indexPath.row == 2) {
            performSegue(withIdentifier: "toProfiletoProfile", sender: self)
        }
        if (indexPath.row == 4) {
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let multiple = storyboard.instantiateViewController(withIdentifier: "pointChange")
            //ここが実際に移動するコードとなります
            multiple.modalPresentationStyle = .fullScreen
            self.present(multiple, animated: false, completion: nil)

        }

        if (indexPath.row == 5) {
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let multiple = storyboard.instantiateViewController(withIdentifier: "toNotice")
            multiple.modalPresentationStyle = .fullScreen
            //ここが実際に移動するコードとなります
            self.present(multiple, animated: false, completion: nil)
        }
        if (indexPath.row == 7) {
            let storyboard: UIStoryboard = self.storyboard!
            let multiple = storyboard.instantiateViewController(withIdentifier: "menutable")
            multiple.modalPresentationStyle = .fullScreen
            self.present(multiple, animated: false, completion: nil)
        }
//
//        if (indexPath.row == 8) {
//            let alertController:UIAlertController =
//                UIAlertController(title:"退会する",message: "本当に退会しますか？",preferredStyle: .alert)
//            let defaultAction:UIAlertAction =
//                UIAlertAction(title: "退会する",style: .destructive,handler:{
//                (action:UIAlertAction!) -> Void in
//                    print("退会する")
//                    self.userDeletApi()
//                })
//            let cancelAction:UIAlertAction =
//                UIAlertAction(title: "キャンセル",style: .cancel,handler:{
//                (action:UIAlertAction!) -> Void in
//                    print("キャンセル")
//                })
//            alertController.addAction(cancelAction)
//            alertController.addAction(defaultAction)
//            present(alertController, animated: true, completion: nil)
//        }

        if (indexPath.row == 8) {
            let storyboard: UIStoryboard = self.storyboard!
            let multiple = storyboard.instantiateViewController(withIdentifier: "toPointHistory")
            multiple.modalPresentationStyle = .fullScreen
            self.present(multiple, animated: false, completion: nil)
        }

        if (indexPath.row == 9) {
            let storyboard: UIStoryboard = self.storyboard!
            let multiple = storyboard.instantiateViewController(withIdentifier: "toMyData") as! MyDateStepViewController
            multiple.modalPresentationStyle = .fullScreen
            multiple.weight = self.weight
            self.present(multiple, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func MyDataButton(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let multiple = storyboard.instantiateViewController(withIdentifier: "toMyData") as! MyDateStepViewController
        multiple.modalPresentationStyle = .fullScreen
        multiple.weight = self.weight
        
        print("!ooooooooo")
        print(self.weight)
        
        self.present(multiple, animated: true, completion: nil)
    }
    
    
    
    
    
    func pushAction_1() {
        let uiAlertControl = UIAlertController(title: "Photo", message: "Photo of the Day", preferredStyle: .alert)
        let uiImageAlertAction = UIAlertAction(title: "", style: .default, handler: nil)
        let image = UIImage(named: "alert")
        uiImageAlertAction.setValue(image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
        
        uiAlertControl.addAction(uiImageAlertAction)
        // Cancel のaction
        let cancelAction:UIAlertAction =
            UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                print("キャンセル")
            })
        // actionを追加
        uiAlertControl.addAction(cancelAction)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: uiAlertControl.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 480)
        uiAlertControl.view.addConstraint(height)
        self.present(uiAlertControl, animated: true, completion: nil)
    }
    
    @IBAction func toMyDeataStep(_ sender: Any) {
    }
    
    @IBAction func backFromPlaninputView(segue:UIStoryboardSegue){
        NSLog("PlaninputViewController#backFromPlaninputView")
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

public extension String {
    public func labelHeight(width: CGFloat,
        font: UIFont,
        lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGSize {
            let size = CGSize(width: width, height: .greatestFiniteMagnitude)
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = lineBreakMode
            return (self as NSString).boundingRect(
            with: size, options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font, .paragraphStyle: style], context: nil).size
    }
}



extension MyDataViewController : MyDataModelDelegate {
    func onFinally(model: MyDataModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
    
    func onStart(model: MyDataModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: MyDataModel, count: Int) {
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
        
        
        //
        var count: Int = 0;
        //        for(key, code) in dataSourceOrder.enumerated() {
        //            count+=1;
        //            if let jenre: ApiUserDateParam = dataSource[code] {
        //                //取得したデータを元にコレクションを再構築＆更新
        //                mapMenuView.addTagGroup(model: model, jenre: jenre);
        //            }
        //        }

        
        self.returnView()
        Menu.reloadData()


    }
    func onFailed(model: MyDataModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }

    func onError(model: MyDataModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }
    
}


