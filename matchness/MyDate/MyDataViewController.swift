//
//  MyDataViewController.swift
//  matchness
//
//  Created by user on 2019/02/05.
//  Copyright © 2019年 a2c. All rights reserved.
//

import UIKit
import CoreMotion
import MBCircularProgressBar

class MyDataViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserJob: UILabel!
    @IBOutlet weak var Menu: UICollectionView!
    @IBOutlet var stepCountLabel: UIButton!
    @IBOutlet weak var progressViewBar: MBCircularProgressBarView!
    @IBOutlet weak var myPoint: UILabel!
    

    var dataSource: Dictionary<String, ApiMyData> = [:]
    var dataSourceOrder: Array<String> = []
    var cellCount: Int = 0



    var times: [String]!
    let dateFormatter = DateFormatter()
    let now = Date()
    var day = 0
    var counter = 0.0
    var step_1: [Double] = []
    
    let topMenu = ["AAA", "BBB", "CCC"]
    let systemMenu = ["足あと", "もらったいいね", "プロフィール", "お気に入り", "ポイント交換", "お知らせ", "ブロック", "設定", "退会", "ポイント履歴", "マイデータ"]

    override func viewDidLoad() {
        super.viewDidLoad()

        Menu.delegate = self
        Menu.dataSource = self
        
        var number = Int.random(in: 1 ... 2)
        UserImage.image = UIImage(named: "\(number)")
        UserName.text = "松本人志 48歳"
        UserJob.text = "エンジニア"
        getStepDate()
        // Do any additional setup after loading the view.

        apiRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("マイページ戻りマイページ戻りマイページ戻りマイページ戻り")
        apiRequest()
    }

    func apiRequest() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestMyDataModel = MyDataModel();
        requestMyDataModel.delegate = self as! MyDataModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_ME;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        var api_key = userDefaults.object(forKey: "api_token") as? String
        query["api_token"] = api_key
        //リクエスト実行
        if( !requestMyDataModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    func returnView() {
        var detail = self.dataSource["0"]

        var number = Int.random(in: 1 ... 2)
        UserImage.image = UIImage(named: "\(number)")
        UserName.text = detail?.name
        UserJob.text = ApiConfig.WORK_LIST[(detail?.work ?? 0)!]
        myPoint.text = detail?.point
        print("detaildetaildetaildetaildetail")
        print(detail)
    }
//    override func viewDidAppear(_ animated: Bool) {
//
//    }
    
    
    let pedometer:CMPedometer = CMPedometer()//プロパティでCMPedometerをインスタンス化。

    func getStepDate() {
        //歩数が取得できるかどうかチェックしてます
        if(!CMPedometer.isStepCountingAvailable()) {
            print("cannot get stepcount")
        }
        let from = Date(timeInterval: TimeInterval(-60*60*24*day), since: now)
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let selectDate =  dateFormatter.string(from: from)
        var component = NSCalendar.current.dateComponents([.year, .month, .day], from: from)
        component.hour = 0
        component.minute = 0
        component.second = 0
        let start:NSDate = NSCalendar.current.date(from:component)! as NSDate
        //XX月XX日23時59分59秒に設定したものをendにいれる
        component.hour = 23
        component.minute = 59
        component.second = 59
        let end:NSDate = NSCalendar.current.date(from:component)! as NSDate
        //現在を取得してます。
        let to = Date()
        
        pedometer.queryPedometerData(from: start as Date, to: end as Date) { (data, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                var step = data.numberOfSteps
                var distance = data.distance
                
                var distance_data = (Double(distance!) / 1000)
                var distance_para = round(distance_data*10)/10
                self.stepCountLabel.setTitle("\(data.numberOfSteps)", for: .normal)

                self.progressViewBar.value = (CGFloat(Double(step) / 10000)*100)
                
                print("歩数は\(data.numberOfSteps)")
                print("距離は\(data.distance))") // 距離
                print("登った回数\((data.floorsAscended))") // 上った回数
                print("降った回数\(data.floorsDescended))")
                
                //self.progressViewBar2.value = (CGFloat(Double(step) / 10000)*100)
            }
        }
    }

    
    //データの個数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return systemMenu.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //コレクションビューから識別子「TestCell」のセルを取得する。
        let cell = Menu.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath as IndexPath) as UICollectionViewCell
        //セルの背景色をランダムに設定する。
        //cell.contentView.backgroundColor = UIColor(red: 102/256, green: 255/256, blue: 255/256, alpha: 0.1)

        // Tag番号を使ってLabelのインスタンス生成
        let label = cell.contentView.viewWithTag(2) as! UILabel
        label.text = systemMenu[indexPath.row]

                // Tag番号を使ってImageViewのインスタンス生成
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView

        if indexPath.row == 0 {
            let cellImage = UIImage(named: "foot")
            imageView.image = cellImage
        }
        if indexPath.row == 1 {
            let cellImage = UIImage(named: "like")
            imageView.image = cellImage
        }
        if indexPath.row == 2 {
            let cellImage = UIImage(named: "prolile")
            imageView.image = cellImage
        }
        if indexPath.row == 3 {
            let cellImage = UIImage(named: "favorite")
            imageView.image = cellImage
        }
        if indexPath.row == 4 {
            let cellImage = UIImage(named: "change")
            imageView.image = cellImage
        }
        if indexPath.row == 5 {
            let cellImage = UIImage(named: "notice")
            imageView.image = cellImage
        }
        if indexPath.row == 6 {
            let cellImage = UIImage(named: "block")
            imageView.image = cellImage
        }
        if indexPath.row == 7 {
            let cellImage = UIImage(named: "setting")
            imageView.image = cellImage
        }
        if indexPath.row == 8 {
            let cellImage = UIImage(named: "out")
            imageView.image = cellImage
        }
        if indexPath.row == 9 {
            let cellImage = UIImage(named: "history")
            imageView.image = cellImage
        }
        if indexPath.row == 10 {
            let cellImage = UIImage(named: "stepdata")
            imageView.image = cellImage
        }
        // 画像配列の番号で指定された要素の名前の画像をUIImageとする
        // UIImageをUIImageViewのimageとして設定

        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        print("collectionViewcollectionViewcollectionView")
        print(collectionView)

        // 例えば端末サイズの半分の width と height にして 2 列にする場合
        let width: CGFloat = UIScreen.main.bounds.width / 3.02
        let height = width - 35
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SDSDSDSDSDSDSDSDSD")
        print(indexPath.row)
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 6) {
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let multiple = storyboard.instantiateViewController(withIdentifier: "multiple") as? MultipleViewController
            //ここが実際に移動するコードとなります
            multiple!.status = indexPath.row
            self.present(multiple!, animated: false, completion: nil)
        }

        if (indexPath.row == 2) {
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let multiple = storyboard.instantiateViewController(withIdentifier: "toProfileEdit")
            //ここが実際に移動するコードとなります
            self.present(multiple, animated: false, completion: nil)
        }
        if (indexPath.row == 4) {
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let multiple = storyboard.instantiateViewController(withIdentifier: "pointChange")
            //ここが実際に移動するコードとなります
            self.present(multiple, animated: false, completion: nil)
        }

        if (indexPath.row == 5) {
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let multiple = storyboard.instantiateViewController(withIdentifier: "toNotice")
            //ここが実際に移動するコードとなります
            self.present(multiple, animated: false, completion: nil)
        }
        if (indexPath.row == 7) {
            let storyboard: UIStoryboard = self.storyboard!
            let multiple = storyboard.instantiateViewController(withIdentifier: "toSettingEdit")
            self.present(multiple, animated: false, completion: nil)
        }
        if (indexPath.row == 9) {
            let storyboard: UIStoryboard = self.storyboard!
            let multiple = storyboard.instantiateViewController(withIdentifier: "toPointHistory")
            self.present(multiple, animated: false, completion: nil)
        }
        if (indexPath.row == 10) {
            let storyboard: UIStoryboard = self.storyboard!
            let multiple = storyboard.instantiateViewController(withIdentifier: "toMyData")
            self.present(multiple, animated: false, completion: nil)
        }
        if (indexPath.row == 8) {
            let alertController:UIAlertController =
                UIAlertController(title:"退会する",message: "本当に退会しますか？",preferredStyle: .alert)
            // Default のaction
            let defaultAction:UIAlertAction =
                UIAlertAction(title: "退会する",style: .destructive,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                    print("退会する")
                    self.pushAction()
                })
            
            // Cancel のaction
            let cancelAction:UIAlertAction =
                UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                    print("キャンセル")
                })
            
            // actionを追加
            alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            
            // UIAlertControllerの起動
            present(alertController, animated: true, completion: nil)
            
        }
        // SubViewController へ遷移するために Segue を呼び出す
            //performSegue(withIdentifier: "toSubViewController",sender: nil)
    }
    
    
    
    func pushAction() {
        let uiAlertControl = UIAlertController(title: "Photo", message: "Photo of the Day", preferredStyle: .alert)
        let uiImageAlertAction = UIAlertAction(title: "", style: .default, handler: nil)
        let image = UIImage(named: "alert")
    uiImageAlertAction.setValue(image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")

        uiAlertControl.addAction(uiImageAlertAction)
        // Cancel のaction
        let cancelAction:UIAlertAction =
            UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                print("キャンセル")
                self.pushAction_1()
            })
        // actionを追加
        uiAlertControl.addAction(cancelAction)

        let height:NSLayoutConstraint = NSLayoutConstraint(item: uiAlertControl.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 480)
        uiAlertControl.view.addConstraint(height)
        self.present(uiAlertControl, animated: true, completion: nil)
    }
    func pushAction_1() {
        let uiAlertControl = UIAlertController(title: "Photo", message: "Photo of the Day", preferredStyle: .alert)
        let uiImageAlertAction = UIAlertAction(title: "", style: .default, handler: nil)
        let image = UIImage(named: "alert")
        uiImageAlertAction.setValue(image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
        
        uiAlertControl.addAction(uiImageAlertAction)
        // Cancel のaction
        let cancelAction:UIAlertAction =
            UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                print("キャンセル")
            })
        // actionを追加
        uiAlertControl.addAction(cancelAction)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: uiAlertControl.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 480)
        uiAlertControl.view.addConstraint(height)
        self.present(uiAlertControl, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func toMyDeataStep(_ sender: Any) {
        
        
    }
    
    @IBAction func backFromPlaninputView(segue:UIStoryboardSegue){
        NSLog("PlaninputViewController#backFromPlaninputView")
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

public extension String {
    public func labelHeight(width: CGFloat,
        font: UIFont,
        lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGSize {
            let size = CGSize(width: width, height: .greatestFiniteMagnitude)
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = lineBreakMode
            return (self as NSString).boundingRect(
            with: size, options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font, .paragraphStyle: style], context: nil).size
    }
}



extension MyDataViewController : MyDataModelDelegate {
    
    func onStart(model: MyDataModel) {
        print("こちら/UserDetail/UserDetailViewのonStart")
    }
    func onComplete(model: MyDataModel, count: Int) {
        print("UserDetail着てきてきてきて")
        //更新用データを設定
        self.dataSource = model.responseData;
        self.dataSourceOrder = model.responseDataOrder;
        
        print(self.dataSourceOrder)
        print("UserDetail耳耳耳意味耳みm")

        
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

        
        self.returnView()
        Menu.reloadData()


    }
    func onFailed(model: MyDataModel) {
        print("こちら/MultipleModel/UserDetailViewのonFailed")
    }
}


