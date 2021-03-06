
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
public struct ApiPaymentPointList: CustomDebugStringConvertible {
    
    public var id: String? = nil;
    public var name: String? = nil;
    public var point: String? = nil;
    public var amount: String? = nil;
    
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
        //String => String
        if let point = item["point"].int {
            self.point = String(point);
        }
        //String => String
        if let amount = item["amount"].int {
            self.amount = String(amount);
        }

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
            string += "amount => \(String(describing: self.amount))\n";
            return string;
        }
    }
    
}
