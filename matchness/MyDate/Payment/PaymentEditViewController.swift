//
//  PaymentEditViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/12/30.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class PaymentEditViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var dataSource: Dictionary<String, ApiPaymentEditList> = [:]
    var dataSourceOrder: Array<String> = []
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    var cellCount: Int = 0
    var status:Int = 0
    var card_id : String = "0"
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        print("JIJIJIJIJIJIJIJ")
        
        self.tableView.register(UINib(nibName: "PaymentEditTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentEditTableViewCell")
        apiRequest()
        // Do any additional setup after loading the view.
    }

    func apiRequest() {
        print("ステータス!!!!!!!!")
        print(status)
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestPaymentEditModel = PaymentEditModel();
        requestPaymentEditModel.delegate = self as! PaymentEditModelDelegate;
        //リクエスト先
        var requestUrl: String = ""

print("ああああああああああああああああああああ")
print(status)
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        requestUrl = ApiConfig.REQUEST_URL_API_SELECT_PAYMENT_EDIT_LIST;

        //リクエスト実行
        if( !requestPaymentEditModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentEditTableViewCell") as! PaymentEditTableViewCell
        var multiple = self.dataSource[String(indexPath.row)]


        if (multiple?.profile_image == nil) {
            cell.company_img.image = UIImage(named: "no_image")
        } else {
            let profileImageURL = image_url + ((multiple?.profile_image!)!)
            let url = NSURL(string: profileImageURL);
            let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
            cell.company_img.image = UIImage(data:imageData! as Data)
        }
        
        
        // cell.createTime.text = multiple?.expiration_date! ?? "aaaa"

        cell.card_company.text = multiple?.card_company
        cell.card_no.text = multiple?.card_no
        cell.expiration_date.text = "aaaa"

        cell.deleteButton.setTitle("主催グループ", for: .normal)
        var recognizer = MyTapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        recognizer.targetString = "3"
        recognizer.payment_id = multiple?.id
        cell.deleteButton.layer.backgroundColor = #colorLiteral(red: 0.0163966082, green: 0.5516188145, blue: 0.6297279, alpha: 1)
        cell.deleteButton.addGestureRecognizer(recognizer)
        return cell
    }

    
    @objc func onTap(_ sender: MyTapGestureRecognizer) {
        print("タップタップタップ")
        deleteApi()

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func deleteApi() {
        print("ステータス!!!!!!!!")
        print(status)
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestPaymentEditModel = PaymentEditModel();
        requestPaymentEditModel.delegate = self as! PaymentEditModelDelegate;
        //リクエスト先
        var requestUrl: String = ""
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        requestUrl = ApiConfig.REQUEST_URL_API_PAYMENT_DELETE;
        query["id"] = self.card_id
        //リクエスト実行
        if( !requestPaymentEditModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    
    
    //    @IBAction func toMyDataButton(_ sender: Any) {
    //        let storyboard: UIStoryboard = self.storyboard!
    ////ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
    //        let multiple = storyboard.instantiateViewController(withIdentifier: "Mydate")
    //    multiple.modalPresentationStyle = .fullScreen
    //        //ここが実際に移動するコードとなります
    //        self.present(multiple, animated: false, completion: nil)
    //    }

        
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

    }

    extension PaymentEditViewController : PaymentEditModelDelegate {
        func onFinally(model: PaymentEditModel) {
            print("こちら/SettingEdit/UserDetailViewのonStart")
        }
        
        func onStart(model: PaymentEditModel) {
            print("こちら/UserDetail/UserDetailViewのonStart")
        }

        func onComplete(model: PaymentEditModel, count: Int) {
            print("着てきてきてきて")
            //更新用データを設定
            self.dataSource = model.responseData;
            self.dataSourceOrder = model.responseDataOrder;
            
            print(self.dataSourceOrder)
            print("耳耳耳意味耳みm")
            //cellの件数更新
            self.cellCount = dataSourceOrder.count;
            
            print("路オロロロロロロロロ路r")

            print("ががががががががが")
            print(self.dataSource)
            print(self.dataSourceOrder)
            
            var count: Int = 0;

            tableView.reloadData()
        }

        func onFailed(model: PaymentEditModel) {
            print("こちら/PaymentEditModel/UserDetailViewのonFailed")
        }
        
        func onError(model: PaymentEditModel) {
            print("modelmodelmodelmodel")
            self.errorData = model.errorData;
            Alert.common(alertNum: self.errorData, viewController: self)
        }

    }


