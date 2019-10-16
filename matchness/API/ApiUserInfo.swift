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
public struct ApiUserInfo: CustomDebugStringConvertible {
    public var id: String? = nil;
    public var name: String? = nil;

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
        if let id = item["id"].int {
            self.id = String(id);
        }
        //String => String
        if let name = item["name"].string {
            self.name = name;
        }

        
        return true;
        
    }
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiUserDate::\(#function)\n";
            string += "id => \(String(describing: self.id))\n";
            string += "name => \(String(describing: self.name))\n";
            return string;
        }
    }
    
}
