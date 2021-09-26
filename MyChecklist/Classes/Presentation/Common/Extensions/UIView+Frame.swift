//
//  UIView+Frame.swift
//  mercury-ios
//
//  Created by Данил Коротаев on 05.07.2021.
//  Copyright © 2021 Trinity Monsters. All rights reserved.
//

import UIKit

extension UIView {
    func setSize(width: CGFloat, height: CGFloat) {
        let size = CGSize(width: width, height: height)
        self.setSize(size)
    }
    
    func setSize(_ size: CGSize) {
        self.frame = CGRect(origin: self.frame.origin, size: size)
    }
    
    func setSize(_ size: CGFloat) {
        let size = CGSize(width: size, height: size)
        self.setSize(size)
    }
    
    func setSize(_ sizeView: UIView) {
        self.setSize(sizeView.frame.size)
    }
    
    func setSize(to bounds: CGRect) {
        self.setSize(bounds.size)
        self.bounds = bounds
    }
}
