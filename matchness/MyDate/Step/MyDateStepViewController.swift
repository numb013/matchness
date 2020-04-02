//
//  MyDateStepViewController.swift
//  matchness
//
//  Created by user on 2019/06/27.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import CoreMotion
import MBCircularProgressBar
import Charts
import HealthKit

class MyDateStepViewController: UIViewController {
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var leftbuttonLabel: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var progressViewBar: MBCircularProgressBarView!
    @IBOutlet weak var barChartView: BarChartView!

    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet var leftSlide: UISwipeGestureRecognizer!
    @IBOutlet var rightSlide: UISwipeGestureRecognizer!
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    var activityIndicatorView = UIActivityIndicatorView()
    
    
    var step = 0
    let dateFormatter = DateFormatter()
    let now = Date()
    var day = 0
    var counter = 0.0
    var step_1: [Double] = []
    var timer_flag:Bool = true
    // 時間計測用の変数.
    var count : Double = 0
    var steps = 0.0
    // タイマー
    var timer : Timer!
    var timer_key = ""
    let formatter = DateComponentsFormatter()
    // 一時停止の際の時間を格納する
    var pauseTime:Float = 0
    var weight = Int()
    

//    let activity = CMMotionActivityManager()
    let store = HKHealthStore()

    var vibrateFlg:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
//        getStepDate()
        getStepDate()
        getDistance()
        getStepTime()

        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(MyDateStepViewController.onUpdate(timer:)), userInfo: nil, repeats: true)
//        Activity()
        self.playLabel.text = "STEP"
    }

    func getStepDate() {
        rightButton.isEnabled = false
        leftButton.isEnabled = false
        rightSlide.isEnabled = false
        leftSlide.isEnabled = false

        getDayStep { (result) in
            DispatchQueue.main.async {
                self.stepCountLabel.text = "\(Int(result))"
                self.progressViewBar.value = (CGFloat(Double(result) / 10000)*100)

                self.count = Double(result) / 1.7

print("これなんぞこれなんぞこれなんぞこれなんぞ")
print(self.count)

                self.formatter.unitsStyle = .positional
                self.formatter.allowedUnits = [.hour, .minute, .second]
                let str = self.formatter.string(from: self.count)
                var weight_param = Double(ApiConfig.WEIGHT_LIST[self.weight ?? 0])
                var hour = self.count / 3600
                var kacl = 1.05 * (3.3 * hour) * Double(weight_param!)
                self.kcalLabel.text = "\(floor(kacl*10)/10)kcal"
                // ラベルに表示
                self.timeLabel.text = str

                self.activityIndicatorView.stopAnimating()
            }
        }
    }

    func getDistance() {
        // getTodaysStep関数へ値を渡す。
        getDayDistance { (result) in
            DispatchQueue.main.async {
                print("kkkkkk距離距離距離距離")
                var distance = result
                var distance_data = (Double(distance) / 1000)
                var distance_para = round(distance_data*10)/10
                self.distance.text = "\(distance_para)km"
            }
        }
    }

    // 今日の歩数を取得するための関数
    func getDayStep(completion: @escaping (Double) -> Void) {
        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let selectDate =  dateFormatter.string(from: from)
        let date = Date()
        self.schedule.text = "\(selectDate + "(" + from.weekday + ")")"

        var key = dateFormatter.string(from: now)
        self.timer_key = selectDate + "step_time"

        if day == 0 {
            leftbuttonLabel.isHidden = true
        } else {
            leftbuttonLabel.isHidden = false
        }

        if UserDefaults.standard.object(forKey: timer_key) != nil {
            self.count = userDefaults.object(forKey: timer_key) as! Double
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.hour, .minute, .second]
            let str = formatter.string(from: self.count)
            // ラベルに表示
            timeLabel.text = str
        } else {
            self.count = 0
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
                        value = quantity.doubleValue(for: HKUnit.count())
                        completion(value)
                    }
                }
                self.store.execute(query)
            }
        }
        store.execute(query)
    }
    
    func getDayDistance(completion: @escaping (Double) -> Void) {
        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)
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
        let type =  HKSampleType.quantityType(forIdentifier:HKQuantityTypeIdentifier.distanceWalkingRunning)
        let predicate = HKQuery.predicateForSamples(withStart: start as Date, end: end as Date, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type!, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { query, result, error in
            var value: Double = 0
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.meter()))
        }
        store.execute(query)
    }

    func getStepTime() {
        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)
        var component = NSCalendar.current.dateComponents([.year, .month, .day], from: from)
        var dataEntries: [BarChartDataEntry] = []
        self.counter = 0.0
        //XX月XX日23時59分59秒に設定したものをendにいれる
        for i in 0..<24{
            component.hour = i
            component.minute = 0
            component.second = 0
            let start:NSDate = NSCalendar.current.date(from:component)! as NSDate
            component.hour = i
            component.minute = 59
            component.second = 59
            let end:NSDate = NSCalendar.current.date(from:component)! as NSDate

            let type = HKSampleType.quantityType(forIdentifier: .stepCount)!
            let predicate = HKQuery.predicateForSamples(withStart: start as Date, end: end as Date)
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    return
                }
                // 取得したデータを（１）のデータ配列に設定
                self.steps = Double(sum.doubleValue(for: HKUnit.count()))
                let dataEntry = BarChartDataEntry(x: Double(i), y: self.steps)
                dataEntries.append(dataEntry)
                self.counter += 1

                if (dataEntries.count == 24) {
                    print("AAAAAAAAAAA")
                    print(self.counter)

                    self.barChartView.animate(yAxisDuration: 0.1)
                    self.barChartView.rightAxis.axisMinimum = 0
                    self.barChartView.leftAxis.axisMinimum = 0
                    //                    self.barChartView.leftAxis.axisMaximum = 1000.0
                    //右軸（値）の非表示
                    self.barChartView.rightAxis.drawLabelsEnabled = false

                    //self.barChartView.leftAxis.enabled  = true  //左軸（値）の表示
                    // y軸のグリッド表示（今回は非表示する
                    self.barChartView.xAxis.drawGridLinesEnabled = false
                    self.barChartView.xAxis.labelPosition = .bottom
                    self.barChartView.xAxis.labelCount = 12
//
                    self.barChartView.chartDescription?.enabled = false
                    self.barChartView.legend.enabled = false
                    self.barChartView.doubleTapToZoomEnabled = false

                    self.barChartView.pinchZoomEnabled = false
                    self.barChartView.doubleTapToZoomEnabled = false

                    self.barChartView.scaleXEnabled = false
                    self.barChartView.scaleYEnabled = false
                    self.barChartView.dragEnabled = false
//                    self.barChartView.notifyDataSetChanged()
                    self.barChartView.highlightPerTapEnabled = true

                    print(dataEntries)
                    print(dataEntries.count)
                    
                    let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
                    chartDataSet.drawValuesEnabled = false
                    chartDataSet.colors = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)]
                    self.barChartView.data = BarChartData(dataSet: chartDataSet)

                    let dispatchTime = DispatchTime.now() + 0.2
                    DispatchQueue.main.asyncAfter( deadline: dispatchTime ) {
                        self.rightButton.isEnabled = true
                        self.leftButton.isEnabled = true
                        self.rightSlide.isEnabled = true
                        self.leftSlide.isEnabled = true
                    }

                }
            }
            self.store.execute(query)
        }
    }

    @IBAction func leftSlide(_ sender: Any) {
        if (day > 0) {
            day = day - 1
            self.step_1 = []
            getStepDate()
            getDistance()
            getStepTime()
        }
    }
    @IBAction func rightSlide(_ sender: Any) {
        day = day + 1
        self.step_1 = []
        getStepDate()
        getDistance()
        getStepTime()
    }

    @IBAction func leftButton(_ sender: Any) {
        if (day > 0) {
            day = day - 1
            self.step_1 = []
            getStepDate()
            getDistance()
            getStepTime()
        }
    }
    
    @IBAction func rightButton(_ sender: Any) {
        day = day + 1
        self.step_1 = []
        getStepDate()
        getDistance()
        getStepTime()
    }

    @IBAction func toDayButtom(_ sender: Any) {
        self.day = 0
        self.step_1 = []
        getStepDate()
        getDistance()
        getStepTime()
    }
    
