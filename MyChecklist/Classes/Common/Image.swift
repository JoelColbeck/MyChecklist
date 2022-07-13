//
//  Image.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 30.06.2022.
//

import UIKit

enum Image: String {
    case radioEmpty
    case radioFilled
    case systemArrowLeft = "arrow.left"
    case systemArrowRight = "arrow.right"
    
    var image: UIImage? {
        UIImage(named: rawValue) ?? UIImage(systemName: rawValue)
    }
}
