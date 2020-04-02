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
public struct ApiSetting: CustomDebugStringConvertible {
    public var message_notice: Int? = nil;
    public var group_notice: Int? = nil;
    public var foot_notice: Int? = nil;
    public var match_notice: Int? = nil;
    
//    public var images: Array<String> = Array<String>();
//    public var categorySubId: Array<String> = Array<String>();
//    public var tagId: Array<String> = Array<String>();
//    public var map: String? = nil;
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
        if let message_notice = item["message_notice"].int {
            self.message_notice = message_notice;
        }

        //String => String
        if let group_notice = item["group_notice"].int {
        self.group_notice = group_notice;
        }
        //String => String
        if let foot_notice = item["foot_notice"].int {
        self.foot_notice = foot_notice;
        }
        //String => String
        if let match_notice = item["match_notice"].int {
        self.match_notice = match_notice;
        }
        return true;
    }
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiUserDate::\(#function)\n";
            string += "message_notice => \(String(describing: self.message_notice))\n";
            string += "group_notice => \(String(describing: self.group_notice))\n";
            string += "foot_notice => \(String(describing: self.foot_notice))\n";
            string += "match_notice => \(String(describing: self.match_notice))\n";
            return string;
        }
    }
    
}
