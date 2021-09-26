//
//  Differ.swift
//  mercury-ios
//
//  Created by Данил Коротаев on 05.07.2021.
//  Copyright © 2021 Trinity Monsters. All rights reserved.
//

import Foundation
import CoreGraphics

private let epsilon: CGFloat = 0.001

protocol Differable {
    func differ(_ other: Self) -> Bool
}

extension CGPoint: Differable {
    func differ(_ other: CGPoint) -> Bool {
        self.x.differ(other.x) || self.y.differ(other.y)
    }
}

extension CGSize: Differable {
    func differ(_ other: CGSize) -> Bool {
        self.height.differ(self.height) || self.width.differ(self.width)
    }
}

extension CGRect: Differable {
    func differ(_ other: CGRect) -> Bool {
        self.origin.differ(other.origin) || self.size.differ(other.size)
    }
}

extension CGFloat: Differable {
    func differ(_ other: CGFloat) -> Bool {
        let result = self.isEqual(to: other, eps: epsilon)
        return result
    }
}

func differ<T: Differable>(_ left: T, _ right: T) -> Bool {
    left.differ(right)
}
