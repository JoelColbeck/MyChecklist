//
//  BloodPressureViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 04.12.2021.
//

import Foundation
import RxSwift
import RxRelay

final class BloodPressureViewModel: BaseViewModel {
    // MARK: - Inputs
    let bloodPressureInput = PublishRelay<Int>()
    
    // MARK: - Outputs
    var bloodPressureOutput: Observable<BloodPressure?> {
        bloodPressureInput
            .map { BloodPressure.allCases[safe: $0 - 1] }
    }
    
    // MARK: - Public Properties
    var numberOfRows: Int {
        BloodPressure.allCases.count + 1
    }
    
    func bloodPressureTitle(forRow row: Int) -> String {
        guard let bloodPressure = BloodPressure.allCases[safe: row - 1] else {
            return "Затрудняюсь ответить"
        }
        
        switch bloodPressure {
        case .high: return "Высокое"
        case .normal: return "В норме"
        case .low: return "Низкое"
        }
    }
}
