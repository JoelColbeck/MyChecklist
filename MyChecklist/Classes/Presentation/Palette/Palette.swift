//
//  Palette.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 28.02.2023.
//

import UIKit

// Alpha in color is always 1. Should use withAlphaComponent in code
enum Palette {
    static let currentYearNavbar = UIColor(hex: "C4EF4A")!
    static let futureYearNavbar = UIColor(hex: "ABE2E5")!
    static let checklistsNavbar = UIColor(hex: "D9D9D9")!
}

extension UIColor {
    convenience init?(hex: String) {
        let red, green, blue: CGFloat
        
        let start: String.Index
        
        // Defining first index
        if hex.hasPrefix("#") {
            start = hex.index(hex.startIndex, offsetBy: 1)
        } else {
            start = hex.startIndex
        }
        
        // Getting hex string
        let hexColor = String(hex[start...])
        guard hexColor.count == 6 else { return nil }
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        // Convert to hex number
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        
        // Read rgb
        red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        blue = CGFloat(hexNumber & 0x0000ff) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
