//
//  Group1ViewController.swift
//  matchness
//
//  Created by user on 2019/06/02.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import PagingMenuController

class GroupViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // PagingMenuController追加
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        // 高さ調整。この2行を追加
        pagingMenuController.view.frame.origin.y += navBarHeight! + statusBarHeight
        pagingMenuController.view.frame.size.height -= navBarHeight! + statusBarHeight
        
        self.addChild(pagingMenuController)
        self.view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParent: self)

        if let tabBarItem = self.tabBarController?.tabBar.items?[1] as? UITabBarItem {
            tabBarItem.badgeValue = nil
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func toGroupEventAddButton(_ sender: Any) {
            let alertController:UIAlertController =
                UIAlertController(title:"グループを作成",message: "グループを作成するには保有ポイントが150pt必要です",preferredStyle: .alert)
            // Default のaction
            let defaultAction:UIAlertAction =
                UIAlertAction(title: "ポイント変換ページへ",style: .destructive,handler:{
                    (action:UIAlertAction!) -> Void in
                    // 処理
                    print("ポイント変換ページへ")
                    let storyboard: UIStoryboard = self.storyboard!
                    //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                    let multiple = storyboard.instantiateViewController(withIdentifier: "pointChange")
                    multiple.modalPresentationStyle = .fullScreen
                    //ここが実際に移動するコードとなります
                    self.present(multiple, animated: false, completion: nil)
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

        var point = Int.random(in: 120 ... 200)

        if (point < 150) {
            // UIAlertControllerの起動
            present(alertController, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "toAddGroupEvent", sender: nil)
        }
    }

    @IBAction func backFromGroupView(segue:UIStoryboardSegue){
        NSLog("GroupViewController#backFromGroupEventAddView")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    let pv1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WaitGroup") as! WaitGroupViewController
    let pv2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JoinGroup") as! JoinGroupViewController
    let pv3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EndGroup") as! EndGroupViewController
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [pv1, pv2, pv3]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .infinite(widthMode: .flexible, scrollingMode: .scrollEnabled)
        }
        var height: CGFloat {
            return 45
        }
        var backgroundColor: UIColor {
            return UIColor.black
        }
        var selectedBackgroundColor: UIColor {
            return UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0)
        }
        var focusMode: MenuFocusMode {
            return .roundRect(radius: 1, horizontalPadding: 1, verticalPadding: 1, selectedColor: UIColor(red: 0.1, green: 0.7, blue: 0.7, alpha: 0.7))
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(), MenuItem3()]
        }
    }

    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "募集中       ", color: UIColor.white, selectedColor: UIColor.white))
        }
    }
    
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "参加中        ", color: UIColor.white, selectedColor: UIColor.white))
        }
    }
    
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "参加済       ", color: UIColor.white, selectedColor: UIColor.white))
        }
    }
    
}
