//
//  ChatViewController.swift
//  matchness
//
//  Created by user on 2019/06/04.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ChatViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //バーの色
        settings.style.buttonBarBackgroundColor = UIColor.black
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = UIColor.black
        //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor.white
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor(red: 254/255, green: 0, blue: 124/255, alpha: 1)

        super.viewDidLoad()

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First")
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Second")
        let childViewControllers:[UIViewController] = [firstVC, secondVC]
        return childViewControllers
    }
}
