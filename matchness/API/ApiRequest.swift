//
//  ApiRequest.swift
//  matchness
//
//  Created by RW on 2019/07/10.
//  Copyright © 2019 a2c. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/*
 プロトコル
 */
protocol ApiRequestDelegate {
    func onParse(_ result: JSON);
    func onComplete();
    func onFailed(_ error: ApiRequestDelegateError);
}
/*
 プロトコル判定用
 */
enum ApiRequestDelegateError : Error {
    case complete;
    case failed;
}

class ApiRequest {
    static let KEY_ERROR_CODE = "errorCode";
    //プロトコル
    public var delegate: ApiRequestDelegate?;
    private var isRequest: Bool = false;
    //http://cocoadocs.org/docsets/Alamofire/4.0.1/Structs/DataResponse.html
    private var response: DataResponse<Any>?;
    let userDefaults = UserDefaults.standard
    private var requestAlamofire: Alamofire.Request?;

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
    public init?(delegate del:ApiRequestDelegate){
        self.delegate = del;
    }

    //
    public func getResponse() -> DataResponse<Any> {
        return response!;
    }

    public func request(url url: String, params params:[String: String], method method: HTTPMethod = .get){
        
        print("YLLRequest.request AAAAAA(APIリクエストの場所)AAAAAA");
        print("url : " + url);
        print(params);

        var api_key = userDefaults.object(forKey: "api_token") as? String
        /*
         リクエスト実行
         Alamofire.request(url, method: .get, parameters: params);
         */

        var headers: [String : String] = [:]
print("えーピアイトークンーピアイトークン")
print(api_key)
        if ((api_key) != nil) {
            headers = [
                "Accept" : "application/json",
                "Authorization" : "Bearer " + api_key!,
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }

        print("ヘッダーヘッダーヘッダーヘッダーヘッダー")
        print(headers)

        self.requestAlamofire = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in

            print("リクエストRRRRRRRRRRRRRRRRRR")
            print(url)
            print(method)
            print(params)
            print("リクエストBBBBBBBBBBBBBBBBBBBBB")

            switch response.result {
            case .success:
                var json:JSON;
                
                do{
                    //レスポンスデータを解析
                    json = try SwiftyJSON.JSON(data: response.data!);
                } catch {
                    // error
                    print("json error: \(error.localizedDescription)");
                     self.onFaild(response as AnyObject);
                    break;
                }

print("URLURLURLURLURLURL")
print(url)
                if (url == ApiConfig.REQUEST_URL_API_ADD_LIKE) {
                    break;
                }

                print("取得した値はここにきて")
                print(json)
                //
                  self.onParse(json);
                //
                  self.onComplete();
            case .failure:
                //  リクエスト失敗 or キャンセル時
                print("リクエスト失敗 or キャンセル時")
                print(response)
                  self.onFaild(response as AnyObject);
                return;
            }
        }
        print("ここのタイミングrequestAPI")
    }

    /*
     レスポンスデータの整形
     */
    //繋げているModelのonParseに値渡している
    public func onParse(_ result: JSON){
        print("レスポンスデータの整形レスポンスデータの整形レスポンスデータの整形")
        self.delegate?.onParse(result);
    }

    /*
     全てのリクエストキャンセル
     */
    public func cancel(){
        self.requestAlamofire?.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }

    /*
     リクエスト完了
     */
    public func onComplete(){
        print("リクエスト完了リクエスト完了リクエスト完了リクエスト完了")
        onFinally(ApiRequestDelegateError.complete);
    }

    /*
     リクエストエラー
     */
    public func onFaild(_ result: AnyObject){
        //コールバック実行
        onFinally(ApiRequestDelegateError.failed);
    }

    /*
     コールバック
     */
    public func onFinally(_ error: ApiRequestDelegateError) {
        print("コールバックコールバックコールバックコールバックコールバック")
        //リクエスト完了に変更
        isRequest = false;
        switch error {
        case .complete:
            //繋げているModelのonCompleteに値渡している
            self.delegate?.onComplete();
        case .failed:
            //繋げているModelのonFailedに値渡している
            self.delegate?.onFailed(error);
        }
    }

    public static func isError(_ json: JSON) -> Bool {
        if let errorCode: Int = json[self.KEY_ERROR_CODE].int {
            if( errorCode > 0 ){
                return true;
            }
        }
        return false;
    }
    
}
