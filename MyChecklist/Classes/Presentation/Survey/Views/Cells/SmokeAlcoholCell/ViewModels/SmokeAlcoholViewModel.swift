//
//  SmokeAlcoholViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 03.12.2021.
//

import Foundation
import RxSwift
import RxRelay

final class SmokeAlcoholViewModel: BaseViewModel {
    // MARK: - Inputs
    let selectedSmokeRow = PublishRelay<Int>()
    let selectedAlcoholRow = PublishRelay<Int>()
    
    // MARK: - Outputs
    var selectedSmoke: Observable<Smoke?> {
        selectedSmokeRow
            .map { Smoke.allCases[safe: $0 - 1] }
    }
    
    var selectedAlcohol: Observable<Alcohol?> {
        selectedAlcoholRow
            .map { Alcohol.allCases[safe: $0 - 1] }
    }
    
    // MARK: - Public Properties
    var smokeNumberOfRows: Int {
        Smoke.allCases.count + 1
    }
    
    var alcoholNumberOfRows: Int {
        Alcohol.allCases.count + 1
    }
    
    // MARK: - Public Methods
    func smokeTitle(forRow row: Int) -> String? {
        guard let smoke = Smoke.allCases[safe: row - 1] else { return nil }
        switch smoke {
        case .smokingNow:
            return "Курю сейчас"
        case .quitSmoking:
            return "Бросил курить"
        case .noSmoking:
            return "Не курю"
        }
    }
    
    func alcoholTitle(forRow row: Int) -> String? {
        guard let alcohol = Alcohol.allCases[safe: row - 1] else { return nil }
        switch alcohol {
        case .heavyDrinker:
            return "Чаще раза в неделю"
        case .lightDrinker:
            return "Реже одного раза в неделю"
        case .noDrinker:
            return "Не пью"
        }
    }
}
