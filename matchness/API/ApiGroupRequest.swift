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
public struct ApiGroupRequest: CustomDebugStringConvertible {

    
    public var group_id: Int? = nil;
    public var event_peple: String? = nil;
    public var event_title: String? = nil;
    public var decision_type: Int? = nil;
    public var request_list: Array<ApiGroupRequestList> = Array<ApiGroupRequestList>();

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
        if let group_id = item["group_id"].int {
            self.group_id = group_id;
        }
        if let event_peple = item["event_peple"].string {
            self.event_peple = event_peple;
        }
        if let event_title = item["event_title"].string {
            self.event_title = event_title;
        }
        if let decision_type = item["decision_type"].int {
            self.decision_type = decision_type;
        }
        if let request_list = item["request_list"].array {
            for info: JSON in request_list {
                //データを変換
                guard let request_list: ApiGroupRequestList = ApiGroupRequestList(json: info) else {
                    continue;
                }
                self.request_list.append(request_list);
            }
        }
        return true;
    }

    public var debugDescription: String {
        get{
            var string:String = "ApiGroupEvent::\(#function)\n";
            string += "group_id => \(String(describing: self.group_id))\n";
            string += "event_peple => \(String(describing: self.event_peple))\n";
            string += "event_title => \(String(describing: self.event_title))\n";
            string += "decision_type => \(String(describing: self.decision_type))\n";
            string += "request_list => \(String(describing: self.request_list))\n";
            return string;
        }
    }
    
}
