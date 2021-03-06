//
//  ApiMatcheList.swift
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
public struct ApiPintHistoryList: CustomDebugStringConvertible {
    
    public var point: String? = nil;
    public var status: String? = nil;
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
        if let point = item["point"].int {
            //print( "name => \(name)" );
            self.point = String(point);
        }
        //String => String
        if let status = item["status"].int {
            //print( "name => \(name)" );
            self.status = String(status);
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
            var string:String = "ApiPintHistoryList::\(#function)\n";
            string += "point => \(String(describing: self.point))\n";
            string += "status => \(String(describing: self.status))\n";
            string += "created_at => \(String(describing: self.created_at))\n";
            return string;
        }
    }
    
}
