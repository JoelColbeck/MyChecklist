//
//  Sequence+sideEffect.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 09.07.2022.
//

import Foundation

extension Sequence {
    func onSide(_ block: (Element) throws -> ()) rethrows -> Self {
        try forEach(block)
        return self
    }
}
