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
public struct ApiNoticeList: CustomDebugStringConvertible {
    public var notice_id: Int? = nil;
    public var title: String? = nil;
    public var body_text: String? = nil;
    public var confirmed: String? = nil;
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
        if let notice_id = item["notice_id"].int {
            self.notice_id = notice_id;
        }
        //String => String
        if let title = item["title"].string {
            self.title = title;
        }
        //String => String
        if let body_text = item["body_text"].string {
            self.body_text = body_text;
        }
        //String => String
        if let confirmed = item["confirmed"].string {
            self.confirmed = confirmed;
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
            var string:String = "ApiGroupList::\(#function)\n";
            string += "notice_id => \(String(describing: self.notice_id))\n";
            string += "title => \(String(describing: self.title))\n";
            string += "body_text => \(String(describing: self.body_text))\n";
            string += "confirmed => \(String(describing: self.confirmed))\n";
            string += "created_at => \(String(describing: self.created_at))\n";
            return string;
        }
    }
    
}
