//
//  ImageDescriptor .swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 01.03.2023.
//

import UIKit

enum ImageDescriptor: String {
    case checklistIcon
    case iconCheckboxEmpty
    case iconCheckboxSelected
}

enum ImageSystemDescriptor: String {
    case surveyBackButton = "chevron.backward"
}

extension UIImage {
    convenience init?(descriptor: ImageDescriptor) {
        self.init(named: descriptor.rawValue)
    }
    
    convenience init?(systemDescriptor: ImageSystemDescriptor) {
        self.init(systemName: systemDescriptor.rawValue)
    }
}
