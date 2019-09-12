//
//  ViewController.swift
//  matchness
//
//  Created by user on 2019/02/05.
//  Copyright © 2019年 a2c. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tabItem = self.tabBarController?.tabBar.items?[0] {
            tabItem.badgeValue = "new"
        }


        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    
    
}

