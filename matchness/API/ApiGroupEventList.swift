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
public struct ApiGroupEventList: CustomDebugStringConvertible {

    public var user_id: Int? = nil;
    public var step: String? = nil;
    public var action_datetime: String? = nil;
    public var name: String? = nil;
    public var age: String? = nil;
    public var prefecture_id: Int? = nil;

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
        if let step = item["step"].int {
            self.step = String(step);
        }
        if let action_datetime = item["action_datetime"].string {
            self.action_datetime = action_datetime;
        }
        if let name = item["name"].string {
            self.name = name;
        }
        if let age = item["age"].int {
            self.age = String(age)
        }
        if let prefecture_id = item["prefecture_id"].int {
            self.prefecture_id = prefecture_id;
        }
        return true;
    }

    public var debugDescription: String {
        get{
            var string:String = "ApiGroupEventList::\(#function)\n";
            string += "user_id => \(String(describing: self.user_id))\n";
            string += "step => \(String(describing: self.step))\n";
            string += "action_datetime => \(String(describing: self.action_datetime))\n";
            string += "name => \(String(describing: self.name))\n";
            string += "age => \(String(describing: self.age))\n";
            string += "prefecture_id => \(String(describing: self.prefecture_id))\n";
            return string;
        }
    }
    
}
