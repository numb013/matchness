//
//  ApiDataShop.swift
//  Alamofire01
//
//  Created by k1e091 on 2017/08/16.
//  Copyright © 2017年 k-1.ne.jp. All rights reserved.
//

import Foundation;
import SwiftyJSON;

/*
 レスポンスとデータを取り込む構造体
 構造体は利用時にプロパティ全てを初期化する必要がある。
 */
public struct ApiChangePoint: CustomDebugStringConvertible {

    public var user_id: Int? = nil;
    public var point: String? = nil;
    public var todayPointChenge: String? = nil;
    public var yesterdayPointChenge: String? = nil;
    public var dayAfterTomorrowPointChenge: String? = nil;

    /*
     デフォルトイニシャライザ
     失敗可能イニシャライザ init?
     */
    public init?(){
        return nil;
    }
    /*
     デフォルトイニシャライザ
     */
    public init?(json: JSON){
        let result: Bool? = self.parse(item: json);
        //解析失敗時
        guard result! else {
            return nil;
        }
    }
    /*
     APIからのレスポンス結果を構造体に変換
     mutatingは自身のプロパティを変更できるようにするためのもの
     */
    private mutating func parse(item: JSON) -> Bool? {
        
        if( item == JSON.null ){
            return nil;
        }
        
        //String => String
        if let user_id = item["user_id"].int {
            //print( "code => \(code)" );
            self.user_id = user_id;
        }
        //String => String
        if let point = item["point"].int {
            //print( "name => \(name)" );
            self.point = String(point);
        }
        //String => String
        if let todayPointChenge = item["todayPointChenge"].int {
            self.todayPointChenge = String(todayPointChenge);
        }
        //String => String
        if let yesterdayPointChenge = item["yesterdayPointChenge"].int {
            self.yesterdayPointChenge = String(yesterdayPointChenge);
        }
        //String => String
        if let dayAfterTomorrowPointChenge = item["dayAfterTomorrowPointChenge"].int {
            self.dayAfterTomorrowPointChenge = String(dayAfterTomorrowPointChenge);
        }

        return true;
        
    }
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiChangePoint::\(#function)\n";
            string += "user_id => \(String(describing: self.user_id))\n";
            string += "point => \(String(describing: self.point))\n";
            string += "todayPointChenge => \(String(describing: self.todayPointChenge))\n";
            string += "yesterdayPointChenge => \(String(describing: self.yesterdayPointChenge))\n";
            string += "dayAfterTomorrowPointChenge => \(String(describing: self.dayAfterTomorrowPointChenge))\n";
            return string;
        }
    }
}
