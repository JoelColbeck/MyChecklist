//
//  ImageDescriptor .swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 01.03.2023.
//

import UIKit

enum ImageDescriptor: String {
    case checklistIcon
}

extension UIImage {
    convenience init?(descriptor: ImageDescriptor) {
        self.init(named: descriptor.rawValue)
    }
}
