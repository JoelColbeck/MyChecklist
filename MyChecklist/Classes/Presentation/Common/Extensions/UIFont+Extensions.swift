//
//  UIFont+Extensions.swift
//  nespresso-academy-ios
//
//  Created by Ekaterina on 23.11.2018.
//  Copyright © 2018 TRINITY Digital. All rights reserved.
//

import UIKit

extension UIFont {
    static func regularFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SBSansUI-Regular", size: fontSize) ??
            UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    
    static func lightFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SBSansUI-Light", size: fontSize) ??
            UIFont.systemFont(ofSize: fontSize, weight: .light)
    }
    
    static func semiboldFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SBSansUI-SemiBold", size: fontSize) ??
            UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    
    static func boldFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SBSansUI-Bold", size: fontSize) ??
            UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    static func capsFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SBSansUI-Caps", size: fontSize) ??
            UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
}
