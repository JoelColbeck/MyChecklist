//
//  Optional.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 22.04.2023.
//

import Foundation

extension Optional {
    func forEach(_ block: (Wrapped) -> Void) {
        switch self {
        case .none:
            return
        case .some(let wrapped):
            block(wrapped)
        }
    }
}
