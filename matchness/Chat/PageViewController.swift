import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([getFirst()], direction: .reverse, animated: true, completion: nil)
        //　最初のviewControllerを設定している
        
        self.dataSource = self
    }

    func getFirst() -> CahtFirstViewController {
        return storyboard!.instantiateViewController(withIdentifier: "CahtFirstViewController") as! CahtFirstViewController
    }
    
    func getSecond() -> CahtSecondViewController {
        return storyboard!.instantiateViewController(withIdentifier: "CahtSecondViewController") as! CahtSecondViewController
    }
    
//    func getThird() -> ThirdViewController {
//        return storyboard!.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 左に進む動き（前に戻る）
        
        if viewController.isKind(of: CahtSecondViewController.self) {// 現在のviewControllerがCahtSecondViewControllerかどうか調べる
            // 2 -> 1
            return getFirst()
            
        } else {
            // 1 -> end of the road
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        // 右に進む（先に進む）
        
        if viewController.isKind(of: CahtFirstViewController.self)//　現在のviewControllerがCahtFirstViewControllerかどうか調べる
        {
            // 1 -> 2
            return getSecond()
            
        } else {
            // 3 -> end of the road
            return nil
        }
    }
}
