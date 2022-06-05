//
//  PartialApply.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 29.05.2022.
//

import Foundation

func partialApply<T, U, V, R>(_ block: @escaping (T, U, V) -> R, p1: T) -> (U, V) -> R {
    func forward(p2: U, p3: V) -> R {
        block(p1, p2, p3)
    }
    return forward(p2:p3:)
}
