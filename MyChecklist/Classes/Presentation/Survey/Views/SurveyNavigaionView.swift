//
//  SurveyNavigaionView.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 09.07.2022.
//

import UIKit

import RxCocoa
import RxSwift

final class SurveyNavigationView: UIView {
    
    // MARK: - Public Properties
    
    var nextTap: Signal<Void> {
        nextButton.rx.tap
            .withLatestFrom(currentBehavior)
            .withLatestFrom(maxCountBehavior) { ($0, $1) }
            .compactMap { return $0 <= $1 ? () : nil }
            .asSignal(onErrorJustReturn: ())
            .throttle(.milliseconds(300), latest: false)
    }
    
    var backTap: Signal<Void> {
        backButton.rx.tap
            .withLatestFrom(currentBehavior)
            .compactMap { return $0 > 0 ? () : nil }
            .asSignal(onErrorJustReturn: ())
    }
    
    var maxCountBehavior = BehaviorRelay<Int>(value: 0)
    
    var currentBehavior = BehaviorRelay<Int>(value: 0)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    // MARK: - Private Methods
    
    private func initialize() {
        backgroundColor = .clear
        [
            nextButton,
            backButton,
            counter
        ]
            .onSide { $0.translatesAutoresizingMaskIntoConstraints = false }
            .forEach(addSubview)
        configureConstraints()
        subscribe()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: buttonHeight),
            backButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            counter.centerXAnchor.constraint(equalTo: centerXAnchor),
            counter.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingMargin),
            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
    
    private func subscribe() {
        let shared = Driver
            .combineLatest(currentBehavior.asDriver(), maxCountBehavior.asDriver())
        
        shared
            .map { (current, max) in "\(current) из \(max)"}
            .drive(counter.rx.text)
            .disposed(by: bag)
        
        shared
            .map { (current, max) in current < max }
            .drive(nextButton.rx.isEnabled)
            .disposed(by: bag)
        
        shared
            .map { (current, _) in current > 1 }
            .drive(backButton.rx.isEnabled)
            .disposed(by: bag)
        
        nextTap
            .asObservable()
            .withLatestFrom(currentBehavior.asDriver())
            .map { $0 + 1 }
            .bind(to: currentBehavior)
            .disposed(by: bag)
        
        backTap
            .asObservable()
            .withLatestFrom(currentBehavior)
            .map { $0 - 1 }
            .bind(to: currentBehavior)
            .disposed(by: bag)
        
    }
    
    // MARK: - Private Properties
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.semanticContentAttribute = .forceRightToLeft
        button.contentEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 0,
            right: 10
        )
        button.setImage(Image.systemArrowRight.image, for: .normal)
        button.setBackgroundColor(.red, forState: .normal)
        button.tintColor = .white
        button.cornerRadius = buttonHeight / 2
        button.clipsToBounds = true
        button.titleLabel?.font = .gilroyBold(ofSize: UIConstants.secondaryTextSize)
        button.setTitle("Дальше", for: .normal)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.systemArrowLeft.image, for: .normal)
        button.setBackgroundColor(.gray.withAlphaComponent(0.5), forState: .normal)
        button.cornerRadius = buttonHeight / 2
        button.clipsToBounds = true
        button.tintColor = .black
        return button
    }()
    
    private let counter: UILabel = {
        let label = UILabel()
        label.font = .gilroySemibold(ofSize: UIConstants.secondaryTextSize)
        return label
    }()
    
    private let bag = DisposeBag()
}

private let leadingMargin: CGFloat = 20
private let buttonHeight: CGFloat = 40
private let trailingMargin: CGFloat = -20
