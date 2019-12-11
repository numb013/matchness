//
//  PointPaymentViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/12/04.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PointPaymentViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    let pointPaymentList: [String] = ["100", "200","300","400","500"]

    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiPaymentPointList> = [:]
    var dataSourceOrder: Array<String> = []
    private var requestAlamofire: Alamofire.Request?;

    var selectRow = 0
    var isLoading:Bool = false
    var page_no = "1"
    let userDefaults = UserDefaults.standard
    var amount:String = String()
    var customer_status: String = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        
//        let userDefaults = UserDefaults.standard
//        userDefaults.removeObject(forKey: "customer_status")

        
        self.tableView.register(UINib(nibName: "pointPaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "pointPaymentTableViewCell")
        // Do any additional setup after loading the view.
        apiRequest()
    }

    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestPointPaymentModel = PointPaymentModel();
        requestPointPaymentModel.delegate = self as! PointPaymentModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_POINT_PAYMENT;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var api_key = userDefaults.object(forKey: "api_token") as? String
        query["api_token"] = api_key
        //リクエスト実行
        if( !requestPointPaymentModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        print("マイデータ")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointPaymentTableViewCell") as! pointPaymentTableViewCell


        var point_pay = self.dataSource[String(indexPath.row)]
        cell.amont.text = point_pay?.amont
        cell.point.text = point_pay?.point
//        var number = Int.random(in: 1 ... 18)
        cell.pointPaymentImage.image = UIImage(named: "new1")
        cell.pointPaymentImage.isUserInteractionEnabled = true
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
//        recognizer.targetUserId = pointPaymentList[indexPath.row]
        recognizer.amont = point_pay?.amont
        cell.pointPaymentImage.addGestureRecognizer(recognizer)
        
//        cell.createTime.text = "aaaaaaa"
        return cell
    }
    
    @objc func onTap(_ sender: MyTapGestureRecognizer) {

        print("YYYYYYYYYYYYYY")

        self.amount = sender.amont!
        if (self.userDefaults.object(forKey: "customer_status") == nil) {
            let storyboard: UIStoryboard = self.storyboard!
            let nextVC = storyboard.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
            nextVC.amount = amount
            // nextVC.customer_id = "customer_id"
            print("CCCCCCCCCCCCCCCCCC")
            print(amount)

            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)

        } else {
            let alertController:UIAlertController =
                UIAlertController(title:"登録したクレジットカードで購入しますか？",message: "次回から入力なしでポイントの購入ができます",preferredStyle: .alert)
            // Default のaction
            let defaultAction:UIAlertAction =
                UIAlertAction(title: "購入する",style: .destructive,handler:{
                    (action:UIAlertAction!) -> Void in
                    // 処理
                    //  self.dismiss(animated: true, completion: nil)
                    self.customer_status = self.userDefaults.object(forKey: "customer_status") as! String
                    self.pay()

                })
            // Cancel のaction
            let cancelAction:UIAlertAction =
                UIAlertAction(title: "登録しない",style: .cancel,handler:{
                    (action:UIAlertAction!) -> Void in
                    // 処理
                    print("キャンセル")
                    let storyboard: UIStoryboard = self.storyboard!
                    //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                    let multiple = storyboard.instantiateViewController(withIdentifier: "menutable")
                    multiple.modalPresentationStyle = .fullScreen
                    //ここが実際に移動するコードとなります
                    self.present(multiple, animated: false, completion: nil)
                })
            
            alertController.addAction(defaultAction)
            alertController.addAction(cancelAction)
            // UIAlertControllerの起動
            self.present(alertController, animated: true, completion: nil)
        }
    }


    func pay() {
        print("aaaaa")
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_CHARGE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
//        query["stripeToken"] = String(token.tokenId)
        query["amount"] = self.amount
        query["customer_status"] = customer_status
        var headers: [String : String] = [:]
        var api_key = userDefaults.object(forKey: "api_token") as? String
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
        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            print("リクエストRRRRRRRRRRRRRRRRRR")
            print(requestUrl)
//            print(method)
            print(query)
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
//                     self.onFaild(response as AnyObject);
                    break;
                }
                print("取得した値はここにきて")
                print(json)

            case .failure:
                //  リクエスト失敗 or キャンセル時
                print("リクエスト失敗 or キャンセル時")
                return;
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PointPaymentViewController : PointPaymentModelDelegate {

    func onStart(model: PointPaymentModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onComplete(model: PointPaymentModel, count: Int) {
        print("着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        
        print(self.dataSourceOrder)
        print("耳耳耳意味耳みm")
        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
        
        print("路オロロロロロロロロ路r")
        self.page_no = String(model.page);
        print(self.page_no)
        print("ががががががががが")
        print(self.dataSource)
        print(self.dataSourceOrder)
        
        var count: Int = 0;
        
        self.isLoading = false
        tableView.reloadData()
    }

    func onFailed(model: PointPaymentModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }
    
}
