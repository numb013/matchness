//
//  CustomTabBar.swift
//  matchness
//
//  Created by 中村篤史 on 2019/12/15.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
class CustomTabBar: UITabBar {

    var height_bar:Int = 0

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)


        switch (UIScreen.main.nativeBounds.height) {
        case 480:
            // iPhone
            // iPhone 3G
            // iPhone 3GS
            height_bar = 100
            print("heigh_1")
            break
        case 960:
            // iPhone 4
            // iPhone 4S
            print("heigh_2")
            break
        case 1136:
            // iPhone 5
            // iPhone 5s
            // iPhone 5c
            // iPhone SE
            print("heigh_3")
            height_bar = 50
            break
        case 1334:
            // iPhone 6
            // iPhone 6s
            // iPhone 7
            // iPhone 8
            print("heigh_4")
            height_bar = 80
            break
        case 2208:
            // iPhone 6 Plus
            // iPhone 6s Plus
            // iPhone 7 Plus
            // iPhone 8 Plus
            print("heigh_5")
            height_bar = 60
            break
        case 2436:
            //iPhone X
            print("heigh_6")
            height_bar = 90
            break
        case 1792:
            //iPhone XR
            print("heigh_7")
            height_bar = 80
            break
        case 2688:
            //iPhone XR
            print("heigh_7")
            height_bar = 80
            break
        default:
            print("heigh_8")
            break
        }

print("height_barheight_barheight_barheight_bar")
print(UIScreen.main.nativeBounds.height)
print(height_bar)

        sizeThatFits.height = CGFloat(height_bar)
        return sizeThatFits;
    }
}
