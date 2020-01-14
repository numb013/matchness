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
    var dataSource: Dictionary<String, ApiUserPaymentInfo> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]

    private var requestAlamofire: Alamofire.Request?;
    var ActivityIndicator: UIActivityIndicatorView!

    var selectRow = 0
    var isLoading:Bool = false
    var page_no = "1"
    let userDefaults = UserDefaults.standard
    var amount:String = String()
    var pay_point_id:String = String()
    var customer_status: String = String()

    var card_no = ""
    var card_company = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "pointPaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "pointPaymentTableViewCell")
        self.tableView.register(UINib(nibName: "PointExplanationTableViewCell", bundle: nil), forCellReuseIdentifier: "PointExplanationTableViewCell")
        // Do any additional setup after loading the view.
        apiRequest()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        payalert()
//    }

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
        return self.cellCount + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "aaa")

        if (indexPath.row + 1 == self.cellCount + 1) {
            print("せえと2222222222")
            print(indexPath.row)
//            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "aaa")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PointExplanationTableViewCell") as! PointExplanationTableViewCell

//            cell.textLabel?.text = "string"
//            cell.detailTextLabel?.text = "string"
            cell.pointExplanationImage?.image = UIImage(named: "1_samp")
            return cell
        } else {
            print("せえと111111")
            print("SDSDSDSDSWEWE")
            print(self.dataSource["0"])
            if self.dataSource["0"]?.card_no != nil {
                card_no = self.dataSource["0"]!.card_no!
                card_company = self.dataSource["0"]!.card_company!
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: "pointPaymentTableViewCell") as! pointPaymentTableViewCell
            var point_pay = self.dataSource["0"]!.payment_point_list[indexPath.row]

            cell.amount.text = point_pay.amount
            cell.point.text = point_pay.point
    //        var number = Int.random(in: 1 ... 18)
            cell.pointPaymentImage.image = UIImage(named: "new1")
            cell.pointPaymentImage.isUserInteractionEnabled = true
            var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
    //        recognizer.targetUserId = pointPaymentList[indexPath.row]


            recognizer.amount = point_pay.amount
            recognizer.pay_point_id = point_pay.id
            cell.pointPaymentImage.addGestureRecognizer(recognizer)

            self.userDefaults.set(Int(point_pay.point!), forKey: "point")
            return cell
        }
//        cell.createTime.text = "aaaaaaa"
        return cell
    }
    
    @objc func onTap(_ sender: MyTapGestureRecognizer) {

        print("YYYYYYYYYYYYYY")

        self.amount = sender.amount!
        self.pay_point_id = sender.pay_point_id!
        if (self.userDefaults.object(forKey: "customer_status") == nil) {
            let storyboard: UIStoryboard = self.storyboard!
            let nextVC = storyboard.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
            nextVC.amount = self.amount
             nextVC.pay_point_id = self.pay_point_id
            print("CCCCCCCCCCCCCCCCCC")
            print(amount)

            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)

        } else {
            let alertController:UIAlertController =
                UIAlertController(title:"登録したクレジットカードで購入しますか？",message: "登録済みカード：" + card_company + " " + card_no  ,preferredStyle: .alert)
            // Default のaction
            let defaultAction:UIAlertAction =
                UIAlertAction(title: "購入する",style: .destructive,handler:{
                    (action:UIAlertAction!) -> Void in
                    // 処理
                    //  self.dismiss(animated: true, completion: nil)

                    // ActivityIndicatorを作成＆中央に配置
                    self.ActivityIndicator = UIActivityIndicatorView()
                    self.ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                    self.ActivityIndicator.center = self.view.center
                    // クルクルをストップした時に非表示する
                    self.ActivityIndicator.hidesWhenStopped = true
                    // 色を設定
                    self.ActivityIndicator.style = UIActivityIndicatorView.Style.gray
                    //Viewに追加
                    self.view.addSubview(self.ActivityIndicator)
                    self.ActivityIndicator.startAnimating()

                    self.customer_status = self.userDefaults.object(forKey: "customer_status") as! String
                    self.pay()

                })

            
            let destructiveAction:UIAlertAction =
                UIAlertAction(title: "別のカードで購入する",style: UIAlertAction.Style.destructive,
                handler:{
                    (action:UIAlertAction!) -> Void in
                    let storyboard: UIStoryboard = self.storyboard!
                    let nextVC = storyboard.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
                    nextVC.amount = self.amount
                     nextVC.pay_point_id = self.pay_point_id
                    print("CCCCCCCCCCCCCCCCCC")
                    print(self.amount)

                    nextVC.modalPresentationStyle = .fullScreen
                    self.present(nextVC, animated: true, completion: nil)
            })
            

            // Cancel のaction
            let cancelAction:UIAlertAction =
                UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                    (action:UIAlertAction!) -> Void in
                    // 処理
                    print("キャンセル")
//                    self.dismiss(animated: true, completion: nil)
                })
            
            alertController.addAction(defaultAction)
            alertController.addAction(destructiveAction)
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
        query["pay_point_id"] = self.pay_point_id
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

                self.ActivityIndicator.stopAnimating()

                self.payalert()
                self.dismiss(animated: true, completion: nil)
            case .failure:
                //  リクエスト失敗 or キャンセル時
                print("リクエスト失敗 or キャンセル時")
                return;
            }
        }
    }

    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    func payalert() {
        
        // アラート作成
        let alert = UIAlertController(title: "ポイント購入完了", message: "ありがとうございます", preferredStyle: .alert)
        // アラート表示
        self.present(alert, animated: true, completion: {
            // アラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                print("こここここここここここkは？？？")

                self.dismiss(animated: true, completion: nil)
//                let storyboard: UIStoryboard = self.storyboard!
//                //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
//                let multiple = storyboard.instantiateViewController(withIdentifier: "pointChange")
//                multiple.modalPresentationStyle = .fullScreen
//                //ここが実際に移動するコードとなります
//                self.present(multiple, animated: false, completion: nil)
            })
        })
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
    func onFinally(model: PointPaymentModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    
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
        self.cellCount = dataSource["0"]!.payment_point_list.count;
        
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
    
    func onError(model: PointPaymentModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }

}
