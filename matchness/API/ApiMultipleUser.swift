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
public struct ApiMultipleUser: CustomDebugStringConvertible {
    public var id: Int? = nil;
    public var name: String? = nil;
    public var user_id: Int? = nil;
    public var target_id: Int? = nil;
    public var confirmed: Int? = nil;
    public var prefecture_id: Int? = nil;
    public var updated_at: String? = nil;
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
        if let name = item["name"].string {
            self.name = name;
        }
        //String => String
        if let prefecture_id = item["prefecture_id"].int {
            self.prefecture_id = prefecture_id;
        }
        //String => String
        if let user_id = item["user_id"].int {
            self.user_id = user_id;
        }
        //String => String
        if let target_id = item["target_id"].int {
            self.target_id = target_id;
        }
        //String => String
        if let confirmed = item["confirmed"].int {
            self.confirmed = confirmed;
        }
        //String => String
        if let updated_at = item["updated_at"].string {
            self.updated_at = updated_at;
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
            var string:String = "ApiMultipleUser::\(#function)\n";
            string += "id => \(String(describing: self.id))\n";
            string += "name => \(String(describing: self.name))\n";
            string += "prefecture_id => \(String(describing: self.prefecture_id))\n";
            string += "user_id => \(String(describing: self.user_id))\n";
            string += "target_id => \(String(describing: self.target_id))\n";
            string += "confirmed => \(String(describing: self.confirmed))\n";
            string += "updated_at => \(String(describing: self.updated_at))\n";
            string += "profile_image => \(String(describing: self.profile_image))\n";
            return string;
        }
    }
    
}
