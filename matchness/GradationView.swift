import UIKit
@IBDesignable
class GradationView: UIView {
    

    var gradientLayer: CAGradientLayer?
    
    @IBInspectable var topColor: UIColor = UIColor.white {
        didSet {
            setGradation()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.black {
        didSet {
            setGradation()
        }
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private func setGradation() {
        guard let gradientLayer = self.layer as? CAGradientLayer else {
            return
        }

//        gradientLayer.removeFromSuperlayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
//        gradientLayer.frame.size = frame.size
//        layer.addSublayer(gradientLayer)
//        layer.masksToBounds = true
    }
}
