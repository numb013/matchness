//
//  ApiDataShop.swift
//  Alamofire01
//
//  Created by k1e091 on 2017/08/16.
//  Copyright © 2017年 k-1.ne.jp. All rights reserved.
//

import Foundation;
import SwiftyJSON;

/*
 レスポンスとデータを取り込む構造体
 構造体は利用時にプロパティ全てを初期化する必要がある。
 */
public struct ApiUserDateParam: CustomDebugStringConvertible {

    public var id: String? = nil;
    public var name: String? = nil;
    public var size: String? = nil;
    //1:normal 2:large
    public var isLargeSize: Bool = false;
    public var height: CGFloat = 0;
    public var heightIcon: CGFloat = 0;
    public var list: Array<ApiUserDate> = Array<ApiUserDate>();
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
            //print( "code => \(code)" );
            self.id = String(id);
        }
        //String => String
        if let name = item["name"].string {
            //print( "name => \(name)" );
            self.name = name;
        }
        //String => String
        if let size = item["size"].string {
            //print( "size => \(size)" );
            self.size = size;
            if( size == "2" ){
                self.isLargeSize = true;
            }else{
                self.isLargeSize = false;
            }
            
        }
        
        //
        if let list: Array = item["list"].array {
            //
            for info: JSON in list {
                //データを変換
                guard let group: ApiUserDate = ApiUserDate(json: info) else {
                    continue;
                }
                //
                self.list.append(group);
            }
        }
        
        return true;
        
    }
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "YLLDataTagGroupJenre::\(#function)\n";
            string += "id => \(String(describing: self.id))\n";
            string += "name => \(String(describing: self.name))\n";
            string += "size => \(String(describing: self.size))\n";
            string += "list => \(String(describing: self.list))\n";
            return string;
        }
    }
}
