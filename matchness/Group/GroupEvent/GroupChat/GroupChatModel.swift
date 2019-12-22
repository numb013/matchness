//
//  UserSearchModel.swift
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
protocol GroupChatModelDelegate {
    func onStart(model: GroupChatModel);
    func onComplete(model: GroupChatModel, count: Int);
    func onFailed(model: GroupChatModel);
    func onFinally(model: GroupChatModel);
    func onError(model: GroupChatModel);
}

/*
 プロトコル判定用
 */
enum GroupChatModelDelegateError : Error {
    case start;
    case complete;
    case failed;
}

class GroupChatModel: NSObject {
    //プロトコル
    var delegate: GroupChatModelDelegate?;
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
    public var responseData: Dictionary<String, ApiGroupChatList> = [String: ApiGroupChatList]();
    
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
        params["page"] = String(self.page);
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
    func getData(row: Int) -> ApiGroupChatList? {
        let count: Int = row + 1;
        if( count > responseDataOrder.count || responseDataOrder.isEmpty ){
            return nil;
        }
        let key: String = responseDataOrder[row];
        if let info: ApiGroupChatList = responseData[key] {
            return info;
        }
        return nil;
    }
}

extension GroupChatModel : ApiRequestDelegate {
    //レスポンスデータを解析
    public func onParse(_ json: JSON){
        let items: JSON = json;
        let recommend: JSON = items["list"];
        for (key, item):(String, JSON) in json {
            //データを変換
            let data: ApiGroupChatList? = ApiGroupChatList(json: item);
            //Optionalチェック
            guard let info: ApiGroupChatList = data else {
                continue;
            }
            guard let name = info.name else {
                continue;
            }
            
            //並び順を保持
            responseDataOrder.append(key);
            //サブカテゴリーIDをキーにして保存
            responseData[key] = info;
        }
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
        self.page += 1;
        //リクエスト回数を増やす
        self.requestApiCount += 1;
        //リクエスト完了
        self.isRequest = false;
    }

   func onError(_ error: ApiRequestDelegateError) {
        self.delegate?.onError(model: self);
    }

}
