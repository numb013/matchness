import UIKit

class CustomPresentationController: UIPresentationController {
  // 表示されるモーダル
  var modalView = UIView()
  let margin = (x: CGFloat(30), y: CGFloat(220.0))
    
  // 表示トランジション開始前に呼ばれる
  override func presentationTransitionWillBegin() {
    guard let containerView = containerView else {
      return
    }
    
    self.modalView.frame = containerView.bounds

    let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(self.modalViewTouched(_:))
    )

    self.modalView.addGestureRecognizer(tapGesture)
    self.modalView.backgroundColor = .black
    self.modalView.alpha = 0.0
        
    containerView.addSubview(self.modalView)
        
    // トランジションを実行
    presentedViewController.transitionCoordinator?.animate(
        alongsideTransition: { (context) in
            self.modalView.alpha = 0.7
        },
        completion: nil
    )
  }
    
  // 非表示トランジション開始前
  override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator?.animate(
      alongsideTransition: { (context) in
        self.modalView.alpha = 0.0
      },
      completion: nil
    )
  }
    
  // 非表示トランジション開始後
  override func dismissalTransitionDidEnd(_ completed: Bool) {
    if completed {
      self.modalView.removeFromSuperview()
    }
  }
    
  // モーダルのサイズを返す。
  override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
    // parentSizeに呼び出し元のviewControllerのサイズが入ってる。
    return CGSize(width: parentSize.width - margin.x, height: parentSize.height - margin.y)
  }

  // モーダルの場所設定
  override var frameOfPresentedViewInContainerView: CGRect {
    var presentedViewFrame = CGRect()
    let containerBounds = containerView!.bounds
    let childContentSize = size(
      forChildContentContainer: presentedViewController,
      withParentContainerSize: containerBounds.size
    )
    presentedViewFrame.size = childContentSize
    presentedViewFrame.origin.x = margin.x / 2.0
    presentedViewFrame.origin.y = margin.y / 2.0

    return presentedViewFrame
  }

  // レイアウト開始前に呼ばれる
  override func containerViewWillLayoutSubviews() {
    self.modalView.frame = containerView!.bounds
    presentedView?.frame = frameOfPresentedViewInContainerView
    presentedView?.layer.cornerRadius = 10
    presentedView?.clipsToBounds = true
  }
    
  // モーダルを消す処理。
  @objc func modalViewTouched(_ sender: UITapGestureRecognizer) {
    presentedViewController.dismiss(animated: true, completion: nil)
  }
}
