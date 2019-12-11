//
//  SettingEditViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/08.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    private var requestAlamofire: Alamofire.Request?;
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var UserSettingTable: UITableView!
    var ActivityIndicator: UIActivityIndicatorView!

    var setDateviewTime = ""
    var vi = UIView()
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiSetting> = [:]
    var dataSourceOrder: Array<String> = []
    var selectRow = 0
    var status = ""
    var swich_status:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        UserSettingTable.delegate = self
        UserSettingTable.dataSource = self
        // Do any additional setup after loading the view.

        
        // ActivityIndicatorを作成＆中央に配置
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        // 色を設定
        ActivityIndicator.style = UIActivityIndicatorView.Style.gray
        //Viewに追加
        self.view.addSubview(ActivityIndicator)
        ActivityIndicator.startAnimating()
        
        Thread.sleep(forTimeInterval: 5)
        
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestSettingEditModel = SettingEditModel();
        requestSettingEditModel.delegate = self as! SettingEditModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_SETTING;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        //リクエスト実行
        if( !requestSettingEditModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
        print("マイデータ")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "設定1"
        }
        if section == 1 {
            return "設定2"
        }
        if section == 2 {
            return "設定3"
        }
        return "設定"
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.tintColor = #colorLiteral(red: 0.9499146342, green: 0.9500735402, blue: 0.9498936534, alpha: 1)
        header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("こいいいいいい")
        print(self.dataSource)
        var mySetting = self.dataSource["0"]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let switchView = UISwitch()
        cell.accessoryView = switchView

        if indexPath.section == 0 {

            if indexPath.row == 0 {
                cell.textLabel?.text = "メッセージ通知"
                if (mySetting?.message_notice == 0) {
                    swich_status = false
                } else {
                    swich_status = true
                }
                //スイッチの状態
                switchView.isOn = swich_status
                //タグの値にindexPath.rowを入れる。
                switchView.tag = indexPath.row
                //スイッチが押されたときの動作
                switchView.addTarget(self, action: #selector(fundlSwitch(_:)), for: UIControl.Event.valueChanged)
                return cell
            }
            if indexPath.row == 1 {
                cell.textLabel?.text = "グループ通知"
                if (mySetting?.group_notice == 0) {
                    swich_status = false
                } else {
                    swich_status = true
                }
                //スイッチの状態
                switchView.isOn = swich_status
                //タグの値にindexPath.rowを入れる。
                switchView.tag = indexPath.row
                //スイッチが押されたときの動作
                switchView.addTarget(self, action: #selector(fundlSwitch(_:)), for: UIControl.Event.valueChanged)
                return cell
            }
            if indexPath.row == 2 {
                cell.textLabel?.text = "足跡通知"
                if (mySetting?.foot_notice == 0) {
                    swich_status = false
                } else {
                    swich_status = true
                }
                //スイッチの状態
                switchView.isOn = swich_status
                //タグの値にindexPath.rowを入れる。
                switchView.tag = indexPath.row
                //スイッチが押されたときの動作
                switchView.addTarget(self, action: #selector(fundlSwitch(_:)), for: UIControl.Event.valueChanged)
                return cell
            }
            if indexPath.row == 3 {
                cell.textLabel?.text = "マッチング通知"
                if (mySetting?.match_notice == 0) {
                    swich_status = false
                } else {
                    swich_status = true
                }
                //スイッチの状態
                switchView.isOn = swich_status
                //タグの値にindexPath.rowを入れる。
                switchView.tag = indexPath.row
                //スイッチが押されたときの動作
                switchView.addTarget(self, action: #selector(fundlSwitch(_:)), for: UIControl.Event.valueChanged)
                return cell
            }

        }

//        if indexPath.section == 1 {
//            if indexPath.row == 0 {
//                cell.textLabel?.text = "マッチング通知"
//                //スイッチの状態
//                switchView.isOn = ((mySetting?.match_notice) != nil)
//                //タグの値にindexPath.rowを入れる。
//                switchView.tag = indexPath.row
//                //スイッチが押されたときの動作
//                switchView.addTarget(self, action: #selector(fundlSwitch(_:)), for: UIControl.Event.valueChanged)
//                return cell
//            }
//
//        }
        return cell
    }

    //スイッチのテーブルが変更されたときに呼ばれる
    @objc func fundlSwitch(_ sender: UISwitch) {
        print("スイッチスイッチスイッチスイッチスイッチ")
        print(sender.tag)
        print(sender.isOn)

        settingApi(sender.tag, sender.isOn)
    }

    func aaaaaaa() {
        print("ASAEIJIHUGUGUYG")
    }
    func settingApi(_ status1:Int, _ status2:Bool) {
        print("APIへリクエスト（ユーザー取得")
        let requestUrl: String = ApiConfig.REQUEST_URL_API_EDIT_SETTING;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();

        if (status2 == false) {
            self.status = "0"
        } else {
            self.status = "1"
        }

        if (status1 == 0) {
            query["message_notice"] = self.status
        }
        if (status1 == 1) {
            query["group_notice"] = self.status
        }
        if (status1 == 2) {
            query["foot_notice"] = self.status
        }
        if (status1 == 3) {
            query["match_notice"] = self.status
        }

        var headers: [String : String] = [:]

        var api_key = userDefaults.object(forKey: "api_token") as? String
        if ((api_key) != nil) {
            headers = [
                "Accept" : "application/json",
                "Authorization" : "Bearer " + api_key!,
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }

print("SDSDSDSDSDSDSDSDSDSDSDSDS")
print(requestUrl)

        self.requestAlamofire = Alamofire.request(requestUrl, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                var json:JSON;
                do{
                    json = try SwiftyJSON.JSON(data: response.data!);
                } catch {
                    break;
                }
            case .failure:
                //  リクエスト失敗 or キャンセル時
                let alert = UIAlertController(title: "設定", message: "失敗しました。", preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                })
                return;
            }
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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

extension SettingEditViewController : SettingEditModelDelegate {
    func onStart(model: SettingEditModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onComplete(model: SettingEditModel, count: Int) {
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        self.cellCount = dataSourceOrder.count;
        var count: Int = 0;

        ActivityIndicator.stopAnimating()
        UserSettingTable.reloadData()
    }
    func onFailed(model: SettingEditModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }
    
}
