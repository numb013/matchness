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

    
    var step = 0
    let dateFormatter = DateFormatter()
    let now = Date()
    var day = 0
    var counter = 0.0
    var step_1: [Double] = []

    var timer_flag:Bool = true
    // 時間計測用の変数.
    var count : Double = 0
    // タイマー
    var timer : Timer!
    var timer_key = ""
    
    let formatter = DateComponentsFormatter()

    // 一時停止の際の時間を格納する
    var pauseTime:Float = 0
    var weight = Int()
    
    let pedometer:CMPedometer = CMPedometer()
    let activity = CMMotionActivityManager()

 var vibrateFlg:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
print("weightweightweightweight")
print(weight)
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })


        getStepDate()

        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(MyDateStepViewController.onUpdate(timer:)), userInfo: nil, repeats: true)

        Activity()
    }

    func Activity() {
        //CMMotionActivityManagerの確認
        if CMMotionActivityManager.isActivityAvailable() {
            activity.startActivityUpdates(to: OperationQueue.current!,
              withHandler: {activityData in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(activityData?.stationary == true){
                        if (self.timer_flag == true) {
                            print("止まっている")
                            self.stopBtnTap()
                        }
                        self.playLabel.text = "止まっている"
                        self.vibrateFlg = false
                    } else if (activityData?.walking == true){
                        if (self.timer_flag == false) {
                            print("あるいている")
                            self.startBtnTap()
                        }
                        self.playLabel.text = "あるいている"
                        self.vibrateFlg = false
                    } else if (activityData?.running == true){

                        if (self.timer_flag == false) {
                            print("走ってる")
                            self.startBtnTap()
                        }

                        self.playLabel.text = "走ってる"
                        self.vibrateFlg = true
                    } else if (activityData?.automotive == true){
 
                        if (self.timer_flag == true) {
                            print("乗り物")
                            self.stopBtnTap()
                        }

                        self.playLabel.text = "乗り物"
                        self.vibrateFlg = false
                    }
                })
            })
        }
    }

    // TimerのtimeIntervalで指定された秒数毎に呼び出されるメソッド
    @objc func onUpdate(timer : Timer){

print("weightweightweightweightweight")
print(weight)


        if (day == 0) {
            // カウントの値1増加
            count += 1

            var weight_param = Double(ApiConfig.WEIGHT_LIST[self.weight ?? 0])

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

    func getStepDate() {
        //歩数が取得できるかどうかチェックしてます
        if(!CMPedometer.isStepCountingAvailable()) {
            print("cannot get stepcount")
        }
        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let selectDate =  dateFormatter.string(from: from)
        self.schedule.text = "\(selectDate)"

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
        //現在を取得してます。
        let to = Date()

        pedometer.queryPedometerData(from: start as Date, to: end as Date) { (data, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                var step = data.numberOfSteps
                var distance = data.distance
                var distance_data = (Double(distance!) / 1000)
                var distance_para = round(distance_data*10)/10

                self.stepCountLabel.text = "\(data.numberOfSteps)"
                self.distance.text = "\(distance_para)km"
                self.progressViewBar.value = (CGFloat(Double(step) / 10000)*100)

                print("歩数は\(data.numberOfSteps)")
                print("距離は\(data.distance))") // 距離
                print("登った回数\((data.floorsAscended))") // 上った回数
                print("降った回数\(data.floorsDescended))")
                
                print(step)
                self.count = Double(step) / 1.7
                self.formatter.unitsStyle = .positional
                self.formatter.allowedUnits = [.hour, .minute, .second]
                let str = self.formatter.string(from: self.count)
                // ラベルに表示
                self.timeLabel.text = str

                //self.progressViewBar2.value = (CGFloat(Double(step) / 10000)*100)
            }
        }

        
        
        let from1 = Date(timeInterval: TimeInterval(-60*60*24*0), since: now)
        var component1 = NSCalendar.current.dateComponents([.year, .month, .day], from: from1)
        component1.hour = 0
        component1.minute = 0
        component1.second = 0
        let start1:NSDate = NSCalendar.current.date(from:component)! as NSDate

        if (start == start1) {
            pedometer.startUpdates(from: start as Date) { data, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.stepCountLabel.text = "\(data.numberOfSteps)"
                }
            }
        }

        var dataEntries: [BarChartDataEntry] = []
        counter = 0.0
        //XX月XX日23時59分59秒に設定したものをendにいれる
        for i in 0..<24 {
            component.hour = i
            component.minute = 0
            component.second = 0
            let start1:NSDate = NSCalendar.current.date(from:component)! as NSDate
            
            component.hour = i
            component.minute = 59
            component.second = 59
            let end2:NSDate = NSCalendar.current.date(from:component)! as NSDate
            
            pedometer.queryPedometerData(from: start1 as Date, to: end2 as Date) { (data, error) in
                guard let data1 = data else { return }
                DispatchQueue.main.async {
                    self.step_1.append(Double(data1.numberOfSteps))
                }
            
                // 取得したデータを（１）のデータ配列に設定
                self.counter += 1
                let dataEntry = BarChartDataEntry(x: self.counter, y: Double(data1.numberOfSteps))
//            var number = Int.random(in: 1 ... 18)
//            let dataEntry = BarChartDataEntry(x: self.counter, y: Double(number))
                dataEntries.append(dataEntry)
                
                if (self.counter == 23) {
                    self.barChartView.animate(yAxisDuration: 1)

                    self.barChartView.rightAxis.axisMinimum = 0
                    self.barChartView.leftAxis.axisMinimum = 0

                    //右軸（値）の非表示
                    self.barChartView.rightAxis.drawLabelsEnabled = false
                    // y軸のグリッド表示（今回は非表示する
                    self.barChartView.xAxis.drawGridLinesEnabled = false
                    //self.barChartView.leftAxis.enabled  = true  //左軸（値）の表示
                    self.barChartView.xAxis.labelPosition = .bottom
                    self.barChartView.xAxis.labelCount = 12

                    self.barChartView.chartDescription?.enabled = false
                    self.barChartView.legend.enabled = false
                    self.barChartView.doubleTapToZoomEnabled = false
                    
                    self.barChartView.pinchZoomEnabled = false
                    self.barChartView.doubleTapToZoomEnabled = false
                    
                    self.barChartView.scaleXEnabled = false
                    self.barChartView.scaleYEnabled = false
                    self.barChartView.dragEnabled = false
                    self.barChartView.notifyDataSetChanged()
                    self.barChartView.highlightPerTapEnabled = true
                    
                    let chartDataSet = BarChartDataSet(entries: dataEntries, label: "aaaaa")
                    chartDataSet.drawValuesEnabled = false
                    let chartData = BarChartData(dataSet: chartDataSet)
                    self.barChartView.data = chartData
                }
            }
        }
    }


    
//    public class BarChartValueFormatter: NSObject, IValueFormatter{
//        public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String{
//            return String(Int(entry.y))
//        }
//    }
    
    @IBAction func leftSlide(_ sender: Any) {
        if (day > 0) {
            day = day - 1
            self.step_1 = []
            getStepDate()
        }
    }
    @IBAction func rightSlide(_ sender: Any) {
        day = day + 1
        self.step_1 = []
        getStepDate()
    }

    @IBAction func leftButton(_ sender: Any) {
        if (day > 0) {
            day = day - 1
            self.step_1 = []
            getStepDate()
        }
    }
    
    @IBAction func rightButton(_ sender: Any) {
        day = day + 1
        self.step_1 = []
        getStepDate()
    }
    

}
