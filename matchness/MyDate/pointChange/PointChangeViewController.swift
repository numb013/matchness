//
//  PointChangeViewController.swift
//  matchness
//
//  Created by user on 2019/07/18.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import CoreMotion
import HealthKit

class PointChangeViewController: UIViewController{
    

    
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
    let store = HKHealthStore()

    var t_Point = 0
    var y_Point = 0
    var d_Point = 0

    var change_point = "0"
    var day_type = "0"
    var errorData: Dictionary<String, ApiErrorAlert> = [:]

    var dataSource: Dictionary<String, ApiChangePoint> = [:]
    var dataSourceOrder: Array<String> = []
    var cellCount: Int = 0
    
    var todayPointChenge = 0
    var yesterdayPointChenge = 0
    var dayAfterTomorrowPointChenge = 0

    let dateFormatter = DateFormatter()
    let now = Date()
    var day = 0
    var from = Date()
    var yestarday = Date()
//    var step_data = [Int]()
    var step_data = [0,0,0]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if HKHealthStore.isHealthDataAvailable()
        {
            let readDataTypes: Set<HKObjectType> = [
             HKObjectType.quantityType(forIdentifier:HKQuantityTypeIdentifier.stepCount)!
            ]
            // 許可されているかどうかを確認
            store.requestAuthorization(toShare: nil, read: readDataTypes as? Set<HKObjectType>) {
                (success, error) -> Void in
                print(success)
                print("success")
            }
        }else{
            Alert.helthError(alertNum: self.errorData, viewController: self)
            print("OUT")
        }
        getStepDate1()
        getStepDate2()
        getStepDate3()
        
        UserDefaults.standard.removeObject(forKey: "customer_status")
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
        //リクエスト実行
        if( !requestPointChangeModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    
    func pointView() {
        print("みんな")
        print(self.step_data)
        print(self.dataSource["0"])
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

        
print("今日のポイント")
print(self.t_Point)
print("昨日のポイント")
print(self.y_Point)
print("一昨日のポイント")
print(self.d_Point)
        
        t_button.isEnabled = self.t_Point <= 100 ? false : true // ボタン無効
        self.todayPoint.textColor =  self.t_Point <= 100 ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        y_button.isEnabled = self.y_Point <= 100 ? false : true // ボタン無効
        self.yesterdayPoint.textColor =  self.y_Point <= 100 ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        d_button.isEnabled = self.d_Point <= 100 ? false : true // ボタン無効
        self.dayAfterTomorrowPoint.textColor = self.d_Point <= 100 ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)

    }
    
    func getStepDate1() {
        self.day = 1
        getDayStep { (result) in
            DispatchQueue.main.async {
                self.step_data[0] = Int(result)
                self.todayStep.text = "\(self.todayPointChenge) / \(self.step_data[0])"

            }
        }
    }
    func getStepDate2() {
        self.day = 2
        getDayStep { (result) in
            DispatchQueue.main.async {
                self.step_data[1] = Int(result)
                self.yesterdayStep.text = "\(self.yesterdayPointChenge) / \(self.step_data[1])"

            }
        }
    }
    func getStepDate3() {
        self.day = 3
        getDayStep { (result) in
            DispatchQueue.main.async {
                self.step_data[2] = Int(result)
                self.dayAfterTomorrowStep.text = "\(self.dayAfterTomorrowPointChenge) / \(self.step_data[2])"

            }
        }
    }

    // 今日の歩数を取得するための関数
    func getDayStep(completion: @escaping (Double) -> Void) {
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
                        print(quantity.doubleValue(for: HKUnit.count()))
                        value = quantity.doubleValue(for: HKUnit.count())
                        completion(value)
                    }
                }
                self.store.execute(query)
            }
        }
        store.execute(query)
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
        print("canAccess!!!!!!!")
        print(index)
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
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }

}

