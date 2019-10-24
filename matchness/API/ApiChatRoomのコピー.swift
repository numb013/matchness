//
//  ApiChatRoomData.swift
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
public struct ApiChatRoom: CustomDebugStringConvertible {
    public var room_code: String? = nil;
    public var user_hash_id: String? = nil;
    public var target_hash_id: String? = nil;
    public var last_message: String? = nil;
    
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
        if let user_hash_id = item["user_hash_id"].string {
            self.user_hash_id = user_hash_id;
        }
        //String => String
        if let target_hash_id = item["target_hash_id"].string {
            self.target_hash_id = target_hash_id;
        }
        //String => String
        if let last_message = item["last_message"].string {
            self.last_message = last_message;
        }
        return true;
    }
    
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiMultipleUser::\(#function)\n";
            string += "room_code => \(String(describing: self.room_code))\n";
            string += "user_hash_id => \(String(describing: self.user_hash_id))\n";
            string += "target_hash_id => \(String(describing: self.target_hash_id))\n";
            string += "last_message => \(String(describing: self.last_message))\n";
            return string;
        }
    }
    
}
