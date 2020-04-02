
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
public struct ApiMessage: CustomDebugStringConvertible {
    
    public var id: Int? = nil;
    public var name: String? = nil;
    public var point: String? = nil;
    public var profile_image: String? = nil;
    public var message: Array<ApiMessageList> = Array<ApiMessageList>();
    
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
        if let point = item["point"].int {
            self.point = String(point);
        }
        //String => String
        if let profile_image = item["profile_image"].string {
            self.profile_image = profile_image;
        }
        
        if let message = item["message"].array {
            for info: JSON in message {
                //データを変換
                guard let message: ApiMessageList = ApiMessageList(json: info) else {
                    continue;
                }
                self.message.append(message);
            }
        }

//
//        //String => String
//        if let room_code = item["room_code"].string {
//            self.room_code = room_code;
//        }
//
//        //String => String
//        if let target_name = item["target_name"].string {
//            self.target_name = target_name;
//        }
//
//        //String => String
//        if let target_id = item["target_id"].string {
//            self.target_id = target_id;
//        }
//
//        //String => String
//        if let last_message = item["last_message"].string {
//            self.last_message = last_message;
//        }
//
//        //String => String
//        if let created_at = item["created_at"].string {
//            self.created_at = created_at;
//        }

        return true;
        
    }
    
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiMessage::\(#function)\n";
            string += "id => \(String(describing: self.id))\n";
            string += "name => \(String(describing: self.name))\n";
            string += "point => \(String(describing: self.point))\n";
            string += "profile_image => \(String(describing: self.profile_image))\n";
            string += "message => \(String(describing: self.message))\n";
            return string;
        }
    }
    
}
