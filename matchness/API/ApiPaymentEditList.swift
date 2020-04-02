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
public struct ApiPaymentEditList: CustomDebugStringConvertible {
    public var id: String? = nil;
    public var card_no: String? = nil;
    public var card_company: String? = nil;
    public var expiration_date: String? = nil;
    public var profile_image: String? = nil;

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
            //print( "name => \(name)" );
            self.id = String(id);
        }
        //String => String
        if let card_no = item["card_no"].int {
            //print( "name => \(name)" );
            self.card_no = String(card_no);
        }
        //String => String
        if let card_company = item["card_company"].int {
        self.card_company = String(card_company);
        }
        //String => String
        if let expiration_date = item["expiration_date"].int {
        self.expiration_date = String(expiration_date);
        }
        //String => String
        if let profile_image = item["profile_image"].string {
        self.profile_image = String(profile_image);
        }

        return true;
    }
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiPaymentEditList::\(#function)\n";
            string += "id => \(String(describing: self.id))\n";
            string += "card_no => \(String(describing: self.card_no))\n";
            string += "card_company => \(String(describing: self.card_company))\n";
            string += "expiration_date => \(String(describing: self.expiration_date))\n";
            string += "profile_image => \(String(describing: self.profile_image))\n";
            return string;
        }
    }
    
}
