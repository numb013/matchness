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
    public var work: Int? = nil;
    public var profile_text: String? = nil;
    public var age: Int? = nil;
    public var sex: Int? = nil;
    public var birthday: String? = nil;
    public var fitness_parts_id: Int? = nil;
    public var blood_type: Int? = nil;
    public var point: String? = nil;
    public var prefecture_id: Int? = nil;
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
            self.id = id;
        }
        //String => String
        if let name = item["name"].string {
            self.name = name;
        }
        //String => String
        if let work = item["work"].int {
            self.work = work;
        }
        //String => String
        if let profile_text = item["profile_text"].string {
            self.profile_text = profile_text;
        }
        //String => String
        if let age = item["age"].int {
            self.age = age;
        }
        //Int => Int
        if let sex = item["sex"].int {
            self.sex = sex;
        }
        //String => String
        if let birthday = item["birthday"].string {
            self.birthday = birthday;
        }
        //String => String
        if let fitness_parts_id = item["fitness_parts_id"].int {
            self.fitness_parts_id = fitness_parts_id;
        }
        if let blood_type = item["blood_type"].int {
            self.blood_type = blood_type;
        }
        if let point = item["point"].int {
            //print( "name => \(name)" );
            self.point = String(point);
        }
        if let prefecture_id = item["prefecture_id"].int {
            self.prefecture_id = prefecture_id;
        }
        
        
        //        if let prefecture_id = item["prefecture_id"].string {
        //            self.prefecture_id = prefecture_id;
        //        }
        
        //        //String => String
        //        if let map = item["map"].string {
        //            self.map = map;
        //        }
        //        //Array<String> => Array<String>
        //        if let tagId: Array = item["tag_id"].array {
        //            print(tagId);
        //            for(key, value) in tagId.enumerated() {
        //                print("\(key) : \(value)");
        //                self.tagId.append(value.string!);
        //            }
        //        }
        //Array<String> => Array<String>
        //        if let categorySubId: Array = item["category_sub_id"].array {
        //            print(categorySubId);
        //            for(key, value) in categorySubId.enumerated() {
        //                print("\(key) : \(value)");
        //                self.categorySubId.append(value.string!);
        //            }
        //        }
        
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
            string += "work => \(String(describing: self.work))\n";
            string += "profile_text => \(String(describing: self.profile_text))\n";
            string += "age => \(String(describing: self.age))\n";
            string += "sex => \(String(describing: self.sex))\n";
            string += "birthday => \(String(describing: self.birthday))\n";
            string += "fitness_parts_id => \(String(describing: self.fitness_parts_id))\n";
            string += "blood_type => \(String(describing: self.blood_type))\n";
            string += "point => \(String(describing: self.point))\n";
            string += "prefecture_id => \(String(describing: self.prefecture_id))\n";
            return string;
        }
    }
    
}
