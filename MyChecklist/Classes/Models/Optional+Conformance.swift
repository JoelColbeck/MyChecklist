//
//  Optional+Conformance.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.07.2022.
//

import Foundation

extension Optional: TitleConvertible where Wrapped: TitleConvertible {
    var title: String {
        switch self {
        case let .some(value): return value.title
        case .none: return "Затрудняюсь ответить"
        }
    }
}

extension Optional: CaseIterable where Wrapped: CaseIterable {
    public static var allCases: [Self] {
        var result: [Wrapped?] = [nil]
        result.append(contentsOf: Wrapped.allCases as! [Wrapped?])
        return result
    }
}
