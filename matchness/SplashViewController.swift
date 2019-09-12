import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("スプラッシュビュー")
        var imageName: String = ""
        
        // シミュレーター iPhone 8, iPhone7, iPhone6s, iPhone 6
        // iPhone Portrait iOS 8+
        // Retina HD 4.7"
        if (UIScreen.main.bounds.width == 375 && UIScreen.main.bounds.height == 667) {
            imageName = "876s6.png"
            
            
            
            // シミュレーター iPhone 8 Plus, iPhone 7 Plus, iPhone6s Plus, iPhone 6 Plus
            // iPhone Portrait iOS 8+
            // Retina HD 5.5"
        } else if (UIScreen.main.bounds.width == 414 && UIScreen.main.bounds.height == 736) {
            imageName = "8Plus7Plus6sPlus6Plus.png"
            
            
            
            // シミュレーター iPhone SE, iPhone 5s
            // iPhone Portrait iOS 7+
            // Retina 4
        } else if (UIScreen.main.bounds.width == 320 && UIScreen.main.bounds.height == 568) {
            imageName = "SE5s.png"
            
            
            
            
            // シミュレーター iPhone Xs, iPhone X
            // Portrait iOS 11+
            // iPhone X / iPhone Xs
        } else if (UIScreen.main.bounds.width == 375 && UIScreen.main.bounds.height == 812) {
            imageName = "XXs.png"
            
            
            
            // シミュレーター iPhone Xs Max
            // Portrait iOS 12+
            // iPhone Xs Max
        } else if (UIScreen.main.bounds.width == 414 && UIScreen.main.bounds.height == 896 && UIScreen.main.scale == 3) {
            imageName = "XsMax.png"
            
            
            
            // シミュレーター iPhone XR
            // Portrait iOS 12+
            // iPhone XR
        } else if (UIScreen.main.bounds.width == 414 && self.view.bounds.height == 896 && UIScreen.main.scale == 2) {
            imageName = "XR.png"
            
            
            
        }
        
        let backGroundImage = UIImage(named: "BackGround" + imageName)
        // backGroundImage!.size.widthとしなかったのは
        // Assets.xcassetsに格納している画像ではないとポイントではなくピクセルが返ってくるため
        let backGroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        backGroundImageView.image = backGroundImage
        backGroundImageView.layer.position = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        self.view.addSubview(backGroundImageView)
        
        let fujitaSplashImage = UIImage(named: "Splash" + imageName)
        let fujitaSplashImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        fujitaSplashImageView.image = fujitaSplashImage
        fujitaSplashImageView.layer.position = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        self.view.addSubview(fujitaSplashImageView)
        
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseOut, animations: { () -> Void in
            fujitaSplashImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { (Bool) -> Void in
        })
        // {(パラメータ) -> (返り値型) in (処理)}
        
        UIView.animate(withDuration: 0.2, delay: 1.3, options: .curveEaseOut, animations: { () -> Void in
            fujitaSplashImageView.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
        }, completion: { (Bool) -> Void in
            fujitaSplashImageView.removeFromSuperview()
            self.present(UserSearchViewController(), animated: false, completion: nil)
        })
        // {(パラメータ) -> (返り値型) in (処理)}
    }
    
}
