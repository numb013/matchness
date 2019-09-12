//
//  ProfileAddModel.swift
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
protocol ProfileAddModelDelegate {
    func onStart(model: ProfileAddModel);
    func onComplete(model: ProfileAddModel, count: Int);
    func onFailed(model: ProfileAddModel);
}
/*
 プロトコル判定用
 */
enum ProfileAddModelDelegateError : Error {
    case start;
    case complete;
    case failed;
}

class ProfileAddModel: NSObject {
    //プロトコル
    var delegate: ProfileAddModelDelegate?;
    var request: ApiRequest!;
    //店舗情報取得用にリクエストを投げているか
    var isRequest: Bool = false;

    //Dictionaryは要素の順番が決められていないため、順番を保持する配列s
    public var responseDataOrder: Array<String> = Array<String>();
    //IDをキーにしてデータを保持
    public var responseData: Dictionary<String, ApiUserDate> = [String: ApiUserDate]();
    var request_mode: String!;

    func requestApi(url: String, addQuery query: Dictionary<String,String>! = nil) -> Bool {
        if( isRequest ){
            if( self.request != nil ){
                self.request.cancel();
            }
        }
        self.delegate?.onStart(model: self);
        //リクエスト中に変更
        isRequest = true;

        if let request: ApiRequest = ApiRequest(delegate: self) {
            self.request = request;
            request.request(url: url, params: query, method: .post);
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
    func getData(row: Int) -> ApiUserDate? {
        let count: Int = row + 1;
        if( count > responseDataOrder.count || responseDataOrder.isEmpty ){
            return nil;
        }
        let key: String = responseDataOrder[row];
        if let info: ApiUserDate = responseData[key] {
            return info;
        }
        return nil;
    }
}

extension ProfileAddModel : ApiRequestDelegate {
    //レスポンスデータを解析
    public func onParse(_ json: JSON){
        let items: JSON = json["data"];
        let recommend: JSON = items["list"];
        for (key, item):(String, JSON) in json {
            //データを変換
            let data: ApiUserDate? = ApiUserDate(json: item);
            //Optionalチェック
            guard let info: ApiUserDate = data else {
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
        //リクエスト完了
        self.isRequest = false;
    }
}

