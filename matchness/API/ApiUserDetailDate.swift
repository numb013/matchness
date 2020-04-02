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
public struct ApiUserDetailDate: CustomDebugStringConvertible {

    public var id: Int? = nil;
    public var hash_id: String? = nil;
    public var name: String? = nil;
    public var work: Int? = nil;
    public var profile_text: String? = nil;
    public var age: String? = nil;
    public var sex: Int? = nil;
    public var birthday: String? = nil;
    public var fitness_parts_id: Int? = nil;
    public var blood_type: Int? = nil;
    public var point: String? = nil;
    public var weight: Int? = nil;
    public var prefecture_id: Int? = nil;
    public var is_like: Int? = nil;
    public var is_matche: Int? = nil;
    public var profile_image: Array<ApiProfileImage> = Array<ApiProfileImage>();
    public var room_code: String? = nil;
    public var my_id: Int? = nil;
    public var my_name: String? = nil;
    public var my_point: Int? = nil;
    public var my_profile_image: String? = nil;
    public var target_imag: String? = nil;
    public var favorite_block_status: Int? = nil;

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
        if let hash_id = item["hash_id"].string {
            self.hash_id = hash_id;
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
            self.age = String(age);
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
        if let weight = item["weight"].int {
            self.weight = weight;
        }
        if let prefecture_id = item["prefecture_id"].int {
            self.prefecture_id = prefecture_id;
        }
        if let is_like = item["is_like"].int {
            self.is_like = is_like;
        }
        if let is_matche = item["is_matche"].int {
            self.is_matche = is_matche;
        }
        //String => String
        if let room_code = item["room_code"].string {
            self.room_code = room_code;
        }
        //Int => Int
        if let my_id = item["my_id"].int {
            self.my_id = my_id;
        }
        //String => String
        if let my_name = item["my_name"].string {
            self.my_name = my_name;
        }
        //String => String
        if let my_point = item["my_point"].int {
            self.my_point = my_point;
        }
        //String => String
        if let my_profile_image = item["my_profile_image"].string {
            self.my_profile_image = my_profile_image;
        }
        //String => String
        if let target_imag = item["target_imag"].string {
            self.target_imag = target_imag;
        }
        if let favorite_block_status = item["favorite_block_status"].int {
            self.favorite_block_status = favorite_block_status;
        }


        if let profile_image: Array = item["profile_image"].array {
            //
            for info: JSON in profile_image {
                //データを変換
                guard let image: ApiProfileImage = ApiProfileImage(json: info) else {
                    continue;
                }
                //
                self.profile_image.append(image);
            }
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
            var string:String = "ApiUserDate::\(#function)\n";
            string += "id => \(String(describing: self.id))\n";
            string += "hash_id => \(String(describing: self.hash_id))\n";
            string += "name => \(String(describing: self.name))\n";
            string += "work => \(String(describing: self.work))\n";
            string += "profile_text => \(String(describing: self.profile_text))\n";
            string += "age => \(String(describing: self.age))\n";
            string += "sex => \(String(describing: self.sex))\n";
            string += "birthday => \(String(describing: self.birthday))\n";
            string += "fitness_parts_id => \(String(describing: self.fitness_parts_id))\n";
            string += "blood_type => \(String(describing: self.blood_type))\n";
            string += "point => \(String(describing: self.point))\n";
            string += "weight => \(String(describing: self.point))\n";
            string += "prefecture_id => \(String(describing: self.prefecture_id))\n";
            string += "is_like => \(String(describing: self.is_like))\n";
            string += "is_matche => \(String(describing: self.is_matche))\n";
            string += "profile_image => \(String(describing: self.profile_image))\n";
            string += "room_code => \(String(describing: self.room_code))\n";
            string += "my_id => \(String(describing: self.my_id))\n";
            string += "my_name => \(String(describing: self.my_name))\n";
            string += "my_point => \(String(describing: self.my_point))\n";
            string += "my_profile_image => \(String(describing: self.my_profile_image))\n";
            string += "target_imag => \(String(describing: self.target_imag))\n";
            string += "favorite_block_status => \(String(describing: self.favorite_block_status))\n";
            return string;
        }
    }
    
}

