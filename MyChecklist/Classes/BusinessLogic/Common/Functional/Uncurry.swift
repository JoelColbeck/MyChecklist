//
//  Uncurry.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 29.05.2022.
//

import Foundation

func uncurry<T, V>(
    _ block: @escaping (T) -> () -> (V)
) -> (T) -> (V) {
    func forward(p: T) -> V {
        block(p)()
    }
    
    return forward(p:)
}
