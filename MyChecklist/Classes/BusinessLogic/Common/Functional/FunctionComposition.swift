//
//  FunctionComposition.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.03.2023.
//

import Foundation

infix operator ∘

func ∘<T, U, V>(lhs: @escaping (U) -> V, rhs: @escaping (T) -> U) -> (T) -> V {
    func result(_ arg: T) -> V {
        lhs(rhs(arg))
    }
    return result
}
