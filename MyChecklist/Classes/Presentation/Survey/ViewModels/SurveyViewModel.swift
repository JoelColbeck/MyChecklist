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
    let genderInput = BehaviorRelay<Gender?>(value: nil)
    let ageInput = PublishRelay<Int>()
    let heightInput = PublishRelay<Int>()
    let weightInput = PublishRelay<Int>()
    let smokeInput = PublishRelay<Smoke?>()
    let alcoholInput = PublishRelay<Alcohol?>()
    let bloodPressureInput = PublishRelay<BloodPressure?>()
    let highCholesterolInput = PublishRelay<Bool>()
    let diabetesInput = PublishRelay<Bool>()
    let brokenBonesInput = PublishRelay<Bool>()
    let familyHeartAttackInput = PublishRelay<Bool>()
    let familyStrokeInput = PublishRelay<Bool>()
    let familyHipFractureInput = PublishRelay<Bool>()
    let familyDiabetesInput = PublishRelay<Bool>()
    let chronicLungsInput = PublishRelay<Bool>()
    let chronicCardioInput = PublishRelay<Bool>()
    let chronicLiverInput = PublishRelay<Bool>()
    let chronicStomachInput = PublishRelay<Bool>()
    let chronicKidneysInput = PublishRelay<Bool>()
    let chronicHivInput = PublishRelay<Bool>()
    let relativeProstateInput = PublishRelay<Bool>()
    let relativeCervicalInput = PublishRelay<Bool>()
    let relativeColonInput = PublishRelay<Bool>()
    let relativeStomachInput = PublishRelay<Bool>()
    let relativeLungsInput = PublishRelay<Bool>()
    let relativeMelanomaInput = PublishRelay<Bool>()
    
    
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
        
        let gender = genderInput.do(
            onNext: { [weak self] gender in
                switch gender {
                case .man: self?.relativeProstateInput.accept(false)
                case .woman: self?.relativeCervicalInput.accept(false)
                case .none: break
                }
            }
        ).share()
        
        gender
            .compactMap { [weak self] _ in self?.generateSnapshot() }
            .bind(to: snapshotPublisher)
            .disposed(by: bag)
        
        subscribeSurvey(observable: gender, keyPath: \.gender)
        subscribeSurvey(observable: ageInput, keyPath: \.age)
        subscribeSurvey(observable: heightInput, keyPath: \.height)
        subscribeSurvey(observable: weightInput, keyPath: \.weight)
        subscribeSurvey(observable: smokeInput, keyPath: \.smoke)
        subscribeSurvey(observable: alcoholInput, keyPath: \.alcohol)
        subscribeSurvey(observable: bloodPressureInput, keyPath: \.bloodPressure)
        subscribeSurvey(observable: highCholesterolInput, keyPath: \.hasHighCholesterol)
        subscribeSurvey(observable: diabetesInput, keyPath: \.hasDiabetes)
        subscribeSurvey(observable: brokenBonesInput, keyPath: \.hasBrokenBone)
        subscribeSurvey(observable: familyHeartAttackInput, keyPath: \.hasFamilyInfarct)
        subscribeSurvey(observable: familyStrokeInput, keyPath: \.hasFamilyInsult)
        subscribeSurvey(observable: familyHipFractureInput, keyPath: \.hasFamilyRelativeHipBroke)
        subscribeSurvey(observable: familyDiabetesInput, keyPath: \.hasFamilyDiabetis)
        subscribeSurvey(observable: chronicLungsInput, keyPath: \.hasChronicLungs)
        subscribeSurvey(observable: chronicCardioInput, keyPath: \.hasChronicHeart)
        subscribeSurvey(observable: chronicLiverInput, keyPath: \.hasChronicLiver)
        subscribeSurvey(observable: chronicStomachInput, keyPath: \.hasChronicStomach)
        subscribeSurvey(observable: chronicKidneysInput, keyPath: \.hasChronicKidneys)
        subscribeSurvey(observable: chronicHivInput, keyPath: \.hasHiv)
        subscribeSurvey(observable: relativeProstateInput, keyPath: \.hasProstateCancer)
        subscribeSurvey(observable: relativeCervicalInput, keyPath: \.hasCervicalCancerWoman)
        subscribeGenderSurvey(
            observable: relativeColonInput,
            manKeyPath: \.hasColonCancerMan,
            womanKeyPath: \.hasColonCancerWoman
        )
        subscribeGenderSurvey(
            observable: relativeStomachInput,
            manKeyPath: \.hasStomachCancerMan,
            womanKeyPath: \.hasStomachCancerWoman
        )
        
        subscribeGenderSurvey(
            observable: relativeLungsInput,
            manKeyPath: \.hasLungsCancerMan,
            womanKeyPath: \.hasLungsCancerWoman
        )
        subscribeGenderSurvey(
            observable: relativeMelanomaInput,
            manKeyPath: \.hasMelanomaMan,
            womanKeyPath: \.hasMelanomaWoman
        )
    }
    
    // MARK: - Private Methods
    private func subscribeSurvey<T: ObservableType>(
        observable: T,
        keyPath: WritableKeyPath<Survey, T.Element>
    ) {
        observable
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .map { value, survey in
                var survey = survey
                survey[keyPath: keyPath] = value
                return survey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
    }
    
    private func subscribeGenderSurvey<T: ObservableType>(
        observable: T,
        manKeyPath: WritableKeyPath<Survey, T.Element>,
        womanKeyPath: WritableKeyPath<Survey, T.Element>
    ) {
        observable
            .withLatestFrom(surveyRelay) { ($0, $1) }
            .withLatestFrom(genderInput) { ($0.0, $0.1, $1) }
            .map { value, survey, gender in
                var survey = survey
                switch gender {
                case .man: survey[keyPath: manKeyPath] = value
                case .woman: survey[keyPath: womanKeyPath] = value
                case .none: break
                }
                return survey
            }
            .bind(to: surveyRelay)
            .disposed(by: bag)
    }
}

private extension SurveyViewModel {
    func generateSnapshot() -> SurveySnapshot {
        var snapshot = SurveySnapshot()
        
        var items: [SurveyItemModel] = [
            .gender,
        ]
        
        if let gender = genderInput.value {
            items.append(contentsOf: [
                .bodyMetrics,
                .smokeAlcohol,
                .bloodPressure,
                .additionalQuestions,
                .familyDiseases,
                .chronicDiseases,
                .relativeOncology(gender: gender),
            ])
        }
        
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
    case familyDiseases
    case chronicDiseases
    case relativeOncology(gender: Gender)
}
