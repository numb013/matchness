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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStepDate()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    let pedometer:CMPedometer = CMPedometer()//プロパティでCMPedometerをインスタンス化。
    //ここは、クラスのプロパティで宣言すること。getWalkのローカル変数で記述してしまって、コールバックが呼ばれるときにインスタンスが消えててエラーが発生してしばらく詰まりました。
    
    func getStepDate() {
        //歩数が取得できるかどうかチェックしてます
        if(!CMPedometer.isStepCountingAvailable()) {
            print("cannot get stepcount")
        }
print("歩数!!!!!!!")
        
        
        self.pedometer.startUpdates(from: NSDate() as Date) {
            (data: CMPedometerData?, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if(error == nil){
                    // 歩数 NSNumber?
                    let steps = data!.numberOfSteps

print("歩数")
print(steps)
                    var results:String = String(format:"steps: %d", steps.intValue)
                    results += "\n"
                    // 距離 NSNumber?
                    let distance = data!.distance!.doubleValue
                    results += String(format: "distance: %d", Int(distance))
                    results += "\n"
                    
                    // 期間
                    let period = data!.endDate.timeIntervalSince(data!.startDate)

                    print("期間")
                    print(period)
                    // スピード
                    let speed = distance / period
                    results += String(format: "speed: %f", speed)
                    results += "\n"
 
                    print("スピード")
                    print(speed)
                    
                    // 平均ペース NSNumber?
                    let averageActivePace = data!.averageActivePace
                    results += String(format: "averageActivePace: %f", averageActivePace!.doubleValue)
                    results += "\n"
                    
                    // ペース NSNumber?
                    let currentPace = data!.currentPace
                    results += String(format: "currentPace: %f", currentPace!.doubleValue)
                    results += "\n"
                    
                    // リズム steps/second NSNumber?
                    let currentCadence = data!.currentCadence
                    results += String(format: "currentCadence: %f", currentCadence!.doubleValue)
                    results += "\n"
                    
                    // 昇ったフロアの数 NSNumber?
                    let floorsAscended = data!.floorsAscended
                    results += String(format: "floorsAscended: %d", floorsAscended!.intValue)
                    results += "\n"
                    
                    // 降りたフロアの数 NSNumber?
                    let floorsDescended = data!.floorsDescended
                    results += String(format: "floorsDescended: %d", floorsDescended!.intValue)
                    results += "\n"
                    

                    
                }
                
            })
        }
        
        
        //
//        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)
//        dateFormatter.dateFormat = "yyyy年MM月dd日"
//        let selectDate =  dateFormatter.string(from: from)
//        self.schedule.text = "\(selectDate)"
//
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
//        //現在を取得してます。
//        let to = Date()
//
//        pedometer.queryPedometerData(from: start as Date, to: end as Date) { (data, error) in
//            guard let data = data else { return }
//            DispatchQueue.main.async {
//                var step = data.numberOfSteps
//                var distance = data.distance
//
//                var distance_data = (Double(distance!) / 1000)
//                var distance_para = round(distance_data*10)/10
//
//                self.stepCountLabel.text = "\(data.numberOfSteps)"
//                self.distance.text = "\(distance_para)Km"
//                self.progressViewBar.value = (CGFloat(Double(step) / 10000)*100)
//
//
//                let time = end.timeIntervalSince(start as Date)
//                let time_fun = time / 60
//                let time_jikan = time / 3600
//                print("タイム")
//                print(time_fun)
//                print(time_jikan)
//
//                var kal = 1.05 * 3 * distance_data * 52
//                print("カロリー\(kal)")
//                print("歩数は\(data.numberOfSteps)")
//                print("距離は\(data.distance))") // 距離
//                print("登った回数\((data.floorsAscended))") // 上った回数
//                print("降った回数\(data.floorsDescended))")
//
//                //self.progressViewBar2.value = (CGFloat(Double(step) / 10000)*100)
//
//            }
//        }
//
//        var dataEntries: [BarChartDataEntry] = []
//        counter = 0.0
//        //XX月XX日23時59分59秒に設定したものをendにいれる
//        for i in 0..<24 {
//            component.hour = i
//            component.minute = 0
//            component.second = 0
//            let start1:NSDate = NSCalendar.current.date(from:component)! as NSDate
//
//            component.hour = i
//            component.minute = 59
//            component.second = 59
//            let end2:NSDate = NSCalendar.current.date(from:component)! as NSDate
//
//            pedometer.queryPedometerData(from: start1 as Date, to: end2 as Date) { (data, error) in
//                guard let data1 = data else { return }
//                DispatchQueue.main.async {
//                    self.step_1.append(Double(data1.numberOfSteps))
//                }
//
//                // 取得したデータを（１）のデータ配列に設定
//                self.counter += 1.0
//                let dataEntry = BarChartDataEntry(x: self.counter, y: Double(data1.numberOfSteps))
//                dataEntries.append(dataEntry)
//
//                if (self.counter == 23.0) {
//                    self.barChartView.animate(yAxisDuration: 1.0)
//                    self.barChartView.rightAxis.drawLabelsEnabled = true
//                    self.barChartView.xAxis.labelPosition = .bottom
//                    self.barChartView.xAxis.labelCount = 12
//                    self.barChartView.xAxis.drawGridLinesEnabled = false
//                    self.barChartView.chartDescription?.enabled = false
//                    self.barChartView.legend.enabled = false
//
//                    let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
//                    let chartData = BarChartData(dataSet: chartDataSet)
//
//                    let data = LineChartData()
//
//                    let ds = LineChartDataSet(entries: dataEntries, label: "Months")
//                    ds.drawCirclesEnabled = false
//                    ds.drawValuesEnabled = false
//                    // viewにチャートデータを設定
//
//                    self.barChartView.data = chartData
//
//                }
//            }
//        }
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
