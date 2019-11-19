//
//  TutorialViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/11/12.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import EAIntroView

class TutorialViewController: UIViewController, EAIntroDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let page1 = EAIntroPage()
        page1.title = "はじめまして！"
        page1.desc = "インストールありがとうございます！"
        page1.bgImage = UIImage(named: "1")
        
        let page2 = EAIntroPage()
        page2.title = "おすろてっく"
        page2.desc = "月1~2のペースで勉強会を開いています。"
        page2.bgImage = UIImage(named: "2")

        let page3 = EAIntroPage()
        page3.title = "ブログもよろしく！"
        page3.desc = "真面目な記事が多いけどそろそろネタ記事書いてくれる人いないかな･･･"
        page3.bgImage = UIImage(named: "3")
        page3.titleFont = UIFont(name: "Helvetica-Bold", size: 32)
        page3.titleColor = UIColor.orange
        page3.descPositionY = self.view.bounds.size.height/2

        let introView = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3])
        introView?.skipButton.setTitle("スキップ", for: UIControl.State.normal) //スキップボタン欲しいならここで実装！
        // タップされたときのaction
        introView?.skipButton.addTarget(self,
                action: #selector(TutorialViewController.buttonTapped(sender:)),
                for: .touchUpInside)

        introView?.delegate = self
        introView?.show(in: self.view, animateDuration: 1.0)
    }

    @objc func buttonTapped(sender : AnyObject) {
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let multiple = storyboard.instantiateViewController(withIdentifier: "start")
        multiple.modalPresentationStyle = .fullScreen
        //ここが実際に移動するコードとなります
        self.present(multiple, animated: true, completion: nil)
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
