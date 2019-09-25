//
//  SettingEditViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/08.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController{

    let userDefaults = UserDefaults.standard
    var notice_id = Int()

    
    @IBOutlet weak var noticeDetail: UITextView!
    
    var cellCount: Int = 0
    var dataSource: Dictionary<String, ApiNoticeList> = [:]
    var dataSourceOrder: Array<String> = []

    var selectRow = 0

    override func viewDidLoad() {

print("notice_idnotice_idnotice_idnotice_id")
print(notice_id)

        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        // Do any additional setup after loading the view.

        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestNoticeDetailModel = NoticeDetailModel();
        requestNoticeDetailModel.delegate = self as! NoticeDetailModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SELECT_NOTICE_TEXT_BODY;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var api_key = userDefaults.object(forKey: "api_token") as? String
        query["notice_id"] = String(notice_id)
        //リクエスト実行
        if( !requestNoticeDetailModel.requestApi(url: requestUrl, addQuery: query) ){

        }
        print("マイデータ")
    }

    func viewNoticeDetail() {
        var detail = self.dataSource["0"]
        noticeDetail.text = detail?.body_text
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


extension NoticeDetailViewController : NoticeDetailModelDelegate {

    func onStart(model: NoticeDetailModel) {
        print("こちら/SettingEdit/UserDetailViewのonStart")
    }
    func onComplete(model: NoticeDetailModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;

        print(self.dataSourceOrder)
        print("UserDetail耳耳耳意味耳みm")
        print(self.dataSource)


        //一つもなかったら
        //        if( dataSourceOrder.isEmpty ){
        //            return;
        //        }

        //cellの件数更新
        self.cellCount = dataSourceOrder.count;
        //        self.cellCount = 10;



        //
        var count: Int = 0;
        //        for(key, code) in dataSourceOrder.enumerated() {
        //            count+=1;
        //            if let jenre: ApiUserDateParam = dataSource[code] {
        //                //取得したデータを元にコレクションを再構築＆更新
        //                mapMenuView.addTagGroup(model: model, jenre: jenre);
        //            }
        //        }

        viewNoticeDetail()
    }
    func onFailed(model: NoticeDetailModel) {
        print("こちら/ProfileEditModel/UserDetailViewのonFailed")
    }

}
