//
//  accodionViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/11/09.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!

    var status = ""
    var notice_setting = ""
    var swich_status:Bool = true
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiSetting> = [:]
    var errorData: Dictionary<String, ApiErrorAlert> = [:]
    private var requestAlamofire: Alamofire.Request?;
    var dataSourceOrder: Array<String> = []
//    var ActivityIndicator: UIActivityIndicatorView!
    var activityIndicatorView = UIActivityIndicatorView()

    private var sections: [Section] = [
        Section(title: "通知設定",values: [],expanded: true),
        Section(title: "初めての方",values: [
            ("POPO-KATSUとは？", false),
            ("グループ", false),
            ("POPO-KATSUポイント", false),
            ("メッセージについて", false),

        ],expanded: true),
        Section(title: "よくある質問",values: [
            ("このアプリは無料ですか？", false),
            ("歩数はどうやって取得？", false),
            ("カロリーの計算は？", false),
            ("何をすればポイントを消費する", false),
        ],expanded: true),
        Section(title: "退会について",values: [
            ("退会についての説明", false),
            ("退会する", false),
        ],expanded: true),
        Section(title: "その他",values: [("利用規約", false),("ポイント利用規約", false),("プライバシーポリシー", false),("お問い合わせ", false)],expanded: true),

    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.estimatedRowHeight = 150
        self.menuTableView.rowHeight = UITableView.automaticDimension
        setupTableView()
        
        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        view.addSubview(activityIndicatorView)

        //通知設定確認
        updateUI()

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

    private func setupTableView() {
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            if self.notice_setting == "1" {
                return 4
            } else {
                return 1
            }
        } else if (section == 4) {
            return 4
        } else {
            return sections[section].values.count
        }
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mySetting = self.dataSource["0"]
        if (indexPath.section == 0) {
            if self.notice_setting == "1" {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
                let switchView = UISwitch()
                cell.accessoryView = switchView
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
            } else if self.notice_setting == "0" {
                if indexPath.row == 0 {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
                    cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
//                    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//                    // セルに表示する値を設定する
                    cell.textLabel!.text = "通知オンに設定する"
                    return cell
                }
            }
        }

        if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
            cell.titleLabel.numberOfLines=0
            cell.titleLabel.text = sections[indexPath.section].values[indexPath.row].title
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        }
        if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
            cell.titleLabel.numberOfLines=0
            cell.titleLabel.text = sections[indexPath.section].values[indexPath.row].title
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        }
        if (indexPath.section == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
            cell.titleLabel.numberOfLines=0
            cell.titleLabel.text = sections[indexPath.section].values[indexPath.row].title
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        }
        if (indexPath.section == 4) {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
            if indexPath.row == 0 {
//                    cell.titleLabel.numberOfLines=0
                cell.textLabel?.text = sections[indexPath.section].values[indexPath.row].title
                return cell
            }
            if indexPath.row == 1 {
                cell.textLabel?.text = sections[indexPath.section].values[indexPath.row].title
                return cell
            }
            if indexPath.row == 2 {
                cell.textLabel?.text = sections[indexPath.section].values[indexPath.row].title
                return cell
            }
            if indexPath.row == 3 {
                cell.textLabel?.text = sections[indexPath.section].values[indexPath.row].title
                return cell
            }
        }
