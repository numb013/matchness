//
//  GroupEventViewController.swift
//  matchness
//
//  Created by user on 2019/06/22.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import CoreMotion

class GroupEventViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak internal var eventTime: UILabel!
    @IBOutlet weak internal var peopleNumber: UILabel!
    @IBOutlet weak internal var rank: UILabel!
    @IBOutlet weak internal var stepNumber: UILabel!
    @IBOutlet weak internal var groupEvent: UICollectionView!
    var ActivityIndicator: UIActivityIndicatorView!
    var group_step:Int = 0
    
    var dataSource: Dictionary<String, ApiGroupEvent> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]

    var cellCount: Int = 0
    let now = Date()
    var group_param = [String:Any]()
    let stepInstance = TodayStep()
    let pedometer:CMPedometer = CMPedometer()//プロパティでCMPedometerをインスタンス化。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupEvent.delegate = self
        groupEvent.dataSource = self
        self.groupEvent.register(UINib(nibName: "GroupEventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "groupCell")
        getGroupStep_1(progress_day: group_param["progress_day"] as! Int)
    }

    func viewMain() {
        print("メインメインメインメインメイン")
        print(dataSource["0"])
        rank.text = dataSource["0"]!.rank! + "位"
        eventTime.text = dataSource["0"]?.event_time
        peopleNumber.text = dataSource["0"]?.event_peple
        stepNumber.text = dataSource["0"]?.step
    }

    func getGroupStep_1(progress_day:Int) -> Int {
        print("きて流きて流きて流きて流")
        print(progress_day)
        //歩数が取得できるかどうかチェックしてます
        if(!CMPedometer.isStepCountingAvailable()) {
            print("クラスクラスcannot get stepcount")
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let from = Date(timeInterval: TimeInterval(-60*60*24*progress_day), since: now)
        var component = NSCalendar.current.dateComponents([.year, .month, .day], from: from)
        component.hour = 0
        component.minute = 0
        component.second = 0
        let start:NSDate = NSCalendar.current.date(from:component)! as NSDate
        //XX月XX日23時59分59秒に設定したものをendにいれる
        print("startDatestartDatestartDatestartDate")
        print(start)
        print(Date())
        
        // onetime
        pedometer.queryPedometerData(from: start as Date, to: Date()) { (data, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                print("歩数歩数歩数は\(data.numberOfSteps)")
                print(data.numberOfSteps)
                print(data)
                self.group_step = Int(data.numberOfSteps)
                self.apiRequestGroupEvent()
            }
        }
        return self.group_step
    }

    
    func apiRequestGroupEvent() {
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
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String
        
        print("queryqueryquery")
        query["user_id"] = matchness_user_id
        query["group_id"] = group_param["group_id"] as! String
        
        print(group_param)
        //var total_step = getGroupStep_1(progress_day:group_param["progress_day"] as! Int)
        
        query["total_step"] = String(self.group_step)
        
        print("total_steptotal_steptotal_steptotal_step")
        print(query)
        print("アウトアウトアウトアウトアウトr")
        
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

        var number = Int.random(in: 1 ... 18)
        cell.userImage.image = UIImage(named: "\(number)")
        cell.userImage.contentMode = .scaleAspectFill
        cell.userImage.clipsToBounds = true
        cell.userImage.layer.cornerRadius =  cell.userImage.frame.height / 2
        cell.userImage.isUserInteractionEnabled = true
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        recognizer.targetUserId = group_event.user_id
        cell.userImage.addGestureRecognizer(recognizer)
        

        let userStep = Int.random(in: 5000 ... 120000)
        cell.lastLoginTime.textColor = UIColor.white
        cell.userInfo.textColor = UIColor.white
        cell.userStep.textColor = UIColor.white
        cell.step.textColor = UIColor.white

        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")

        dateFormater.dateFormat = "yyyy-MM-dd HH:mm"

print("ログイン時間ログイン時間ログイン時間")

        let date = dateFormater.date(from: "2000-01-01 03:12:12 +0000")
        print(group_event.action_datetime)
        print(group_event)
        print(date)


        let date_text = dateFormater.string(from: date ?? Date())
        
        cell.lastLoginTime.text = "ログイン：" + date_text
        var name = group_event.name!
        var age = group_event.age! + "歳 "
        var prefecture = ApiConfig.PREFECTURE_LIST[group_event.prefecture_id ?? 0]
        cell.userInfo.text = name + " " + age + prefecture
        cell.userStep.text = group_event.step
        cell.contentView.addSubview(label)
        
        if userStep < 50000 {
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

