//
//  ChecklistViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation
import RxRelay
import RxSwift

class ChecklistViewModel: BaseViewModel {
    // MARK: - Public Properties
    let closed = PublishRelay<Void>()
    
    // MARK: - Private Properties
    private let testService = TestService.shared
    private let checklistPublisher = PublishRelay<[ChecklistYearModel]>()
    
    // MARK: - Initializers
    init(user: User) {
        super.init()
        checklistPublisher.accept(getChecklistFrom(user: user))
    }
    
    // MARK: - Public Methods
    override func applyBinding() {
//        checklistPublisher
//            .map { }
    }
    
    // MARK: - Public Methods
    private func getChecklistFrom(user: User) -> [ChecklistYearModel] {
        let userModel = UserModel(fromUser: user)
        
        guard
            let ageString = userModel.info["age"] as? String,
            let age = Int(ageString),
            let creationYear = Int(userModel.createdAt.prefix(4))
        else { return [] }
        
        
        let arrayOfYears = user.tests
            .flatMap { test -> [Int] in
                test.years
            }
            .unique()
            .sorted(by: <)
        
        let result = arrayOfYears.map { year -> ChecklistYearModel in
            let anchors: [ChecklistAnchorModel]
            anchors = userModel.tests.reduce([]) { partialResult, test in
                guard
                    test.years.contains(year),
                    let anchor = testService.testAnchors[test.testAnchor]
                else { return partialResult }
                var copy = partialResult
                copy.append(.init(title: anchor.testName, category: anchor.category, importance: anchor.importance))
                return copy
            }
            
            return .init(age: String(age + (year - creationYear)),
                         year: String(year),
                         anchors: anchors)
        }
        
        return result
    }
}
