//
//  ApiUserSearchData.swift
//  matchness
//
//  Created by RW on 2019/07/10.
//  Copyright © 2019 a2c. All rights reserved.
//

import Foundation
import SwiftyJSON;

/*
 レスポンスとデータを取り込む構造体
 構造体は利用時にプロパティ全てを初期化する必要がある。
 */
public struct ApiUserSearchData: CustomDebugStringConvertible {

    public var page_no: Int? = nil;
    public var user_list: Array<ApiUserDate> = Array<ApiUserDate>();
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
        if let page_no = item["page_no"].int {
            self.page_no = page_no;
        }
        //String => String
        if let user_list = item["user_list"].array {
            //print(user_date);
            for(key, value) in user_date.enumerated() {
                print("\(key) : \(value)");
                if let info: ApiUserDate = ApiUserDate(json: value) {
                    self.user_list.append(info);
                }
            }
        }
        return true;
    }
    
    public var debugDescription: String {
        get{
            var string:String = "ApiUserSearchData::\(#function)\n";
            string += "page_no => \(String(describing: self.page_no))\n";
            string += "user_list => \(String(describing: self.user_list))\n";
            return string;
        }
    }
    
}
