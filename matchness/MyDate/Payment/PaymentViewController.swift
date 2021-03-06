////
////  PaymentViewController.swift
////  matchness
////
////  Created by 中村篤史 on 2019/10/31.
////  Copyright © 2019 a2c. All rights reserved.
////
import UIKit
import Stripe
import Alamofire
import SwiftyJSON

class PaymentViewController: UIViewController {

    let userDefaults = UserDefaults.standard

    var paymentIntentClientSecret: String?
    private var requestAlamofire: Alamofire.Request?;
    var publishableKey = ""
//    var ActivityIndicator: UIActivityIndicatorView!
    var activityIndicatorView = UIActivityIndicatorView()

    var amount:String = String()
    var pay_point_id:String = String()
    var customer_status: String = String()
    var group_id: Int = Int()

    let label = UILabel()
    
    public var responseData: Dictionary<String, ApiPayment> = [String: ApiPayment]();
    
    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8470588235)
        button.setTitle("購入する", for: .normal)
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return button
    }()
//    lazy var payImage: UIImageView = {
//        let testImage = UIImageView(image: UIImage(named: "1"))
//        return testImage
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        
        let navBar = UINavigationBar()
        //xとyで位置を、widthとheightで幅と高さを指定する
        navBar.frame = CGRect(x: 0, y: 30, width: 420, height: 230)
        //ナビゲーションアイテムのタイトルを設定
        let navItem : UINavigationItem = UINavigationItem(title: "クレジット決済")
        //ナビゲーションバー右のボタンを設定
        navItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.myAction))
        //ナビゲーションバーにアイテムを追加
        navBar.pushItem(navItem, animated: true)
        //Viewにナビゲーションバーを追加
        self.view.addSubview(navBar)
        
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
            view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 15)
        ])

        
        let title = UILabel()
        title.text = "金運をアップさせる特におすすめの方角は 「西・北・東北」が良いとされています。\n\n西には金運を呼び寄せる方角になります。\n北には金運を育てる方角になります。\n東北には投資など財産を動かす方角になります。\n\nそれぞれの方角にラッキーカラーのアイテムを置くとより運気をアップ出来るでしょう。"

        title.frame = CGRect(x:(self.view.bounds.width-360)/2,y:75,width: 360,height:550)
        
        title.textAlignment = .left
        title.numberOfLines = 0
//        title.center = self.view.center
        title.lineBreakMode = .byWordWrapping
        title.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.view.addSubview(title)
        
        
        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        view.addSubview(activityIndicatorView)
        print("購入１")
        startCheckout()
    }

     @objc func myAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func displayAlert(title: String, message: String, restartDemo: Bool = false) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if restartDemo {
                alert.addAction(UIAlertAction(title: "Restart demo", style: .cancel) { _ in
                    self.cardTextField.clear()
                    print("購入２")
                    self.startCheckout()
                })
            }
            else {
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    public func onParse(_ json: JSON){
        let items: JSON = json["data"];
        let recommend: JSON = items["list"];
        for (key, item):(String, JSON) in json {
            //データを変換
            let data: ApiPayment? = ApiPayment(json: item);
            //Optionalチェック
            guard let info: ApiPayment = data else {
                continue;
            }
            responseData[key] = info;
        }
        self.paymentIntentClientSecret = responseData["0"]?.client_secret as! String
        // Configure the SDK with your Stripe publishable key so that it can make requests to the Stripe API
        // For added security, our sample app gets the publishable key from the server
        Stripe.setDefaultPublishableKey(responseData["0"]?.publishableKey as! String)
    }
    


    @objc
    func pay() {
        print("決済決済決済決済決済決済決済")
        activityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .default).async {
            // 非同期処理などを実行
            Thread.sleep(forTimeInterval: 5)
            // 非同期処理などが終了したらメインスレッドでアニメーション終了
            DispatchQueue.main.async {
                // アニメーション終了
                self.activityIndicatorView.stopAnimating()
            }
        }
        
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            print("11111")
//            ActivityIndicator.stopAnimating()
            self.activityIndicatorView.stopAnimating()
            return;
        }
        print("22222")
        // Collect card details
        let cardParams = cardTextField.cardParams
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        paymentIntentParams.setupFutureUsage = NSNumber(value: STPPaymentIntentSetupFutureUsage.offSession.rawValue)
        print("３２３２３２３２３２３２３２３２３２３２３２")
        print(paymentIntentParams.setupFutureUsage)
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status) {
            case .failed:
//                self.ActivityIndicator.stopAnimating()
                self.activityIndicatorView.stopAnimating()
                self.displayAlert(title: "購入に失敗しました", message: error?.localizedDescription ?? "")
                break
            case .canceled:
//                self.ActivityIndicator.stopAnimating()
                self.activityIndicatorView.stopAnimating()
                self.displayAlert(title: "購入がキャンセルされました", message: error?.localizedDescription ?? "")
                break
            case .succeeded:
//                self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
//                self.ActivityIndicator.stopAnimating()
                self.activityIndicatorView.stopAnimating()
                self.apiPointUpdate()
                
                let alertController:UIAlertController =
                    UIAlertController(title:"クレジットカードを登録しますか？",message: "次回から入力なしでポイントの購入ができます",preferredStyle: .alert)
                // Default のaction
                let defaultAction:UIAlertAction =
                    UIAlertAction(title: "登録する",style: .destructive,handler:{
                        (action:UIAlertAction!) -> Void in
                        // 処理
                        //  self.dismiss(animated: true, completion: nil)
                        print("っっっっっっっっっっっっd")
                        print(paymentIntent?.paymentMethodId)
                        var paymentMethodId = paymentIntent?.paymentMethodId
                        self.paymentAdd(paymentMethodId: paymentMethodId!)
                        self.userDefaults.set("1", forKey: "customer_status")
                        self.payalert()
                    })
                // Cancel のaction
                let cancelAction:UIAlertAction =
                    UIAlertAction(title: "登録しない",style: .cancel,handler:{
                        (action:UIAlertAction!) -> Void in
                        // 処理
                        print("キャンセル")
                        self.dismiss(animated: true, completion: nil)
//                        self.dismiss(animated: true, completion: nil)
//                        let storyboard: UIStoryboard = self.storyboard!
//                        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
//                        let multiple = storyboard.instantiateViewController(withIdentifier: "pointChange")
//                        multiple.modalPresentationStyle = .fullScreen
//                        //ここが実際に移動するコードとなります
//                        self.present(multiple, animated: false, completion: nil)
                    })
                
                alertController.addAction(defaultAction)
                alertController.addAction(cancelAction)
                // UIAlertControllerの起動
                self.present(alertController, animated: true, completion: nil)

                break
            @unknown default:
                fatalError()
                break
            }
        }
    }

    func payalert() {
        // アラート作成
        print("アラートアラートアラートアラートアラート")
        let alert = UIAlertController(title: "ポイント購入完了", message: "ありがとうございます", preferredStyle: .alert)
        // アラート表示
        self.present(alert, animated: true, completion: {
            // アラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                self.dismiss(animated: true, completion: nil)
                let storyboard: UIStoryboard = self.storyboard!
                //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                let multiple = storyboard.instantiateViewController(withIdentifier: "pointChange")
                multiple.modalPresentationStyle = .fullScreen
                //ここが実際に移動するコードとなります
                self.present(multiple, animated: false, completion: nil)
            })
        })
    }

    // 初回購入チェック
    func startCheckout() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_CHARGE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
