//
//  ConstraintActivator.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.03.2023.
//

import UIKit

@resultBuilder
struct ConstraintActivator {
    static func buildBlock(_ components: NSLayoutConstraint?...) {
        NSLayoutConstraint.activate(components.compactMap(identity))
    }
}
