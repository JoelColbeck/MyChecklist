//
//  UIScrollView+Extensions.swift
//  mercury-ios
//
//  Created by Данил Коротаев on 07.07.2021.
//  Copyright © 2021 Trinity Monsters. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToTop(animated: Bool) {
        let offset = CGPoint(x: 0, y: self.contentInset.top)
        self.setContentOffset(offset, animated: true)
    }
    
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height + self.contentInset.bottom < self.bounds.size.height { return }
        let yOffset = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom
        let bottomOffset = CGPoint(x: 0, y: yOffset)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
