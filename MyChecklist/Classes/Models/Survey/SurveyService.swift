//
//  SurveyService.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 02.04.2023.
//

import Foundation

import RxSwift
import RxRelay

protocol Questionable {
    static var surveyQuestion: SurveyQuestion { get }
}

final class CommonSurveyService {
    func writeAnswer(_ answer: String?, questionId: String) {
        answers[questionId] = answer
        
        if let bmi = calculateBMI() {
            answers["bmi"] = String(bmi)
        }
    }
    
    private func makeQuestions() -> [SurveyQuestion] {
        var questions: [SurveyQuestion] = []
        questions.append(Gender.surveyQuestion)
        guard answers[Gender.surveyQuestion.id] != nil else { return questions }

        questions.append(
            contentsOf: [
                ageQuestion,
                weightQuestion,
                heightQuestion,
            ]
        )

        let models: [Questionable.Type] = [
            Smoke.self,
            Alcohol.self,
            BloodPressure.self,
            AdditionalQuestions.self,
            FamilyDiseases.self,
            Chronic.self,
            RelativeOncology.self
        ]

        models
            .map { $0.surveyQuestion }
            .forEach { questions.append($0) }

        if answers.checkBool(for: RelativeOncology.prostateCancer.id) {
            questions.append(ProstateCancerDetails.surveyQuestion)
        }

        if answers.checkBool(for: RelativeOncology.colonCancer.id) {
            questions.append(ColonCancerDetails.surveyQuestion)
        }

        if answers.checkBool(for: RelativeOncology.stomachCancer.id) {
            questions.append(StomachCancerDetails.surveyQuestion)
        }

        return questions
    }

    private func calculateBMI() -> Double? {
        guard let weight = Double(answers["weight"] ?? ""),
              let height = Double(answers["height"] ?? "") else {
            return nil
        }
        return weight / pow(height / 100, 2)
    }

    private let questionsRelay = PublishRelay<[SurveyQuestion]>()
    private var answers: [String: String] = [:]
}

fileprivate extension Dictionary where Key == String, Value == String {
    func checkBool(for key: String) -> Bool {
        guard let answer = self[key] else { return false }
        return Bool(answer) == true
    }
}

// MARK: - Question instances

private let ageQuestion: SurveyQuestion = .init(id: "age", questionType: .input(InputQuestion(title: "Возраст")))
private let weightQuestion: SurveyQuestion = .init(id: "weight", questionType: .input(InputQuestion(title: "Вес")))
private let heightQuestion: SurveyQuestion = .init(id: "height", questionType: .input(InputQuestion(title: "Рост")))

extension AdditionalQuestions: Questionable {
    static var surveyQuestion: SurveyQuestion {
        SurveyQuestion(
            id: "additionalQuestions",
            questionType: .checkboxesCollection(
                CheckboxesCollectionQuestion(
                    title: "Дополнительные вопросы",
                    model: allCases
                )
            )
        )
    }
}

extension Alcohol: Questionable {
    static var surveyQuestion: SurveyQuestion {
        SurveyQuestion(
            id: "alcohol",
            questionType: .radio(
                RadioQuestion(
                    title: "Отношение к алкоголю",
                    possibleAnswers: Alcohol.allCases
                )
            )
        )
    }
}

extension BloodPressure: Questionable {
    static var surveyQuestion: SurveyQuestion {
        SurveyQuestion(
            id: "bloodPressure",
            questionType: .radio(
                RadioQuestion(
                    title: "Давление",
                    possibleAnswers: BloodPressure.allCases
                )
            )
        )
    }
}

extension Chronic: Questionable {
    static var surveyQuestion: SurveyQuestion {
        SurveyQuestion(
            id: "chronic",
            questionType: .checkboxesCollection(
                CheckboxesCollectionQuestion(
                    title: "Хронические заболевания",
                    model: allCases
                )
            )
        )
    }
}

extension FamilyDiseases: Questionable {
    static var surveyQuestion: SurveyQuestion {
        SurveyQuestion(
            id: "family",
            questionType: .checkboxesCollection(
                CheckboxesCollectionQuestion(
                    title: "Семейные недуги",
                    checkboxes: FamilyDiseases
                        .allCases.map(CheckboxesCollectionQuestion.Item.init)
                )
            )
        )
    }
}

extension Gender: Questionable {
  static var surveyQuestion: SurveyQuestion {
    SurveyQuestion(
        id: "gender",
        questionType: .radio(
            RadioQuestion(
                title: "Пол",
                possibleAnswers: Gender.allCases
            )
        )
    )
  }
}

extension RelativeOncology: Questionable {
    static var surveyQuestion: SurveyQuestion {
        SurveyQuestion(
            id: "relativeOncology",
            questionType: .checkboxesCollection(
                CheckboxesCollectionQuestion(
                    title: "Онкология у близких родственников",
                    model: allCases
                )
            )
        )
    }
}

extension Smoke: Questionable {
    static var surveyQuestion: SurveyQuestion {
        SurveyQuestion(
            id: "smoke",
            questionType: .radio(
                RadioQuestion(
                    title: "Отношение к курению",
                    possibleAnswers: allCases
                )
            )
        )
    }
}

// MARK: Oncology

extension ColonCancerDetails: Questionable {
    static var surveyQuestion: SurveyQuestion {
        SurveyQuestion(
            id: "colonCancerDetails",
            questionType: .radio(
                RadioQuestion(
                    title: questionTitle,
                    possibleAnswers: allCases
                )
            )
        )
    }
    
    private static var questionTitle: String {
        "Дополнительная информация про случаи рака прямой кишки у близких"
    }
}

extension ProstateCancerDetails: Questionable {
    static var surveyQuestion: SurveyQuestion {
        SurveyQuestion(
            id: "prostateCancerDetails",
            questionType: .radio(
                RadioQuestion(
                    title: "Дополнительная информация про случаи рака простаты у близких",
                    possibleAnswers: allCases
                )
            )
        )
    }
}

extension StomachCancerDetails: Questionable {
    static var surveyQuestion: SurveyQuestion {
        SurveyQuestion(
            id: "stomachCancerDetails",
            questionType: .radio(
                RadioQuestion(
                    title: "Дополнительная информация про случаи рака простаты у близких",
                    possibleAnswers: allCases
                )
            )
        )
    }
}
