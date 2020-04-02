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
public struct ApiMyData: CustomDebugStringConvertible {
    public var id: Int? = nil;
    public var name: String? = nil;
    public var fitness_parts_id: Int? = nil;
    public var weight: Int? = nil;
    public var point: String? = nil;
    public var rank: Int? = nil;
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
            self.id = id;
        }
        //String => String
        if let name = item["name"].string {
            self.name = name;
        }
        //String => String
        if let fitness_parts_id = item["fitness_parts_id"].int {
            self.fitness_parts_id = fitness_parts_id;
        }
        //String => String
        if let weight = item["weight"].int {
            self.weight = weight;
        }
        //String => String
        if let rank = item["rank"].int {
            self.rank = rank;
        }
        if let point = item["point"].int {
            //print( "name => \(name)" );
            self.point = String(point);
        }
        if let profile_image = item["profile_image"].string {
            //print( "name => \(name)" );
            self.profile_image = profile_image;
        }

        return true;
        
    }
    /*
     デバッグ出力用
     */
    public var debugDescription: String {
        get{
            var string:String = "ApiMyDataDate::\(#function)\n";
            string += "id => \(String(describing: self.id))\n";
            string += "name => \(String(describing: self.name))\n";
            string += "fitness_parts_id => \(String(describing: self.fitness_parts_id))\n";
            string += "weight => \(String(describing: self.weight))\n";
            string += "rank => \(String(describing: self.rank))\n";
            string += "point => \(String(describing: self.point))\n";
            string += "profile_image => \(String(describing: self.profile_image))\n";
            return string;
        }
    }
    
}
