import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class APICheck {
    var requestAlamofire: Alamofire.Request?
    var response_1:JSON = []


    class func point(url:String, params:[String: String]) {

print("APIAPIAPIAPIちぇっく")
        print(params)

        var api_key = userDefaults.object(forKey: "api_token") as? String
        var headers: [String : String] = [:]
        var requestAlamofire: Alamofire.Request?
        var url: String = ApiConfig.REQUEST_URL_API_POINT_CHECK
        var params:[String: String] = [:]
        params["point"] = "10000000"

        headers = [
            "Accept" : "application/json",
            "Authorization" : "Bearer " + api_key!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]

        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
        .responseJSON { response in
            print(response)
            return
        }
    }



}
