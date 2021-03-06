
//
//  ApiGroupChat.swift
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
public struct ApiGroupChatList: CustomDebugStringConvertible {
    public var user_id: Int? = nil;
    public var name: String? = nil;
    public var comment: String? = nil;
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

        if let user_id = item["user_id"].int {
            self.user_id = user_id;
        }
        //String => String
        if let name = item["name"].string {
            self.name = name;
        }
        
        //String => String
        if let comment = item["comment"].string {
            self.comment = comment;
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
            var string:String = "ApiGroupChatList::\(#function)\n";
            string += "user_id => \(String(describing: self.user_id))\n";
            string += "name => \(String(describing: self.name))\n";
            string += "comment => \(String(describing: self.comment))\n";
            string += "created_at => \(String(describing: self.created_at))\n";
            return string;
        }
    }
    
}
