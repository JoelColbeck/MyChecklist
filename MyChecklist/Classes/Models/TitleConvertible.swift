//
//  TitleConvertible.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 11.06.2022.
//

import Foundation

protocol TitleConvertible {
    var title: String { get }
}

typealias RadioEnum = CaseIterable & TitleConvertible & Equatable

extension ProstateCancerDetails: TitleConvertible {
    var title: String {
        switch self {
        case .morethan1: return "Более, чем у одного в молодом возрасте"
        case .under65: return "У отца или брата до 65 лет"
        case .over65: return "У близкого родственника после 65 лет"
        }
    }
}

extension StomachCancerDetails: TitleConvertible {
    var title: String {
        switch self {
        case .morethan3: return "Три или более случаев в семье"
        case .under40: return "Один случай у близкого родственника до 40 лет"
        case .under50: return "Два случая у близких родственников до 50 лет"
        case .complex: return "Рак желудка и молочной железы у родственников до 50 лет"
        }
    }
}

extension ColonCancerDetails: TitleConvertible {
    var title: String {
        switch self {
        case .lessthan60: return "У одного близкого родственника до 60 лет"
        case .over60: return "У близкого родственника после 60 лет"
        case .manyRelatives: return "У нескольких родственников"
        case .manyCousins: return "У нескольких двоюродных родственников"
        }
    }
}
