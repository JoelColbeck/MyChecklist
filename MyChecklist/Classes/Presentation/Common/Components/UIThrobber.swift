//
//  UIThrobber.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import Lottie
import RxCocoa
import RxSwift
import UIKit

class UIThrobber: UIView {
    // MARK: - Private propertiesV
    private let throbberSize: CGFloat = 100
    private let throbberView: AnimationView
    private let container: UIView
    private let backgroundEffectView: UIView
    
    // MARK: - Public properties
    var isActive: Bool = false {
        didSet {
            processState(isActive)
        }
    }
    
    override var frame: CGRect {
        get {
            super.frame
        }
        set {
            super.frame = newValue
            throbberView.center = center
        }
    }
    
    // MARK: - Initializer
    init(container: UIView?, isBlurredBackground: Bool = true) {
        self.container = container == nil ? UIApplication.shared.windows[0] : container!
        let effect = UIBlurEffect(style: .dark)
        backgroundEffectView = UIVisualEffectView(effect: effect)
        throbberView = AnimationView(name: "loader")
        throbberView.contentMode = .scaleAspectFill
        throbberView.loopMode = .loop
        throbberView.setSize(throbberSize)
        
        super.init(frame: self.container.bounds)
        addSubview(backgroundEffectView)
        addSubview(throbberView)
        throbberView.center = self.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func processState(_ isActive: Bool) {
        if isActive {
            throbberView.play()
            container.addSubview(self)
            self.frame = container.bounds
            backgroundEffectView.frame = self.bounds
            UIView.animate(withDuration: 0.2) {
                self.throbberView.alpha = 0.6
                self.backgroundEffectView.alpha = 1
            }
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.throbberView.alpha = 0
            self.backgroundEffectView.alpha = 0
        }, completion: { _ in
            if !isActive {
                self.removeFromSuperview()
            }
        })
    }
}

// MARK: - Rx
extension Reactive where Base: UIThrobber {
    var isActive: Binder<Bool> {
        return Binder(self.base) { throbber, isActive in
            throbber.isActive = isActive
        }
    }
}

