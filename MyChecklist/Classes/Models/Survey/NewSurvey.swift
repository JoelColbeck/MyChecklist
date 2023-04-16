//
//  NewSurvey.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 02.04.2023.
//

import Foundation

struct SurveyQuestion: Hashable {
    var id: String
    var questionType: QuestionType

    init(id: String, questionType: QuestionType) {
        self.id = id
        self.questionType = questionType
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SurveyQuestion, rhs: SurveyQuestion) -> Bool {
        lhs.id == rhs.id
    }
    
}

enum QuestionType {
    case input(InputQuestion)
    case checkbox(CheckboxQuestion)
    case checkboxesCollection(CheckboxesCollectionQuestion)
    case radio(RadioQuestion)
}

struct InputQuestion {
    var title: String
}

struct CheckboxQuestion {
    var title: String
    var possibleAnswers: [TitleConvertible]
}

struct CheckboxesCollectionQuestion {
    var title: String
    var checkboxes: [Item]
    
    struct Item {
        var id: String
        var title: String
    }
}

extension CheckboxesCollectionQuestion {
    init(title: String, model: [QuestionIdentifiable & TitleConvertible]) {
        self.title = title
        checkboxes = model.map(Item.init)
    }
}

extension CheckboxesCollectionQuestion.Item {
    init(_ model: QuestionIdentifiable & TitleConvertible) {
        id = model.title
        title = model.title
    }
}

struct RadioQuestion {
    var title: String
    var description: String?
    var possibleAnswers: [TitleConvertible]
}

/*
 Непонятно, как стандартизировать вопросы-чекбоксы. Они могут иметь собственные айдишники, а могут относиться к одному айдшинику.
 В первом кейсе это отдельные вопросы с ответами true/false, но выглядит это как костыль. Во втором кейсе — это один вопрос с несколькими возможными вариантами ответов.
 Нужно как-то объединить это под один какой-то протокол, чтобы система легко масштабировалась.
 */
