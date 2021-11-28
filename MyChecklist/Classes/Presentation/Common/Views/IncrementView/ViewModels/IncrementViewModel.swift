//
//  IncrementViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 14.11.2021.
//

import RxSwift
import RxRelay

final class IncrementViewModel: BaseViewModel {
    // MARK: - Public Properties
    let titlePublisher: BehaviorRelay<String>
    let valuePublisher: BehaviorRelay<Int>
    let textValuePublisher: BehaviorRelay<String>
    
    let plusPublisher = PublishRelay<Void>()
    let minusPublisher = PublishRelay<Void>()
    
    var step: Int {
        get {
            stepPublisher.value
        }
        
        set {
            stepPublisher.accept(newValue)
        }
    }
    
    // MARK: - Private Properties
    private let stepPublisher: BehaviorRelay<Int>
    private let maxValuePublisher: BehaviorRelay<Int>
    private let minValuePublisher: BehaviorRelay<Int>
    
    
    // MARK: - Initializers
    init(
        title: String,
        startValue: Int,
        step: Int,
        maxValue: Int,
        minValue: Int
    ) {
        self.titlePublisher = .init(value: title)
        self.valuePublisher = .init(value: startValue)
        self.textValuePublisher = .init(value: "\(startValue)")
        self.stepPublisher = .init(value: step)
        self.maxValuePublisher = .init(value: maxValue)
        self.minValuePublisher = .init(value: minValue)
        super.init()
        initialize()
    }
    
    // MARK: - Public Methods
    override func applyBinding() {
        plusPublisher
            .withLatestFrom(
                Observable.combineLatest(valuePublisher,
                                         stepPublisher,
                                         maxValuePublisher)
            ) { $1 }
            .map { value, step, maxValue in
                let newValue = value + step
                return newValue > maxValue ? maxValue : newValue
            }
            .bind(to: valuePublisher)
            .disposed(by: bag)
        
        minusPublisher
            .withLatestFrom(
                Observable.combineLatest(valuePublisher,
                                         stepPublisher,
                                         minValuePublisher)
            ) { $1 }
            .map { value, step, minValue in
                let newValue = value - step
                return newValue < minValue ? minValue : newValue
            }
            .bind(to: valuePublisher)
            .disposed(by: bag)
            
    }
}
