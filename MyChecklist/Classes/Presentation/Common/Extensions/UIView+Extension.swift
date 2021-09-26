import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor  else {
                return .clear
            }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor {
        get {
            guard let cgColor = layer.shadowColor  else {
                return .clear
            }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    var shadowPath: CGPath? {
        get {
            layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
    
    func pin(to view: UIView, isFront: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if isFront {
            view.insertSubview(self, at: 0)
        } else {
            view.addSubview(self)
        }
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func pinToCenter(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @discardableResult
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    
    func hide() {
        isHidden = true        
    }
    
    func reveal() {
        isHidden = false
    }
    
    func setRotation(_ angle: CGFloat) {
        var angle = angle
        if angle < 0 {
            angle = 360 - angle
        }
        self.transform = CGAffineTransform(rotationAngle: angle * CGFloat(Double.pi) / 180)
    }
    
    func setBottomMaskedCorners() {
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func setTopMaskedCorners() {
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setAllMaskedCorners() {
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func clearMaskedCorners() {
        self.layer.maskedCorners = []
    }
    
    func configureShadowSeparator(withOpacity opacity: Float) {
        let rect = CGRect(
            origin: CGPoint(x: 0,
                            y: frame.height),
            size: CGSize(width: frame.width,
                         height: 0.5)
        )
        let shadowPath = UIBezierPath(rect: rect).cgPath
        
        shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.shadowPath = shadowPath
        shadowOffset = CGSize(width: 0, height: 0.5)
        shadowOpacity = opacity
        shadowRadius = 0
    }
}
