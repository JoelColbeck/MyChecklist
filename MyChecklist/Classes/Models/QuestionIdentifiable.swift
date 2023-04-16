//
//  QuestionIdentifiable.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 15.04.2023.
//

import Foundation

protocol QuestionIdentifiable {
    var id: String { get }
}

extension AdditionalQuestions: QuestionIdentifiable {
    var id: String { rawValue }
}

extension Chronic: QuestionIdentifiable {
    var id: String { rawValue }
}

extension FamilyDiseases: QuestionIdentifiable {
    var id: String { rawValue }
}

extension RelativeOncology: QuestionIdentifiable {
    var id: String { rawValue }
}
