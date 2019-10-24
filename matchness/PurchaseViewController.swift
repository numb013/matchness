//
//  PurchaseViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/10/24.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

 
class PurchaseViewController:UIViewController, STPPaymentMethodsViewControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func purchase(_ sender: UIButton) {
        handlePaymentMethods()
    }
    func handlePaymentMethods() {
        let customerContext = STPCustomerContext(keyProvider: StripeKeyProvider())

        let paymentMethodsViewController = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: customerContext, delegate: self)

        let navigationController = UINavigationController(rootViewController: paymentMethodsViewController)
        present(navigationController, animated: true)
    }

    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        dismiss(animated: true)
        // なんらかのエラーがおきた時の処理
    }

    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        dismiss(animated: true)
        //'Cancel'が押された時の処理
    }

    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController){
        dismiss(animated: true)
        //なんらかの決済手段が選ばれた時の処理
    }

    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {
        if let selectedCard = paymentMethod as? STPCard {
            let cardId = selectedCard.cardId
        }
    }
    

}