//            if (indexPath.section == 6) {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
//                cell.titleLabel.numberOfLines=0
//                cell.titleLabel.text = sections[indexPath.section].values[indexPath.row].title
//                return cell
//            }
//            if (indexPath.section == 70) {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
//                cell.titleLabel.numberOfLines=0
//                cell.titleLabel.text = sections[indexPath.section].values[indexPath.row].title
//                return cell
//            }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップ")
        print(indexPath.section)
        print("/")

        if (self.notice_setting == "0" && indexPath.section == 0 && indexPath.row == 0) {
            // OSの通知設定画面へ遷移
            if let url = URL(string:"App-Prefs:root=NOTIFICATIONS_ID&path=com.a2c.popokatsu") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        } else if (indexPath.section == 3) {
            if (indexPath.row == 1) {
                let alertController:UIAlertController =
                    UIAlertController(title:"退会する",message: "本当に退会しますか？",preferredStyle: .alert)
                let defaultAction:UIAlertAction =
                    UIAlertAction(title: "退会する",style: .destructive,handler:{
                    (action:UIAlertAction!) -> Void in
                        print("退会する")
                        self.userDeletApi()
                    })
                let cancelAction:UIAlertAction =
                    UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                    (action:UIAlertAction!) -> Void in
                        print("キャンセル")
                    })
                alertController.addAction(cancelAction)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
        } else {
            print(indexPath.row)
            let storyboard: UIStoryboard = self.storyboard!
            let nextVC = storyboard.instantiateViewController(withIdentifier: "webView") as! WebViewViewController
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.webType = String(indexPath.section) + String(indexPath.row)
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    //スイッチのテーブルが変更されたときに呼ばれる
    @objc func fundlSwitch(_ sender: UISwitch) {
        print("スイッチスイッチスイッチスイッチスイッチ")
        print(sender.tag)
        print(sender.isOn)
        settingApi(sender.tag, sender.isOn)
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

//                    self.ActivityIndicator.stopAnimating()
                self.activityIndicatorView.stopAnimating()
//                    self.dismiss(animated: true, completion: nil)
            case .failure:
                //  リクエスト失敗 or キャンセル時
                let alert = UIAlertController(title: "設定", message: "失敗しました。", preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                })
                return;
            }
        }
    }

    func userDeletApi() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestMyDataModel = MyDataModel();
        requestMyDataModel.delegate = self as! MyDataModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_USER_DELETE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        query["status"] = "0"
        //リクエスト実行
        if( !requestMyDataModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }

        userDefaults.removeObject(forKey: "api_token")
        userDefaults.removeObject(forKey: "login_type")
        userDefaults.removeObject(forKey: "login_step_1")
        userDefaults.removeObject(forKey: "profileImageURL")
        userDefaults.removeObject(forKey: "login_step_2")
        userDefaults.removeObject(forKey: "searchWork")
        userDefaults.removeObject(forKey: "prefecture_id")
        userDefaults.removeObject(forKey: "blood_type")
        userDefaults.removeObject(forKey: "fitness_parts_id")
        userDefaults.removeObject(forKey: "matchness_user_id")
        userDefaults.removeObject(forKey: "point")
        
        let storyboard: UIStoryboard = self.storyboard!
        let multiple = storyboard.instantiateViewController(withIdentifier: "fblogin")
        multiple.modalPresentationStyle = .fullScreen
        self.present(multiple, animated: false, completion: nil)
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 || indexPath.section == 4 {
            return UITableView.automaticDimension
        }
        if sections[indexPath.section].expanded {
            return 0
        } else {
            return UITableView.automaticDimension
        }
        
    }

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView()
        headerView.config(title: sections[section].title, section: section) { [unowned self] section in
            self.sections[section].expanded = !self.sections[section].expanded
            self.menuTableView.beginUpdates()
            for i in 0 ..< self.sections[section].values.count {
                self.menuTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            }
            self.menuTableView.endUpdates()
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }


    @IBAction func backFromMenuView(segue:UIStoryboardSegue){
        NSLog("ReportViewController#backFromMenuView")
    }

    func updateUI() {
        guard let types = UIApplication.shared.currentUserNotificationSettings?.types else {
            print("000000")
            return
        }
        switch types {
        case [.badge, .alert]:
            self.notice_setting = "0"
        case [.badge]:
            self.notice_setting = "0"
        case []:
            self.notice_setting = "0"
        default:
            self.notice_setting = "1"
            print("Handle the default case") //TODO
        }
    }
}


extension MenuViewController : SettingEditModelDelegate {
    func onFinally(model: SettingEditModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onStart(model: SettingEditModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onComplete(model: SettingEditModel, count: Int) {
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        self.cellCount = dataSourceOrder.count;
        var count: Int = 0;

print("設定設定設定設定設定")
print(self.dataSource)
//        ActivityIndicator.stopAnimating()
        self.activityIndicatorView.stopAnimating()
        menuTableView.reloadData()
    }
    func onFailed(model: SettingEditModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }
    
    func onError(model: SettingEditModel) {
        print("modelmodelmodelmodel")
        self.errorData = model.errorData;
        Alert.common(alertNum: self.errorData, viewController: self)
    }

}
