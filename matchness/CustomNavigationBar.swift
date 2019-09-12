//
//  CustomNavigationBar.swift
//  matchness
//
//  Created by user on 2019/06/08.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        super.frame = CGRect(x: 0, y: 0, width: super.frame.size.width, height: 100)
    }

}
