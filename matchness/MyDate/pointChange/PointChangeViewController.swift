//
//  PointChangeViewController.swift
//  matchness
//
//  Created by user on 2019/07/18.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import CoreMotion


class PointChangeViewController: UIViewController{
    
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var userPoint: UILabel!

    @IBOutlet weak var todayStep: UILabel!
    @IBOutlet weak var yesterdayStep: UILabel!
    @IBOutlet weak var dayAfterTomorrowStep: UILabel!

    @IBOutlet weak var todayPoint: UILabel!
    @IBOutlet weak var yesterdayPoint: UILabel!
    @IBOutlet weak var dayAfterTomorrowPoint: UILabel!

    @IBOutlet weak var t_button: UIButton!
    @IBOutlet weak var y_button: UIButton!
    @IBOutlet weak var d_button: UIButton!
    var ActivityIndicator: UIActivityIndicatorView!
    var t_Point = 0
    var y_Point = 0
    var d_Point = 0

    var change_point = "0"
    var day_type = "0"
    
    var dataSource: Dictionary<String, ApiChangePoint> = [:]
    var dataSourceOrder: Array<String> = []
    var cellCount: Int = 0
    
    var todayPointChenge = 90
    var yesterdayPointChenge = 190
    var dayAfterTomorrowPointChenge = 390

    let dateFormatter = DateFormatter()
    let now = Date()
    var day = 0
    var from = Date()
    var yestarday = Date()
//    var step_data = [Int]()
    var step_data:[Int] = [100, 200, 300]

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.step_data = []
        for i in 1..<4 {
            self.day = i
            getStepDate()
        }
//        UserDefaults.standard.removeObject(forKey: "customer_status")
        apiRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        apiRequest()
        print("ViewController/viewWillAppear/画面が表示される直前")
    }
    
    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestPointChangeModel = PointChangeModel();
        requestPointChangeModel.delegate = self as! PointChangeModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_POINT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String

        print("ユーザーIDユーザーIDユーザーIDユーザーID")
        print(matchness_user_id)

        query["user_id"] = matchness_user_id
        //リクエスト実行
        if( !requestPointChangeModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    
    func pointView() {
        print("みんな")
        print(self.step_data)
        var tunagi = " / "
        var step_data1 = self.dataSource["0"]
        self.userPoint.text = step_data1?.point

        self.todayStep.text = step_data1!.todayPointChenge! + tunagi + String(self.step_data[0])
        self.yesterdayStep.text = step_data1!.yesterdayPointChenge! + tunagi + String(self.step_data[1])
        self.dayAfterTomorrowStep.text = step_data1!.dayAfterTomorrowPointChenge! + tunagi + String(self.step_data[2])

        self.t_Point = self.step_data[0] - Int((step_data1?.todayPointChenge!)!)!
        self.y_Point = self.step_data[1] - Int((step_data1?.yesterdayPointChenge!)!)!
        self.d_Point = self.step_data[2] - Int((step_data1?.dayAfterTomorrowPointChenge!)!)!

        self.todayPoint.text = String(Int(floor(Double(self.t_Point) * 0.01)))
        self.yesterdayPoint.text = String(Int(floor(Double(self.y_Point) * 0.01)))
        self.dayAfterTomorrowPoint.text = String(Int(floor(Double(self.d_Point) * 0.01)))

        t_button.isEnabled = self.t_Point == 0 ? false : true // ボタン無効
        y_button.isEnabled = self.y_Point == 0 ? false : true // ボタン無効
        d_button.isEnabled = self.d_Point == 0 ? false : true // ボタン無効
    }
    
    
    let pedometer:CMPedometer = CMPedometer()//プロパティでCMPedometerをインスタンス化。
    
    func getStepDate() {
        //歩数が取得できるかどうかチェックしてます
        if(!CMPedometer.isStepCountingAvailable()) {
            print("cannot get stepcount")
        }
        if self.day == 1 {
            from = Date(timeInterval: TimeInterval(-60*60*24*0), since: now)
        }
        if self.day == 2 {
            from = Date(timeIntervalSinceNow: -60 * 60 * 24)
            self.yestarday = from
        }
        if self.day == 3 {
            from = Date(timeInterval: -60 * 60 * 24, since: self.yestarday)
        }
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
        //現在を取得してます。
        pedometer.queryPedometerData(from: start as Date, to: end as Date) { (data, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.step_data.append(Int(data.numberOfSteps))
                if self.step_data.canAccess(index: 0) {
                    // 取得できたときの処理
                    self.todayStep.text = "\(self.todayPointChenge) / \(self.step_data[0])"
                }
                if self.step_data.canAccess(index: 1) {
                    // 取得できたときの処理
                    self.yesterdayStep.text = "\(self.yesterdayPointChenge) / \(self.step_data[1])"
                }
                if self.step_data.canAccess(index: 2) {
                    // 取得できたときの処理
                    self.dayAfterTomorrowStep.text = "\(self.dayAfterTomorrowPointChenge) / \(self.step_data[2])"
                }
            }
        }
    }

    @IBAction func todayChangeButtom(_ sender: Any) {
        self.change_point = String(self.t_Point)
        self.day_type = "0"
        t_button.isEnabled = false
        requestUpdatePoint()
    }
    
    @IBAction func yesterdayChangeButtom(_ sender: Any) {
        self.change_point = String(self.y_Point)
        self.day_type = "1"
        y_button.isEnabled = false
        requestUpdatePoint()
    }
    
    @IBAction func dayAfterTomorrowChangButtom(_ sender: Any) {
        self.change_point = String(self.d_Point)
        self.day_type = "2"
        d_button.isEnabled = false
        requestUpdatePoint()
    }
    
    func requestUpdatePoint()
    {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestPointChangeModel = PointChangeModel();
        requestPointChangeModel.delegate = self as! PointChangeModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ADD_POINT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var matchness_user_id = userDefaults.object(forKey: "matchness_user_id") as? String
        
        query["user_id"] = matchness_user_id
        query["day_type"] = self.day_type
        query["change_point"] = self.change_point
        //リクエスト実行
        if( !requestPointChangeModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    @IBAction func backFromPlaninputView(segue:UIStoryboardSegue){
        NSLog("PlaninputViewController#backFromPlaninputView")
    }

    @IBAction func paymentButton(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let multiple = storyboard.instantiateViewController(withIdentifier: "pointPayment")
        multiple.modalPresentationStyle = .fullScreen
        self.present(multiple, animated: false, completion: nil)
    }
}

extension Array {
    func canAccess(index: Int) -> Bool {
        return self.count-1 >= index
    }
}



extension PointChangeViewController : PointChangeModelDelegate {
    func onFinally(model: PointChangeModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    
    
    func onStart(model: PointChangeModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: PointChangeModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        print(self.dataSourceOrder)
        print("耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳耳")
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
        var count: Int = 0;
        print("ががががががががが")
        print(self.dataSource)
        print(self.dataSourceOrder)

        self.pointView()
    }
    func onFailed(model: PointChangeModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }

    func onError(model: PointChangeModel) {
        ActivityIndicator.stopAnimating()
        let alertController:UIAlertController = UIAlertController(title:"サーバーエラー",message: "アプリを再起動してください",preferredStyle: .alert)
        // Default のaction
        let defaultAction:UIAlertAction = UIAlertAction(title: "アラートを閉じる",style: .destructive,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                //  self.dismiss(animated: true, completion: nil)
            })
        alertController.addAction(defaultAction)
        // UIAlertControllerの起動
        self.present(alertController, animated: true, completion: nil)
    }
}

