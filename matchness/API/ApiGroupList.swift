//
//  ApiUserSearchData.swift
//  matchness
//
//  Created by RW on 2019/07/10.
//  Copyright © 2019 a2c. All rights reserved.
//

import Foundation;
import SwiftyJSON;

/*
 レスポンスとデータを取り込む構造体
 構造体は利用時にプロパティ全てを初期化する必要がある。
 */
public struct ApiGroupList: CustomDebugStringConvertible {
    public var id: Int? = nil;
    public var title: String? = nil;
    public var event_period: Int? = 0;
    public var event_peple: Int? = 0;
    public var master_id: Int? = nil;
    public var start_type: Int? = 0;
    public var present_point: Int? = 0;
    public var status: Int? = 0;
    public var event_type: Int? = 0;
    public var event_start: String? = nil;
    public var event_end: String? = nil;
    public var last_login: String? = nil;
    public var progress_day: Int? = 0;
    public var request_status: Int? = 0;
    public var master_group: Int? = 0;
    public var profile_image: String? = nil;

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
        if let id = item["id"].int {
            self.id = id;
        }
        //String => String
        if let title = item["title"].string {
            self.title = title;
        }
        //String => String
        if let event_peple = item["event_peple"].int {
            self.event_peple = event_peple;
        }
        //String => String
        if let event_period = item["event_period"].int {
            self.event_period = event_period;
        }
        //String => String
        if let master_id = item["master_id"].int {
            self.master_id = master_id;
        }
        //String => String
        if let start_type = item["start_type"].int {
            self.start_type = start_type;
        }
        //String => String
        if let present_point = item["present_point"].int {
            self.present_point = present_point;
        }
        //String => String
        if let status = item["status"].int {
            self.status = status;
        }
        //String => String
        if let event_type = item["event_type"].int {
            self.event_type = event_type;
        }
        //String => String
        if let event_start = item["event_start"].string {
            self.event_start = event_start;
        }

        //String => String
        if let event_end = item["event_end"].string {
            self.event_end = event_end;
        }
        //String => String
        if let last_login = item["last_login"].string {
            self.last_login = last_login;
        }

        //String => String
        if let progress_day = item["progress_day"].int {
            self.progress_day = progress_day;
        }
        //String => String
        if let request_status = item["request_status"].int {
            self.request_status = request_status;
        }
        //String => String
        if let master_group = item["master_group"].int {
            self.master_group = master_group;
        }
        //String => String
        if let profile_image = item["profile_image"].string {
            self.profile_image = profile_image;
        }

        return true;
        
    }

    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiGroupList::\(#function)\n";
            string += "id => \(String(describing: self.id))\n";
            string += "title => \(String(describing: self.title))\n";
            string += "event_peple => \(String(describing: self.event_peple))\n";
            string += "event_period => \(String(describing: self.event_period))\n";
            string += "master_id => \(String(describing: self.master_id))\n";
            string += "start_type => \(String(describing: self.start_type))\n";
            string += "present_point => \(String(describing: self.present_point))\n";
            string += "status => \(String(describing: self.status))\n";
            string += "event_type => \(String(describing: self.event_type))\n";
            string += "event_start => \(String(describing: self.event_start))\n";
            string += "event_end => \(String(describing: self.event_end))\n";
            string += "last_login => \(String(describing: self.last_login))\n";
            string += "progress_day => \(String(describing: self.progress_day))\n";
            string += "request_status => \(String(describing: self.request_status))\n";
            string += "master_group => \(String(describing: self.master_group))\n";
            string += "profile_image => \(String(describing: self.profile_image))\n";
            return string;
        }
    }
    
}
