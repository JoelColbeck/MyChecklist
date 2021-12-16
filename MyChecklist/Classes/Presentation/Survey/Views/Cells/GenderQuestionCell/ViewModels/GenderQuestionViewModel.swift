//
//  GenderQuestionViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 04.12.2021.
//

import Foundation
import RxSwift
import RxRelay

final class GenderQuestionViewModel: BaseViewModel {
    // MARK: - Inputs
    let selectedGenderInput = PublishRelay<Int>()
    
    // MARK: - Outputs
    var genderOutput: Observable<Gender?> {
        selectedGenderInput
            .map { Gender.allCases[safe: $0 - 1] }
    }
    
    // MARK: - Public Properties
    var numberOfRows: Int {
        Gender.allCases.count + 1
    }
    
    // MARK: - Public Methods
    func genderTitle(forRow row: Int) -> String? {
        guard let gender = Gender.allCases[safe: row - 1] else { return "Не выбран" }
        
        switch gender {
        case .man: return "Мужской"
        case .woman: return "Женский"
        }
    }
}
