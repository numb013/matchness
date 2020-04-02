//
//  GroupEventViewController.swift
//  matchness
//
//  Created by user on 2019/06/22.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import HealthKit

class GroupEventViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak internal var eventTime: UILabel!
    @IBOutlet weak internal var peopleNumber: UILabel!
    @IBOutlet weak internal var rank: UILabel!
    @IBOutlet weak internal var stepNumber: UILabel!
    @IBOutlet weak var ChatButtom: UIButton!
    
    @IBOutlet weak internal var groupEvent: UICollectionView!
    var group_step:Int = 0
    
    var dataSource: Dictionary<String, ApiGroupEvent> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]

    var cellCount: Int = 0
    let now = Date()
    var group_param = [String:Any]()
    let dateFormatter = DateFormatter()
    let store = HKHealthStore()
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;

//    let pedometer:CMPedometer = CMPedometer()//プロパティでCMPedometerをインスタンス化。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupEvent.delegate = self
        groupEvent.dataSource = self
        if HKHealthStore.isHealthDataAvailable() {
            let readDataTypes: Set<HKObjectType> = [
             HKObjectType.quantityType(forIdentifier:HKQuantityTypeIdentifier.stepCount)!,
             HKObjectType.quantityType(forIdentifier:HKQuantityTypeIdentifier.distanceWalkingRunning)!
            ]
            // 許可されているかどうかを確認
            store.requestAuthorization(toShare: nil, read: readDataTypes as? Set<HKObjectType>) {
                (success, error) -> Void in
                print(success)
                print("success")
            }
        } else{
            Alert.helthError(alertNum: self.errorData, viewController: self)
        }

        self.groupEvent.register(UINib(nibName: "GroupEventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "groupCell")
//        getGroupStep_1(progress_day: group_param["progress_day"] as! Int)
        getStepDate()
    }

    func viewMain() {
        print("メインメインメインメインメイン")
        print(dataSource["0"]?.status)
        rank.text = dataSource["0"]!.rank! + "位"
        eventTime.text = dataSource["0"]?.event_time
        peopleNumber.text = dataSource["0"]?.event_peple
        stepNumber.text = dataSource["0"]?.step
        if dataSource["0"]?.status == 2 {
            ChatButtom.isEnabled = false
        }
    }

    
    func getStepDate() {
        print("イベントグループイベントグループイベントグループ")
        
        getDayStep { (result) in
            DispatchQueue.main.async {
                print(result)
                self.group_step = Int(result)
                self.apiRequestGroupEvent()
                // self.progressViewBar.value = (CGFloat(Double(result) / 10000)*100)
            }
        }
    }

    // 今日の歩数を取得するための関数
    func getDayStep(completion: @escaping (Double) -> Void) {

        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"

        let startdate = dateFormater.date(from: group_param["start"] as! String)
        var component = NSCalendar.current.dateComponents([.year, .month, .day], from: startdate!)
        component.hour = 0
        component.minute = 0
        component.second = 0
        let start:NSDate = NSCalendar.current.date(from:component)! as NSDate

        print("GGGGGGGGGGGGGG")
        print(startdate)
        print(start)

        
        
        let enddate = dateFormater.date(from: group_param["end"] as! String)
        var component_end = NSCalendar.current.dateComponents([.year, .month, .day], from: enddate!)
        //XX月XX日23時59分59秒に設定したものをendにいれる
        component_end.hour = 23
        component_end.minute = 59
        component_end.second = 59
        let end:NSDate = NSCalendar.current.date(from:component_end)! as NSDate

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

    func apiRequestGroupEvent() {


print("イベントグループ取得取得取得取得")

        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestGroupModel = GroupEventModel();
        requestGroupModel.delegate = self as! GroupEventModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_GROUP_EVENT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["group_id"] = group_param["group_id"] as! String
        query["total_step"] = String(self.group_step)
        //リクエスト実行
        if( !requestGroupModel.requestApi(url: requestUrl, addQuery: query) ){

        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GroupEventCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath as IndexPath) as! GroupEventCollectionViewCell
        let label = UILabel()
        

        var group_event = dataSource["0"]!.group_event[indexPath.row]


        if (group_event.profile_image == nil) {
            cell.userImage.image = UIImage(named: "no_image")
        } else {
            let profileImageURL = image_url + group_event.profile_image!
            let url = NSURL(string: profileImageURL);
            let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
            cell.userImage.image = UIImage(data:imageData! as Data)
        }
        
        cell.userImage.contentMode = .scaleAspectFill
        cell.userImage.clipsToBounds = true
        cell.userImage.layer.cornerRadius =  cell.userImage.frame.height / 2
        cell.userImage.isUserInteractionEnabled = true
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        recognizer.targetUserId = group_event.user_id
        cell.userImage.addGestureRecognizer(recognizer)
        

        
        cell.lastLoginTime.textColor = UIColor.white
        cell.userInfo.textColor = UIColor.white
        cell.userStep.textColor = UIColor.white
        cell.step.textColor = UIColor.white

        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = dateFormater.date(from: group_event.action_datetime as! String)
        dateFormater.dateFormat = "MM月dd日 HH時mm分"
        let date_text = dateFormater.string(from: date ?? Date())
        
        cell.lastLoginTime.text = "ログイン：" + date_text
        var name = group_event.name!
        var age = group_event.age! + "歳 "
        var prefecture = ApiConfig.PREFECTURE_LIST[group_event.prefecture_id ?? 0]
        cell.userInfo.text = name + " " + age + prefecture
        cell.userStep.text = group_event.step
        cell.contentView.addSubview(label)
        
        if Int(group_event.step ?? "0")! < 15000 {
            cell.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 254/255, green: 0, blue: 124/255, alpha: 1)
        }
        
        return cell
    }

    
    @objc func onTap(_ sender: MyTapGestureRecognizer) {
        var user_id = sender.targetUserId!
        let storyboard: UIStoryboard = self.storyboard!
        let nextVC = storyboard.instantiateViewController(withIdentifier: "toUserDetail") as! UserDetailViewController
        nextVC.user_id = user_id
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    

    @IBAction func groupChatButtom(_ sender: Any) {
            self.performSegue(withIdentifier: "toGroupChat", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // SecondViewControllerに移動する変数vcを定義する
        let vc = segue.destination as! GroupChatViewController
        //ViewController2のtextにtextFieldのテキストを代入
        vc.group_id = self.group_param["group_id"] as! String
        
    }
    
    @IBAction func backGroupEventView(segue:UIStoryboardSegue){
        NSLog("backGroupEventView#backFromPlaninputView")
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

extension GroupEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 例えば端末サイズの半分の width と height にして 2 列にする場合
        let width: CGFloat = UIScreen.main.bounds.width / 2.01
        let height: CGFloat = 90
        return CGSize(width: width, height: height)
    }
}




extension GroupEventViewController : GroupEventModelDelegate {
    func onFinally(model: GroupEventModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
    
    func onStart(model: GroupEventModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: GroupEventModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        //cellの件数更新
        self.cellCount = dataSource["0"]!.group_event.count;
        var count: Int = 0;
        viewMain()
        groupEvent.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    func onFailed(model: GroupEventModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }

    func onError(model: GroupEventModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }

}

