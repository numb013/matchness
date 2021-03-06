//
//  ApiUserSearchData.swift
//  matchness
//
//  Created by RW on 2019/07/10.
//  Copyright © 2019 a2c. All rights reserved.
//

import Foundation
import SwiftyJSON;

/*
 レスポンスとデータを取り込む構造体
 構造体は利用時にプロパティ全てを初期化する必要がある。
 */
public struct ApiGroupEvent: CustomDebugStringConvertible {

    
    public var user_id: Int? = nil;
    public var hash_id: String? = nil;
    public var step: String? = nil;
    public var rank: String? = nil;
    public var event_time: String? = nil;
    public var status: Int? = nil;
    public var event_peple: String? = nil;
    public var event_title: String? = nil;
    public var profile_image: String? = nil;
    public var group_event: Array<ApiGroupEventList> = Array<ApiGroupEventList>();

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
        if let user_id = item["user_id"].int {
            self.user_id = user_id;
        }
        if let hash_id = item["hash_id"].string {
            self.hash_id = hash_id;
        }
        if let step = item["step"].string {
            self.step = step;
        }
        if let rank = item["rank"].int {
            self.rank = String(rank);
        }
        if let status = item["status"].int {
            self.status = status;
        }
        if let event_time = item["event_time"].string {
            self.event_time = event_time;
        }
        if let event_peple = item["event_peple"].string {
            self.event_peple = event_peple;
        }
        if let event_title = item["event_title"].string {
            self.event_title = event_title;
        }
        if let profile_image = item["profile_image"].string {
            self.profile_image = profile_image;
        }

        if let group_event = item["group_event"].array {
            for info: JSON in group_event {
                //データを変換
                guard let group_event: ApiGroupEventList = ApiGroupEventList(json: info) else {
                    continue;
                }
                self.group_event.append(group_event);
            }
        }
        return true;
    }

    public var debugDescription: String {
        get{
            var string:String = "ApiGroupEvent::\(#function)\n";
            string += "user_id => \(String(describing: self.user_id))\n";
            string += "hash_id => \(String(describing: self.hash_id))\n";
            string += "step => \(String(describing: self.step))\n";
            string += "rank => \(String(describing: self.rank))\n";
            string += "status => \(String(describing: self.status))\n";
            string += "event_time => \(String(describing: self.event_time))\n";
            string += "event_peple => \(String(describing: self.event_peple))\n";
            string += "event_title => \(String(describing: self.event_title))\n";
            string += "group_event => \(String(describing: self.group_event))\n";
            string += "profile_image => \(String(describing: self.profile_image))\n";
            return string;
        }
    }
    
}
