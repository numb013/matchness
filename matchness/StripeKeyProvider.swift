import Foundation
import Stripe
import Alamofire

class StripeKeyProvider: NSObject, STPEphemeralKeyProvider{
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let userId = UserDefaults.standard.string(forKey: "userId")
        let params: [String: String] = ["api_version":apiVersion, "user_id": userId!]
        let url: String = ApiConfig.REQUEST_URL_API_CHARGE;
        Alamofire.request(url, method: .post, parameters: params)
        .validate(statusCode: 200..<300)
        .responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let json):
                completion(json as? [String: AnyObject], nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
