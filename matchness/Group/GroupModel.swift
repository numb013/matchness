//
//  MultipleModel.swift
//  matchness
//
//  Created by RW on 2019/07/10.
//  Copyright © 2019 a2c. All rights reserved.
//

import Foundation
import Alamofire;
import SwiftyJSON;

/*
 プロトコル
 */
protocol GroupModelDelegate {
    func onStart(model: GroupModel);
    func onComplete(model: GroupModel, count: Int);
    func onFailed(model: GroupModel);
    func onFinally(model: GroupModel);
    func onError(model: GroupModel);
}

/*
 プロトコル判定用
 */
enum GroupModelDelegateError : Error {
    case start;
    case complete;
    case failed;
}

class GroupModel: NSObject {
    //プロトコル
    var delegate: GroupModelDelegate?;
    var request: ApiRequest!;
    //初回リクエストか
    var isRequestFirst: Bool = false;
    //店舗情報取得用にリクエストを投げているか
    var isRequest: Bool = false;
    //ページ番号
    public var page: Int = 1;
    //初回リクエスト時の取得件数
    let REQUEST_ITEM_COUNT_DEFAULT: String = "30";
    //２回目以降のリクエスト時の取得件数
    let REQUEST_ITEM_COUNT_ADD: String = "50";
    //
    public var requestApiCount: Int = 0;
    //Dictionaryは要素の順番が決められていないため、順番を保持する配列s
    public var responseDataOrder: Array<String> = Array<String>();
        //IDをキーにしてデータを保持
    public var errorData: Dictionary<String, ApiErrorAlert> = [String: ApiErrorAlert]();
    public var responseData: Dictionary<String, ApiGroupList> = [String: ApiGroupList]();
    
    var array1: [String] = []
    var array2: Dictionary<String, ApiGroupList> = [:]

    var request_mode: String!;

    
    func requestApi(url: String, addQuery query: Dictionary<String,String>! = nil) -> Bool {
        if( isRequest ){
            if( self.request != nil ){
                self.request.cancel();
            }
        }
        //
        self.delegate?.onStart(model: self);
        //リクエスト中に変更
        isRequest = true;
        /*
         リクエストパラメーターの生成
         */
        var condition: ApiRequestCondition = ApiRequestCondition(){
            //conditionの値が変更された場合に呼び出される。（最初の初期化時には呼び出されない。）
            //didSetは値が設定された後に呼び出される。
            didSet {
                condition.keyword = "";
            }
        }
        
        //
        var params:[String: String] = condition.queryParams;
        //ページ番号
//        params["page"] = String(self.page);
        //
//        params["action"] = String("search");
        //件数
//        params["limit"] = isRequestFirst ? REQUEST_ITEM_COUNT_DEFAULT : REQUEST_ITEM_COUNT_ADD;
        
        //追加パラメーターが設定されていたら
        if( query != nil ){
            for (key, value) in query {
                print("\(key), value is \(value)");
                //追加パラメーターで上書き
                params.updateValue(value, forKey: key);
            }
        }

        print("paramsparamsparamsparamsparamsparamsparamsparamsparams")
        print(params)
        self.page = Int(params["page"]!)!

        
        if let request: ApiRequest = ApiRequest(delegate: self) {
            self.request = request;
            request.request(url: url, params: params, method: .post);
        }
        return true;
    }

    /*
     リクエストのキャンセル
     */
    func cancel(){
        if( self.request != nil ){
            self.request.cancel();
        }
    }

    func getDataCount() -> Int {
        return responseDataOrder.count;
    }

    /*
     */
    func getData(row: Int) -> ApiGroupList? {
        let count: Int = row + 1;
        if( count > responseDataOrder.count || responseDataOrder.isEmpty ){
            return nil;
        }
        let key: String = responseDataOrder[row];
        if let info: ApiGroupList = responseData[key] {
            return info;
        }
        return nil;
    }
}

extension GroupModel : ApiRequestDelegate {
    //レスポンスデータを解析
    public func onParse(_ json: JSON){
        
        var key1 = 0;
        print("ページページページページページページページ")
        print(page)
//        print(responseDataOrder)
        responseDataOrder = array1
        responseData = array2
        
        json.forEach { (key, json) in
            //データを変換
            let data: ApiGroupList? = ApiGroupList(json: json);
            if (page != 1) {
                key1 = Int(key)! + Int(page) * Int(8) - Int(8)

                print("key2key2key2key1key2")
                print(key1)

            } else {
                key1 = Int(key)!
            }
print("オーどあーオーどあーオーどあーオーどあー")
print(responseDataOrder)
            //並び順を保持
            responseDataOrder.append(String(key1));
            print(responseDataOrder)


            responseData[String(key1)] = data;
        }
        page += 1;
        print("pagepagepage")
        print(page)
    }
    
    public func onComplete(){
        self.delegate?.onComplete(model: self, count: responseData.count);
        onFinally();
    }

    public func onFailed(_ error: ApiRequestDelegateError){
        self.delegate?.onFailed(model: self);
        onFinally();
    }

    public func onFinally(){
        //ページを進める
//        self.page += 1;
        //リクエスト回数を増やす
        self.requestApiCount += 1;
        //リクエスト完了
        self.isRequest = false;
        self.delegate?.onFinally(model: self);
    }
    
    func onError(_ error: JSON) {
        for (key, item):(String, JSON) in error {
            //データを変換
            let data: ApiErrorAlert? = ApiErrorAlert(json: item);
            //サブカテゴリーIDをキーにして保存
            errorData[key] = data;
        }
        self.delegate?.onError(model: self);
    }

}
