//
//  ApiRequestCondition.swift
//  matchness
//
//  Created by RW on 2019/07/10.
//  Copyright © 2019 a2c. All rights reserved.
//

import Foundation

public struct ApiRequestCondition {

    public var id:String? = nil;
    public var name:String? = nil;
    public var page:String? = nil;
    //検索キーワード
    public var keyword: String? = nil;

    //
    public enum Mode: String {
        case json = "json"
        case test = "test"
    }
    //デフォルトのモードを設定
    public var mode: Mode = .json;
    
    /*
     初期値のパラメーター
     出力した時に表示せる内容
     */
    public var queryParams: [String: String] {
        get {
            var params = [String: String]();
            if let unwrapped = id {
                params["id"] = unwrapped;
            }
            if let unwrapped = name {
                params["name"] = unwrapped;
            }
            if let unwrapped = keyword {
                params["keyword"] = unwrapped;
            }
            return params;
        }
    }
    
}
