//
//  SurveyViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 14.11.2021.
//

import RxSwift
import RxRelay

final class SurveyViewModel: BaseViewModel {
    // MARK: - Outputs
    var snapshotOutput: Observable<SurveySnapshot> {
        snapshotPublisher
            .compactMap { $0 }
    }
    
    var numberOfQuestionsOutput: Observable<Int> {
        numberOfQuestionsPublisher
            .asObservable()
    }
    
    // MARK: - Inputs
    let genderInput = PublishRelay<Gender?>()
    let ageInput = PublishRelay<Int>()
    let heightInput = PublishRelay<Int>()
    let weightInput = PublishRelay<Int>()
    let smokeInput = PublishRelay<Smoke?>()
    let alcoholInput = PublishRelay<Alcohol?>()
    let bloodPressureInput = PublishRelay<BloodPressure?>()
    let highCholesterolInput = PublishRelay<Bool>()
    let diabetesInput = PublishRelay<Bool>()
    let brokenBonesInput = PublishRelay<Bool>()
    
    let closed = PublishRelay<Void>()
    
    // MARK: - Private Properties
    private let snapshotPublisher = BehaviorRelay<SurveySnapshot?>(value: nil)
    private let numberOfQuestionsPublisher = BehaviorRelay<Int>(value: 0)
    
    private let surveyRelay = BehaviorRelay<Survey>(value: Survey())
    
    // MARK: - Public Methods
    override func initialize() {
        super.initialize()
        snapshotPublisher.accept(generateSnapshot())
    }
    
    override func applyBinding() {
        super.applyBinding()
        
        surveyRelay
            .debug("SurveyRelay", trimOutput: false)
            .subscribe()
            .disposed(by: bag)
        
        genderInput
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { newGender, survey in
                var newSurvey = survey
                newSurvey.gender = newGender
                return newSurvey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
        
        ageInput
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { newAge, survey in
                var newSurvey = survey
                newSurvey.age = newAge
                return newSurvey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
        
        heightInput
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { newHeight, survey in
                var newSurvey = survey
                newSurvey.height = newHeight
                return newSurvey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
        
        weightInput
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { newWeight, survey in
                var newSurvey = survey
                newSurvey.weight = newWeight
                return newSurvey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
        
        smokeInput
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { newSmoke, survey in
                var newSurvey = survey
                newSurvey.smoke = newSmoke
                return newSurvey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
        
        alcoholInput
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { newAlcohol, survey in
                var newSurvey = survey
                newSurvey.alcohol = newAlcohol
                return newSurvey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
        
        bloodPressureInput
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { newBloodPressure, survey in
                var newSurvey = survey
                newSurvey.bloodPressure = newBloodPressure
                return newSurvey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
        
        highCholesterolInput
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { newValue, survey in
                var newSurvey = survey
                newSurvey.hasHighCholesterol = newValue
                return newSurvey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
        
        diabetesInput
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { newValue, survey in
                var newSurvey = survey
                newSurvey.hasDiabetes = newValue
                return newSurvey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
        
        brokenBonesInput
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { newValue, survey in
                var newSurvey = survey
                newSurvey.hasBrokenBone = newValue
                return newSurvey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
    }
}

private extension SurveyViewModel {
    func generateSnapshot() -> SurveySnapshot {
        var snapshot = SurveySnapshot()
        
        let items = [
            SurveyItemModel.gender,
            SurveyItemModel.bodyMetrics,
            SurveyItemModel.smokeAlcohol,
            SurveyItemModel.bloodPressure,
            SurveyItemModel.additionalQuestions
        ]
        
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        
        numberOfQuestionsPublisher.accept(items.count)
        
        return snapshot
    }
}

enum SurveyItemModel: Hashable {
    case gender
    case bodyMetrics
    case smokeAlcohol
    case bloodPressure
    case additionalQuestions
}
