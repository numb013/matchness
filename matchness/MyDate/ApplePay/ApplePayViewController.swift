//
//  ApplePayViewController.swift
//  matchness
//
//  Created by 中村篤史 on 2019/12/05.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import PassKit
import Stripe

class ApplePayViewController: UIViewController {

    let applePayButton: PKPaymentButton = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
    let applePaySetButton: PKPaymentButton = PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .black)
    var paymentSucceeded = false
    let networks = PKPaymentRequest.availableNetworks()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        if PKPaymentAuthorizationViewController.canMakePayments() {
            print("111")
        } else {
            print("222")
        }

        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: networks) {
            // 利用可能な決済ネットワークが 1 つ以上ある場合 (クレジットカードが登録済みの場合)
            applePayButton.isEnabled = Stripe.deviceSupportsApplePay()
            // Do any additional setup after loading the view.
            applePayButton.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
            applePayButton.center = self.view.center
            applePayButton.addTarget(self, action: #selector(ApplePayViewController.handleApplePayButtonTapped), for: .touchUpInside)
            view.addSubview(applePayButton)
            print("AAAAA")
        } else {
            // 利用可能な決済ネットワークがない場合
            applePaySetButton.isEnabled = Stripe.deviceSupportsApplePay()
            // Do any additional setup after loading the view.
            applePaySetButton.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
            applePaySetButton.center = self.view.center
            applePaySetButton.addTarget(self, action: #selector(ApplePayViewController.setUp), for: .touchUpInside)
            view.addSubview(applePaySetButton)
            print("BBBB")
        }
    }

    @objc func setUp(sender: AnyObject) {
        print("MMMMMMM")
        PKPassLibrary().openPaymentSetup()
    }
    
    @objc func handleApplePayButtonTapped() {
        print("AAAAAAAA")
        let merchantIdentifier = "com.a2c.popokatsu"
        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "JP", currency: "JPY")

        // Configure the line items on the payment request
//        paymentRequest.paymentSummaryItems = [
//            PKPaymentSummaryItem(label: "Fancy Hat", amount: 50.00),
//            // The final line should represent your company;
//            // it'll be prepended with the word "Pay" (i.e. "Pay iHats, Inc $50")
//            PKPaymentSummaryItem(label: "iHats, Inc", amount: 50.00),
//        ]


        // サポートする決済ネットワークを指定
        paymentRequest.supportedNetworks = PKPaymentRequest.availableNetworks()
        // サポートするプロトコルを指定
        paymentRequest.merchantCapabilities = .capability3DS // capability3DS は必須
        paymentRequest.paymentSummaryItems = [
            // 商品の金額、送料、割引額、合計の 3 つを表示する場合
            PKPaymentSummaryItem(label: "商品の金額", amount: NSDecimalNumber(string: "1000")),
            PKPaymentSummaryItem(label: "送料", amount: NSDecimalNumber(string: "100")),
            PKPaymentSummaryItem(label: "割引額", amount: NSDecimalNumber(string: "100")),
            PKPaymentSummaryItem(label: "MyMerchant", amount: NSDecimalNumber(string: "1000")) // 合計額
        ]
        if Stripe.canSubmitPaymentRequest(paymentRequest),
            let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
            paymentAuthorizationViewController.delegate = self as! PKPaymentAuthorizationViewControllerDelegate
            present(paymentAuthorizationViewController, animated: true)
        } else {
            // There is a problem with your Apple Pay configuration
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


//extension ApplePayViewController: PKPaymentAuthorizationViewControllerDelegate, STPAuthenticationContext {
//    func authenticationPresentingViewController() -> UIViewController {
//        return self
//    }
//
//    @available(iOS 11.0, *)
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        // Convert the PKPayment into a PaymentMethod
//        STPAPIClient.shared().createPaymentMethod(with: payment) { (paymentMethod: STPPaymentMethod?, error: Error?) in
//            guard let paymentMethod = paymentMethod, error == nil else {
//                // Present error to customer...
//                return
//            }
//            let paymentMethodID = paymentMethod.stripeId
//            // Send the PaymentMethod ID to your server and create a PaymentIntent
//        }
//    }
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        // Dismiss payment authorization view controller
//        dismiss(animated: true, completion: {
//            if (self.paymentSucceeded) {
//                print("BBBBB")
//                // Show a receipt page...
//            } else {
//                print("CCCCC")
//
//                // Present error to customer...
//            }
//        })
//    }
//}

//
//extension ApplePayViewController: PKPaymentAuthorizationViewControllerDelegate, STPAuthenticationContext {
//    func authenticationPresentingViewController() -> UIViewController {
//        return self
//    }
//
//    @available(iOS 11.0, *)
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        // Convert the PKPayment into a PaymentMethod
//        STPAPIClient.shared().createPaymentMethod(with: payment) { (paymentMethod: STPPaymentMethod?, error: Error?) in
//            guard let paymentMethod = paymentMethod, error == nil else {
//                // Present error to customer...
//                return
//            }
//            let clientSecret = "client secret of the PaymentIntent created at the beginning of the checkout flow"
//            let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
//            paymentIntentParams.paymentMethodId = paymentMethod.stripeId
//
//            // Confirm the PaymentIntent with the payment method
//            STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
//                switch (status) {
//                case .succeeded:
//                    // Save payment success
//                    self.paymentSucceeded = true
//                    handler(PKPaymentAuthorizationResult(status: .success, errors: nil))
//                case .canceled:
//                    handler(PKPaymentAuthorizationResult(status: .failure, errors: nil))
//                case .failed:
//                    // Save/handle error
//                    let errors = [STPAPIClient.pkPaymentError(forStripeError: error)].compactMap({ $0 })
//                    handler(PKPaymentAuthorizationResult(status: .failure, errors: errors))
//                @unknown default:
//                    handler(PKPaymentAuthorizationResult(status: .failure, errors: nil))
//                }
//            }
//        }
//    }
//
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        // Dismiss payment authorization view controller
//        dismiss(animated: true, completion: {
//            if (self.paymentSucceeded) {
//                // Show a receipt page...
//            } else {
//                // Present error to customer...
//            }
//        })
//    }
//}


extension ApplePayViewController: PKPaymentAuthorizationViewControllerDelegate {

    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("DDDDDD")
        // Convert the PKPayment into a Token
        STPAPIClient.shared().createToken(with: payment) { token, error in
              guard let token = token else {
                  // Handle the error
                  return
              }
            let tokenID = token.tokenId
            // Send the token identifier to your server to create a Charge...
            // If the server responds successfully, set self.paymentSucceeded to YES
        }
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // Dismiss payment authorization view controller
        dismiss(animated: true, completion: {
            if (self.paymentSucceeded) {
                print("BBBBB")
                // Show a receipt page...
            } else {
                print("CCCCC")

                // Present error to customer...
            }
        })
    }
}
