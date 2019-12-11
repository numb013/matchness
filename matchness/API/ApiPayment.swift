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
public struct ApiPayment: CustomDebugStringConvertible {
    public var client_secret: String? = nil;
    public var publishableKey: String? = nil;

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
        if let client_secret = item["client_secret"].string {
            self.client_secret = client_secret;
        }
        //String => String
        if let publishableKey = item["publishableKey"].string {
            self.publishableKey = publishableKey;
        }

        return true;
    }
    
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiMultipleUser::\(#function)\n";
            string += "client_secret => \(String(describing: self.client_secret))\n";
            string += "publishableKey => \(String(describing: self.publishableKey))\n";
            return string;
        }
    }
    
}
