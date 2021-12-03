//
//  BodyMetricsCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 28.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class BodyMetricsCell: BaseCollectionViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var ageView: IncrementView! {
        didSet {
            let ageViewModel = IncrementViewModel(
                title: "Возраст",
                startValue: 18,
                step: 1,
                maxValue: 80,
                minValue: 18
            )
            
            ageView.viewModel = ageViewModel
        }
    }
    
    @IBOutlet private weak var heightView: IncrementView! {
        didSet {
            let heightViewModel = IncrementViewModel(
                title: "Рост",
                startValue: 170,
                step: 5,
                maxValue: 220,
                minValue: 0
            )
            
            heightView.viewModel = heightViewModel
        }
    }
    
    @IBOutlet private weak var weightView: IncrementView! {
        didSet {
            let weightViewModel = IncrementViewModel(
                title: "Вес",
                startValue: 70,
                step: 5,
                maxValue: 200,
                minValue: 0
            )
            
            weightView.viewModel = weightViewModel
        }
    }
    
    // MARK: - Public Properties
    var ageValue: Observable<Int> {
        ageView.value
            .compactMap { Int($0) }
    }
    
    var heightValue: Observable<Int> {
        heightView.value
            .compactMap { Int($0) }
    }
    
    var weightValue: Observable<Int> {
        weightView.value
            .compactMap { Int($0) }
    }
}
