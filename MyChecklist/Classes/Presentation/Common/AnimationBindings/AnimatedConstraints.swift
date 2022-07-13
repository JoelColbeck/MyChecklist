//
//  AnimatedConstraints.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 10.07.2022.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: NSLayoutConstraint {
    var animatedConstant: Binder<CGFloat> {
        Binder(self.base) { constraint, value in
            guard
                let view = constraint.firstItem as? UIView,
                let superview = view.superview
            else { return }
            
            constraint.constant = value
            
            UIView.animate(withDuration: 0.5) {
                superview.layoutIfNeeded()
            }
        }
    }
}
