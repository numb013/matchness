//
//  EventKIt.swift
//  Calendar
//
//  Created by user on 2018/10/23.
//  Copyright © 2018年 user. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class TodayStep: NSObject{

    let dateFormatter = DateFormatter()
    let now = Date()
    var day = 0
    var today_step = 0
    var group_step = 0
    var counter = 0.0
    
    let pedometer:CMPedometer = CMPedometer()//プロパティでCMPedometerをインスタンス化。
    func getStepDate() -> Int {
                print("きて流きて流きて流きて流222")
        //歩数が取得できるかどうかチェックしてます
        if(!CMPedometer.isStepCountingAvailable()) {
            print("クラスcannot get stepcount")
        }
        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)
        
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        //let selectDate =  dateFormatter.string(from: from)
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

                self.today_step = Int(data.numberOfSteps)
                //self.progressViewBar2.value = (CGFloat(Double(step) / 10000)*100)
            }
        }
        return self.today_step
    }

    func getGroupStep(progress_day:Int) -> Int {
        print("きて流きて流きて流きて流")
        //歩数が取得できるかどうかチェックしてます
        if(!CMPedometer.isStepCountingAvailable()) {
            print("クラスクラスcannot get stepcount")
        }

        let calendar = Calendar(identifier: .gregorian)
        let from = Date(timeIntervalSinceNow:TimeInterval(-60*60*24*progress_day))
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

print(data.numberOfSteps)
print(data)

                self.group_step = Int(data.numberOfSteps)
            }
        }
        return self.group_step
    }

    
    
    
}