//        query["stripeToken"] = String(token.tokenId)
        query["amount"] = amount
        query["pay_point_id"] = pay_point_id
        if (self.userDefaults.object(forKey: "customer_status") != nil) {
            customer_status = self.userDefaults.object(forKey: "customer_status") as! String
        }
        
        query["customer_status"] = ""
        var headers: [String : String] = [:]
        var api_key = userDefaults.object(forKey: "api_token") as? String
        print("apiエーピーあい")
        print(api_key)
        if ((api_key) != nil) {
            headers = [
                "Accept" : "application/json",
                "Authorization" : "Bearer " + api_key!,
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }
        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            print("リクエストBBBBBBBBBBB")
            print(requestUrl)
//            print(method)
            print(query)
            print("リクエストKKKKKKKKKKKK")
            switch response.result {
            case .success:
                var json:JSON;
                do{
                    //レスポンスデータを解析
                    json = try SwiftyJSON.JSON(data: response.data!);
                } catch {
                    // error
                    print("json error: \(error.localizedDescription)");
//                     self.onFaild(response as AnyObject);
                    break;
                }
                print("取得した値はここにきて11111")
                print(json)
                if (!(query["customer_status"] != "")) {
                    // var publishableKey = json["publishableKey"] as! String
                    self.onParse(json);
                }
            case .failure:
                //  リクエスト失敗 or キャンセル時
                print("リクエスト失敗 or キャンセル時")
                return;
            }
        }
    }

    // 初回ポイント更新
    func apiPointUpdate() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_POINT_UPDATE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["pay_point_id"] = pay_point_id
        var headers: [String : String] = [:]
        var api_key = userDefaults.object(forKey: "api_token") as? String
        if ((api_key) != nil) {
            headers = [
                "Accept" : "application/json",
                "Authorization" : "Bearer " + api_key!,
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }
        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                var json:JSON;
                do{
                    json = try SwiftyJSON.JSON(data: response.data!);
                } catch {
                    print("json error: \(error.localizedDescription)");
                    break;
                }
                print("取得した値はここにきて11111")
                print(json)
            case .failure:
                print("リクエスト失敗 or キャンセル時")
                return;
            }
        }
    }

    
    //クレジットカードを登録
    func paymentAdd(paymentMethodId: String) {
        print("APIAPIAPIAPIAPIAPIAPIAPIAPIAPIAPI")
        print(paymentMethodId)

        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_REGISTRATION_CREDIT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
//        query["stripeToken"] = String(token.tokenId)
        query["payment_method"] = paymentMethodId
        var headers: [String : String] = [:]
        var api_key = userDefaults.object(forKey: "api_token") as? String
        if ((api_key) != nil) {
            headers = [
                "Accept" : "application/json",
                "Authorization" : "Bearer " + api_key!,
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }
        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            print("リクエストUUUUUUUUU")
            print(requestUrl)
//            print(method)
            print(query)
            print("リクエストRREREEEEEEEEEEEEE")
            switch response.result {
            case .success:
                var json:JSON;
                do{
                    //レスポンスデータを解析
                    json = try SwiftyJSON.JSON(data: response.data!);
                } catch {
                    // error
                    print("json error: \(error.localizedDescription)");
//                     self.onFaild(response as AnyObject);
                    break;
                }
                print("取得した値はここにきて")
                self.dismiss(animated: true, completion: nil)
            case .failure:
                //  リクエスト失敗 or キャンセル時
                print("リクエスト失敗 or キャンセル時")
                return;
            }
        }
    }
}

extension PaymentViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
