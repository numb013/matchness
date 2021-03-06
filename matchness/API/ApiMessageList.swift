
//  ApiMessageList.swift
//  map-menu02
//
//  Created by k1e091 on 2018/11/14.
//  Copyright © 2018 nakajima. All rights reserved.
//

import Foundation;
import SwiftyJSON;

/*
 レスポンスとデータを取り込む構造体
 構造体は利用時にプロパティ全てを初期化する必要がある。
 */
public struct ApiMessageList: CustomDebugStringConvertible {
    
    public var room_code: String? = nil;
    public var id: String? = nil;
    public var target_id: String? = nil;
    public var target_name: String? = nil;
    public var last_message: String? = nil;
    public var profile_image: String? = nil;
    public var created_at: String? = nil;

    
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
        if let room_code = item["room_code"].string {
            self.room_code = room_code;
        }

        //String => String
        if let target_name = item["target_name"].string {
            self.target_name = target_name;
        }
        
        //String => String
        if let target_id = item["target_id"].string {
            self.target_id = target_id;
        }
        
        //String => String
        if let last_message = item["last_message"].string {
            self.last_message = last_message;
        }

        if let profile_image = item["profile_image"].string {
            self.profile_image = profile_image;
        }

        //String => String
        if let created_at = item["created_at"].string {
            self.created_at = created_at;
        }

        return true;
        
    }
    
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiMessageList::\(#function)\n";
            string += "room_code => \(String(describing: self.room_code))\n";
            string += "target_name => \(String(describing: self.target_name))\n";
            string += "target_id => \(String(describing: self.target_id))\n";
            string += "last_message => \(String(describing: self.last_message))\n";
            string += "profile_image => \(String(describing: self.profile_image))\n";
            string += "created_at => \(String(describing: self.created_at))\n";
            return string;
        }
    }
    
}
