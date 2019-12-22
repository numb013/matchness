//
//  accodionViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/11/09.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {


    @IBOutlet weak var menuTableView: UITableView!

        var status = ""
        var swich_status:Bool = true
        var cellCount: Int = 0
        var dataSource: Dictionary<String, ApiSetting> = [:]
        var dataSourceOrder: Array<String> = []
        var ActivityIndicator: UIActivityIndicatorView!
    
        private var sections: [Section] = [
            Section(title: "通知設定",values: [("MEN", false),("WOMEN", false),("KIDS", false)],expanded: true),
            Section(title: "初めての方",values: [("POPO-KATSUとは？", false),("POPO-KATSUで出来る事", false)],expanded: true),
            Section(title: "よくある質問",values: [
                ("このアプリは無料ですか？", false),
                ("歩数はどうやって取得？", false),
                ("カロリーの計算は？", false),
            ],expanded: true),
            Section(title: "グループについて",values: [
                ("グループの作り方", false),
                ("グループの使い方", false),
                ("グループで出来る事", false),
            ],expanded: true),
            Section(title: "ポイントについて",values: [("ポイントの貯め方", false),("何をすればポイントを消費する", false),("ポイント購入について", false)],expanded: true),
            Section(title: "メッセージついて",values: [("ダミーダミーダミーダミーダミーダミーダミーダミーダミーダミーダミーダミーダミー", false)],expanded: true),
        ]

        override func viewDidLoad() {
            super.viewDidLoad()
            self.menuTableView.estimatedRowHeight = 150
            self.menuTableView.rowHeight = UITableView.automaticDimension
            setupTableView()

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
                return 3
            } else {
                return sections[section].values.count
            }
            return 2
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("タップ")
            print(indexPath.row)
            print("たっぷりなたっぷりなたっぷりな");
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            var mySetting = self.dataSource["0"]

            if (indexPath.section == 0) {
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
                cell.titleLabel.numberOfLines=0
                cell.titleLabel.text = sections[indexPath.section].values[indexPath.row].title
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                return cell
            }

            if (indexPath.section == 5) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
                cell.titleLabel.numberOfLines=0
                cell.titleLabel.text = sections[indexPath.section].values[indexPath.row].title
//                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                return cell
            }
            
            //            if (indexPath.section == 5) {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
//                cell.titleLabel.numberOfLines=0
//                cell.titleLabel.text = sections[indexPath.section].values[indexPath.row].title
//                return cell
//            }
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

        //スイッチのテーブルが変更されたときに呼ばれる
        @objc func fundlSwitch(_ sender: UISwitch) {
            print("スイッチスイッチスイッチスイッチスイッチ")
            print(sender.tag)
            print(sender.isOn)
        //    settingApi(sender.tag, sender.isOn)
        }

}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
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
        ActivityIndicator.stopAnimating()
        menuTableView.reloadData()
    }
    func onFailed(model: SettingEditModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }
    
    func onError(model: SettingEditModel) {
        ActivityIndicator.stopAnimating()
        let alertController:UIAlertController = UIAlertController(title:"サーバーエラー",message: "アプリを再起動してください",preferredStyle: .alert)
        // Default のaction
        let defaultAction:UIAlertAction = UIAlertAction(title: "アラートを閉じる",style: .destructive,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                //  self.dismiss(animated: true, completion: nil)
            })
        alertController.addAction(defaultAction)
        // UIAlertControllerの起動
        self.present(alertController, animated: true, completion: nil)
    }

}
