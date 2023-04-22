//
//  SurveyViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 22.04.2023.
//

import Foundation

import RxRelay
import RxSwift

final class SurveyViewModel {
    var snapshot: Observable<SurveyDataSource.Snapshot> {
        snapshotProvider.asObservable()
    }
    
    init(surveyService: SurveyService) {
        self.surveyService = surveyService

        surveyService.questions
            .compactMap { [weak self] in self?.generateSnapshot(questions: $0) }
            .bind(to: snapshotProvider)
            .disposed(by: bag)
    }
    
    private func generateSnapshot(questions: [SurveyQuestion]) -> SurveyDataSource.Snapshot {
        var snapshot = SurveyDataSource.Snapshot()
        
        snapshot.appendSections([0])
        snapshot.appendItems(questions, toSection: 0)
        
        return snapshot
    }
    
    private let snapshotProvider = BehaviorRelay(value: SurveyDataSource.Snapshot())
    private let surveyService: SurveyService
    private let bag = DisposeBag()
}
