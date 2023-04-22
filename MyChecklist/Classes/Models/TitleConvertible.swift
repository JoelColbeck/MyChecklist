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

extension AdditionalQuestions: TitleConvertible {
    var title: String {
        switch self {
        case .highCholesterol:
            return "Мой холестерин повышен"
        case .hasDiabetes:
            return "У меня диабет"
        case .brokeBone:
            return "У меня был перелом"
        }
    }
}

extension Alcohol: TitleConvertible {
    var title: String {
        switch self {
        case .heavyDrinker:
            return "Пью чаще одного раза в неделю"
        case .lightDrinker:
            return "Пью реже одного раза в неделюл"
        case .noDrinker:
            return "Не пью"
        }
    }
}

extension BloodPressure: TitleConvertible {
    var title: String {
        switch self {
        case .low:
            return "Низкое"
        case .normal:
            return "Нормальное"
        case .high:
            return "Высокое"
        }
    }
}

extension Chronic: TitleConvertible {
    var title: String {
        switch self {
        case .chronicStomach:
            return "Хроническая болезнь желудка"
        case .hiv:
            return "У меня ВИЧ"
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

extension FamilyDiseases: TitleConvertible {
    var title: String {
        switch self {
        case .infarct:
            return "Инфаркт"
        case .stroke:
            return "Инсульт"
        case .relativeHipBroke:
            return "Перелом шейки бедра"
        case .diabetes:
            return "Диабет"
        }
    }
}

extension Gender: TitleConvertible {
    var title: String {
        switch self {
        case .man:
            return "Мужской"
        case .woman:
            return "Женский"
        }
    }
}

extension ProstateCancerDetails: TitleConvertible {
    var title: String {
        switch self {
        case .morethan1: return "Более, чем у одного в молодом возрасте"
        case .under65: return "У отца или брата до 65 лет"
        case .over65: return "У близкого родственника после 65 лет"
        }
    }
}

extension RelativeOncology: TitleConvertible {
    var title: String {
        switch self {
        case .prostateCancer:
            return "Рак простаты"
        case .colonCancer:
            return "Рак прямой кишки"
        case .stomachCancer:
            return "Рак желудка"
        }
    }
}

extension Smoke: TitleConvertible {
    var title: String {
        switch self {
        case .smokingNow:
            return "Курю сейчас"
        case .quitSmoking:
            return "Бросил курить"
        case .noSmoking:
            return "Не курю"
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

// MARK: Foundation
extension Bool: TitleConvertible {
    var title: String {
        return self ? "Да" : "Нет"
    }
}
