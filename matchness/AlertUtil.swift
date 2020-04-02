import Foundation
import UIKit

class Alert: UIAlertController {
    class func error(alertNum : Dictionary<String, ApiErrorAlert>, viewController: UIViewController) {
//        var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
//        alert = UIAlertController(title: "タイトル", message: "エラー出ませんように", preferredStyle: .alert)
//        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel) {
//            action in print("Pushed CANCEL!")
//        }
//        alert.addAction(actionCancel)
//        // 引数で渡されてきたViewControllerに対してメソッドを実行します。
//        viewController.present(alert, animated: true, completion: nil)

        let alertController:UIAlertController =
            UIAlertController(title:"ポイントが不足しています",message: "ポイント変換が必要です", preferredStyle: .alert)
        // Default のaction
        let defaultAction:UIAlertAction =
            UIAlertAction(title: "ポイント変換ページへ",style: .destructive,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                print("ポイント変換ページへ")
                let storyboard: UIStoryboard = viewController.storyboard!
                //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                let multiple = storyboard.instantiateViewController(withIdentifier: "pointChange")
                multiple.modalPresentationStyle = .fullScreen
                //ここが実際に移動するコードとなります
                viewController.present(multiple, animated: false, completion: nil)
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
        viewController.present(alertController, animated: true, completion: nil)
    }

    class func common(alertNum : Dictionary<String, ApiErrorAlert>, viewController: UIViewController) {
        let alert = UIAlertController(title: alertNum["0"]?.title, message: alertNum["0"]?.message, preferredStyle: .alert)
        viewController.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        })
    }

    class func helthError(alertNum : Dictionary<String, ApiErrorAlert>, viewController: UIViewController) {

print("アラーーーーーーーーーーーーーー")
        
        
//        var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
//        alert = UIAlertController(title: "タイトル", message: "エラー出ませんように", preferredStyle: .alert)
//        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel) {
//            action in print("Pushed CANCEL!")
//        }
//        alert.addAction(actionCancel)
//        // 引数で渡されてきたViewControllerに対してメソッドを実行します。
//        viewController.present(alert, animated: true, completion: nil)

        let alertController:UIAlertController =
            UIAlertController(title:"データが取得できません",message: "設定アプリを起動し、「プライバシー」→「ヘルスケア」→「POPOKATSU」と選択し、全ての項目をオンにして下さい", preferredStyle: .alert)
        // Cancel のaction
        let cancelAction:UIAlertAction =
            UIAlertAction(title: "閉じる",style: .cancel,handler:{
                (action:UIAlertAction!) -> Void in
                // 処理
                print("キャンセル")
            })
        // actionを追加
        alertController.addAction(cancelAction)
        // UIAlertControllerの起動
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
    
}
