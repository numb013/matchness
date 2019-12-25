
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
public struct ApiErrorAlert: CustomDebugStringConvertible {
    
    public var title: String? = nil;
    public var code: String? = nil;
    public var message: String? = nil;
    public var label: String? = nil;
    
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
        if let title = item["title"].string {
            self.title = title;
        }
        //String => String
        if let code = item["code"].string {
            self.code = code;
        }
        //String => String
        if let message = item["message"].string {
            self.message = message;
        }
        //String => String
        if let label = item["label"].string {
            self.label = label;
        }

        return true;
        
    }
    
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiErrorAlert::\(#function)\n";
            string += "title => \(String(describing: self.title))\n";
            string += "code => \(String(describing: self.code))\n";
            string += "message => \(String(describing: self.message))\n";
            string += "label => \(String(describing: self.label))\n";
            return string;
        }
    }
    
}
