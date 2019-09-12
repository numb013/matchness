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
public struct ApiProfileData: CustomDebugStringConvertible {

    public var id: String? = nil;
    public var api_token: String? = nil;
    public var name: String? = nil;
    public var email: String? = nil;
    public var work: Int? = nil;
    public var profile_text: String? = nil;
    public var age: Int? = nil;
    public var sex: Int? = nil;
    public var birthday: String? = nil;
    public var fitness_parts_id: Int? = nil;
    public var blood_type: Int? = nil;
    public var point: Int? = nil;
    public var prefecture_id: Int? = nil;
    public var weight: Int? = nil;
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

        if let id = item["id"].int {
            self.id = String(id);
        }
        if let name = item["name"].string {
            //print( "subCategoryName => \(subCategoryName)" );
            self.name = name;
        }
        if let api_token = item["api_token"].string {
            //print( "subCategoryName => \(subCategoryName)" );
            self.api_token = api_token;
        }
        if let email = item["email"].string {
            //print( "subCategoryName => \(subCategoryName)" );
            self.email = email;
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
            self.point = point;
        }
        if let prefecture_id = item["prefecture_id"].int {
            self.prefecture_id = prefecture_id;
        }
        if let weight = item["weight"].int {
            self.weight = weight;
        }
        return true;
    }
    
    public var debugDescription: String {
        get{
            var string:String = "ApiProfileData::\(#function)\n";
            string += "id => \(String(describing: self.id))\n";
            string += "name => \(String(describing: self.name))\n";
            string += "api_token => \(String(describing: self.api_token))\n";
            string += "email => \(String(describing: self.email))\n";
            string += "work => \(String(describing: self.work))\n";
            string += "profile_text => \(String(describing: self.profile_text))\n";
            string += "age => \(String(describing: self.age))\n";
            string += "sex => \(String(describing: self.sex))\n";
            string += "birthday => \(String(describing: self.birthday))\n";
            string += "fitness_parts_id => \(String(describing: self.fitness_parts_id))\n";
            string += "blood_type => \(String(describing: self.blood_type))\n";
            string += "point => \(String(describing: self.point))\n";
            string += "prefecture_id => \(String(describing: self.prefecture_id))\n";
            string += "weight => \(String(describing: self.weight))\n";
            return string;
        }
    }
    
}
