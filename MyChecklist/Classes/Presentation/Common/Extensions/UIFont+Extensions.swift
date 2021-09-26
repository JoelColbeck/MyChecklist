//
//  UIFont+Extensions.swift
//  nespresso-academy-ios
//
//  Created by Ekaterina on 23.11.2018.
//  Copyright © 2018 TRINITY Digital. All rights reserved.
//

import UIKit

extension UIFont {
    static func gilroySemibold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Semibold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func gilroyBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
