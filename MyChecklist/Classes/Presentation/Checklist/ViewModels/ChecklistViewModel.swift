//
//  ChecklistViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation
import RxRelay
import RxSwift
import RxDataSources

final class ChecklistViewModel: BaseViewModel {
    // MARK: - Public Properties
    let closed = PublishRelay<Void>()
    let sections = BehaviorRelay<[SectionModel]>(value: [])
    
    // MARK: - Private Properties
    private let testService = TestService.shared
    private var checklistPublisher = BehaviorRelay<[ChecklistYearModel]>(value: [])
    
    // MARK: - Initializers
    init(user: User) {
        super.init()
        checklistPublisher.accept(getChecklistFrom(user: user))
    }
    
    // MARK: - Public Methods
    override func applyBinding() {
        checklistPublisher
            .map { checklistYears in
                var sections: [SectionModel] = []
                let items: [ItemModel] = checklistYears
                    .map { model in
                        return .year(model: model)
                    }
                
                sections.append(.tests(items: items))
                
                return sections
            }
            .bind(to: sections)
            .disposed(by: bag)
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
        
        let result = arrayOfYears
            .map { year -> ChecklistYearModel in
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
                
                let declinatedAge = (age + (year - creationYear)).declination(nominativeSingular: "год", nominativePlural: "года", genitivePlural: "лет")
                
                return .init(age: declinatedAge,
                             year: String(year),
                             anchors: anchors)
            }
            .sorted(by: { $0.year < $1.year })
        
        return result
    }
}

extension ChecklistViewModel {
    enum SectionModel: AnimatableSectionModelType, IdentifiableType {
        case tests(items: [Item])
        
        typealias Identity = String
        var identity: String {
            switch self {
            case .tests:
                return "tests"
            }
        }
        
        typealias Item = ItemModel
        var items: [Item] {
            switch self {
            case .tests(let items):
                return items
            }
        }
        
        init(original: ChecklistViewModel.SectionModel, items: [ChecklistViewModel.ItemModel]) {
            switch original {
            case .tests:
                self = .tests(items: items)
            }
        }
    }
    
    enum ItemModel: Equatable, IdentifiableType {
        case year(model: ChecklistYearModel)
        
        var identity: String {
            switch self {
            case .year(let model):
                return model.anchors.map { $0.title }.joined() + model.year
            }
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.identity == rhs.identity
        }
    }
}
