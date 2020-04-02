//
//  WebViewViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2020/03/06.
//  Copyright © 2020 a2c. All rights reserved.
//
import UIKit
import WebKit

class WebViewViewController: UIViewController {

    
    @IBOutlet weak var webview: WKWebView!
    
    var webType = String();
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8470588235)

        
print("webTypewebTypewebTypewebTypewebType")
print(webType)
        
        switch (webType) {
        case "11":
            if let url = URL(string: "http://fdu24.shop") {
              self.webview.load(URLRequest(url: url))
            }
            break
        case "12":
            if let url = URL(string: ApiConfig.SITE_BASE_URL + "/terms") {
              self.webview.load(URLRequest(url: url))
            }
            break
        case "11":
            if let url = URL(string: ApiConfig.SITE_BASE_URL + "/terms") {
              self.webview.load(URLRequest(url: url))
            }
            break
        case "11":
            if let url = URL(string: ApiConfig.SITE_BASE_URL + "/terms") {
              self.webview.load(URLRequest(url: url))
            }
            break
        case "11":
            if let url = URL(string: ApiConfig.SITE_BASE_URL + "/terms") {
              self.webview.load(URLRequest(url: url))
            }
            break
        case "11":
            if let url = URL(string: ApiConfig.SITE_BASE_URL + "/terms") {
              self.webview.load(URLRequest(url: url))
            }
            break
        default:
            print("heigh_8")
            break
        }
        




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
