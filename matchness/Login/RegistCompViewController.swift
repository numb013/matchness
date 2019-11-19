//
//  RegistCompViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/02.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class RegistCompViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startTopButton(_ sender: Any) {

        //画面遷移
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let multiple = storyboard.instantiateViewController(withIdentifier: "Tutorial")
        multiple.modalPresentationStyle = .fullScreen
        //ここが実際に移動するコードとなります
        self.present(multiple, animated: true, completion: nil)
        
        
//        self.performSegue(withIdentifier: "toStartTop", sender: nil)

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