//
//   func Activity() {
//       //CMMotionActivityManagerの確認
//       if CMMotionActivityManager.isActivityAvailable() {
//           activity.startActivityUpdates(to: OperationQueue.current!,
//             withHandler: {activityData in
//               DispatchQueue.main.async(execute: { () -> Void in
//                   if(activityData?.stationary == true){
//                       if (self.timer_flag == true) {
//                           print("止まっている")
//                           self.stopBtnTap()
//                       }
//                       self.playLabel.text = "STOP"
//                       self.vibrateFlg = false
//                   } else if (activityData?.walking == true){
//                       if (self.timer_flag == false) {
//                           print("あるいている")
//                           self.startBtnTap()
//                       }
//                       self.playLabel.text = "WORKING"
//                       self.vibrateFlg = false
//                   } else if (activityData?.running == true){
//
//                       if (self.timer_flag == false) {
//                           print("走ってる")
//                           self.startBtnTap()
//                       }
//
//                       self.playLabel.text = "RUNNING"
//                       self.vibrateFlg = true
//                   } else if (activityData?.automotive == true){
//
//                       if (self.timer_flag == true) {
//                           print("乗り物")
//                           self.stopBtnTap()
//                       }
//
//                       self.playLabel.text = "VEHICLE"
//                       self.vibrateFlg = false
//                   }
//               })
//           })
//       }
//   }

    

    
    
   // TimerのtimeIntervalで指定された秒数毎に呼び出されるメソッド
   @objc func onUpdate(timer : Timer){
       if (day == 0) {
           // カウントの値1増加
           count += 1
           var weight_param = Double(ApiConfig.WEIGHT_LIST[self.weight ?? 0])
        self.activityIndicatorView.stopAnimating()
        
           print("ASASASASASASASS")
           print(self.weight)
           print(weight_param)
           formatter.unitsStyle = .positional
           formatter.allowedUnits = [.hour, .minute, .second]
           let str = formatter.string(from: count)
           var hour = count / 3600
           var kacl = 1.05 * 3 * hour * Double(weight_param!)
           kcalLabel.text = "\(floor(kacl*10)/10)kcal"
           // ラベルに表示
           timeLabel.text = str
           UserDefaults.standard.set(count, forKey: self.timer_key)
       }
   }
   // カウントを停止するメソッド
   func stopBtnTap() {
       print("ストップストップストップ")
       timer.invalidate()
       self.timer_flag = false
   }
   // カウントの停止を解除するメソッド
   func startBtnTap() {
       // 新たにタイマーを作る
       timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MyDateStepViewController.onUpdate(timer:)), userInfo: nil, repeats: true)
       self.timer_flag = true
   }

}


extension Date {
    var weekday: String {
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.weekday, from: self)
        let weekday = component - 1
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja")
        return formatter.weekdaySymbols[weekday]
    }
}
