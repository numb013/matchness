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
public struct ApiUserPaymentInfo: CustomDebugStringConvertible {
    
    public var card_no: String? = nil;
    public var card_company: String? = nil;
    public var payment_point_list: Array<ApiPaymentPointList> = Array<ApiPaymentPointList>();

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
        if let card_no = item["card_no"].string {
            self.card_no = card_no;
        }
        
        //String => String
        if let card_company = item["card_company"].string {
            self.card_company = card_company;
        }
        if let payment_point_list = item["payment_point_list"].array {
            for info: JSON in payment_point_list {
                //データを変換
                guard let payment_point_list: ApiPaymentPointList = ApiPaymentPointList(json: info) else {
                    continue;
                }
                self.payment_point_list.append(payment_point_list);
            }
        }

        return true;
        
    }
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiUserPaymentInfo::\(#function)\n";
            string += "card_no => \(String(describing: self.card_no))\n";
            string += "card_company => \(String(describing: self.card_company))\n";
            string += "payment_point_list => \(String(describing: self.payment_point_list))\n";
            return string;
        }
    }
    
}
