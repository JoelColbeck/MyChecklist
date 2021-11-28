//
//  Array+Extensions.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 28.11.2021.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index < self.count,
              index >= 0
        else { return nil }
        return self[index]
    }
}
