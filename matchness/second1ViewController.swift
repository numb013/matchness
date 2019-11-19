import UIKit

class second1ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {


    @IBOutlet weak var namePickerview: UIPickerView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var bottom: NSLayoutConstraint!

    var dataList = ["森永アイス　ラムネバー　ソーダ味","森永アイス　ラムネバー　白桃ソーダ味",
                "赤城乳業ミント","森永Pinoバニラ","森永Pinoアーモンド","森永Pinoチョコ"]
    override func viewDidLoad() {
        super.viewDidLoad()


        namePickerview.dataSource = self
        namePickerview.delegate = self
    }

    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
     
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {

        return dataList[row]
    }
     
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        // 処理
    }
    
    @IBAction func push(_ sender: Any) {
        PickerPush()
    }
    
        func PickerPush(){
            print("ピッカーーーーーーーー")
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.5,animations: {
    //            self.datePickerView.date = self.setDay
                self.bottom.constant = -280
                self.namePickerview.updateConstraints()
                //self.profileAddTableView.updateConstraints()
                self.view.layoutIfNeeded()
            })
        }
    
    
    
}
