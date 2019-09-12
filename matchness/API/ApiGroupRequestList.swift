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
public struct ApiGroupRequestList: CustomDebugStringConvertible {
    public var user_id: Int? = nil;
    public var name: String? = nil;
    public var age: String? = nil;
    public var status: Int? = nil;
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
            self.user_id = user_id;
        }
        //String => String
        if let name = item["name"].string {
            self.name = name;
        }
        //String => String
        if let age = item["age"].int {
            self.age = String(age);
        }
        //String => String
        if let status = item["status"].int {
            self.status = status;
        }
        return true;
    }

    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiGroupList::\(#function)\n";
            string += "user_id => \(String(describing: self.user_id))\n";
            string += "name => \(String(describing: self.name))\n";
            string += "age => \(String(describing: self.age))\n";
            string += "status => \(String(describing: self.status))\n";
            return string;
        }
    }
    
}
