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
    
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var progressViewBar: MBCircularProgressBarView!
    @IBOutlet weak var barChartView: BarChartView!
    
    var times: [String]!
    
    let dateFormatter = DateFormatter()
    let now = Date()
    var day = 0
    var counter = 0.0
    var step_1: [Double] = []
    

    let pedometer:CMPedometer = CMPedometer()
    let activity = CMMotionActivityManager()

 var vibrateFlg:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStepDate()
        // Do any additional setup after loading the view, typically from a nib.


        //CMMotionActivityManagerの確認
        if CMMotionActivityManager.isActivityAvailable() {
            activity.startActivityUpdates(to: OperationQueue.current!,
              withHandler: {activityData in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(activityData?.stationary == true){
                        print("止まっている")
                        self.playLabel.text = "止まっている"
                        self.vibrateFlg = false
                    } else if (activityData?.walking == true){
                        print("あるいている")
                        self.playLabel.text = "あるいている"
                        self.vibrateFlg = false
                    } else if (activityData?.running == true){
                        print("走ってる")
                        self.playLabel.text = "走ってる"
                        self.vibrateFlg = true
                    } else if (activityData?.automotive == true){
                        print("乗り物")
                        self.playLabel.text = "乗り物"
                        self.vibrateFlg = false
                    }
                })
            })
        }



    }
    
    //ここは、クラスのプロパティで宣言すること。getWalkのローカル変数で記述してしまって、コールバックが呼ばれるときにインスタンスが消えててエラーが発生してしばらく詰まりました。

    
    
    
    
    
    
    func getStepDate() {
        //歩数が取得できるかどうかチェックしてます
        if(!CMPedometer.isStepCountingAvailable()) {
            print("cannot get stepcount")
        }
//        pedometer.accelerometerUpdateInterval = 0.2

        //        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)
        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)

        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let selectDate =  dateFormatter.string(from: from)
        self.schedule.text = "\(selectDate)"
        
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
                self.distance.text = "\(distance_para)Km"
                self.progressViewBar.value = (CGFloat(Double(step) / 10000)*100)

                print("歩数は\(data.numberOfSteps)")
                print("距離は\(data.distance))") // 距離
                print("登った回数\((data.floorsAscended))") // 上った回数
                print("降った回数\(data.floorsDescended))")
                
                //self.progressViewBar2.value = (CGFloat(Double(step) / 10000)*100)
                
            }
        }
        
        pedometer.startUpdates(from: start as Date) { data, error in
            guard let data = data else { return }
            DispatchQueue.main.async {

                print("歩数は\(data.numberOfSteps)")
                print("aaaaa")
                print(data)

                // 期間
                let period = data.endDate.timeIntervalSince(data.startDate)

                print("期間")
                print(period)
                let distance = data.distance!.doubleValue
                // スピード
                let speed = distance / period
                var speed1 = String(format: "speed: %f", speed)
                print("スピード")
                print(speed1)

                self.stepCountLabel.text = "\(data.numberOfSteps)"
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
                self.counter += 1.0
                let dataEntry = BarChartDataEntry(x: self.counter, y: Double(data1.numberOfSteps))
                dataEntries.append(dataEntry)
                
                if (self.counter == 23.0) {
                    self.barChartView.animate(yAxisDuration: 1.0)
                    self.barChartView.rightAxis.drawLabelsEnabled = true
                    self.barChartView.xAxis.labelPosition = .bottom
                    self.barChartView.xAxis.labelCount = 12
                    self.barChartView.xAxis.drawGridLinesEnabled = false
                    self.barChartView.chartDescription?.enabled = false
                    self.barChartView.legend.enabled = false
                    
                    let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
                    let chartData = BarChartData(dataSet: chartDataSet)
                    
                    let data = LineChartData()
                    
                    let ds = LineChartDataSet(entries: dataEntries, label: "Months")
                    ds.drawCirclesEnabled = false
                    ds.drawValuesEnabled = false
                    // viewにチャートデータを設定
                    
                    self.barChartView.data = chartData
                    
                }
            }
        }
    }
    
    public class BarChartValueFormatter: NSObject, IValueFormatter{
        public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String{
            return String(Int(entry.y))
        }
    }
    
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
    
    
    
    
    
    
    
    
    
    
    
}
