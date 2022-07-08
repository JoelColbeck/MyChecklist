//
//  Weakify.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 05.06.2022.
//

import Foundation

func weakify<T: AnyObject>(
    _ target: T,
    in action: @escaping (T) -> () -> Void
) -> () -> Void {
    { [weak target] in
        if let target = target {
            action(target)()
        }
    }
}

func weakify<T: AnyObject, U>(
    _ target: T,
    in action: @escaping (T) -> (U) -> Void
) -> (U) -> Void {
    { [weak target] t1 in
        if let target = target {
            action(target)(t1)
        }
    }
}

func weakify<T: AnyObject, T1, T2>(
    _ target: T,
    in action: @escaping (T) -> (T1, T2) -> Void
) -> (T1, T2) -> Void {
    { [weak target] t1, t2 in
        if let target = target {
           return action(target)(t1, t2)
        }
    }
}


func werakify<T: AnyObject, R>(
    _ target: T,
    in action: @escaping (T) -> () -> R,
    fallbackAction: @escaping () -> R
) -> () -> R {
    { [weak target] in
        if let target = target {
            return action(target)()
        } else {
            return fallbackAction()
        }
    }
}

func weakify<T: AnyObject, T1, T2, R>(
    _ target: T,
    in action: @escaping (T) -> (T1, T2) -> R,
    fallbackAction: @escaping (T1, T2) -> R
) -> (T1, T2) -> R {
    { [weak target] t1, t2 in
        if let target = target {
           return action(target)(t1, t2)
        } else {
            return fallbackAction(t1, t2)
        }
    }
}
