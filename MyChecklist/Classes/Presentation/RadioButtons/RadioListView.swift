//
//  RadioListView.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 29.06.2022.
//

import UIKit

import RxCocoa
import RxSwift
import RxRelay

final class RadioListView<T: RadioEnum>: UIView {
    
    var selectionSignal: Signal<T> {
        selectionPublisher
            .asSignal()
    }
    
    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    // MARK: - Private
    
    private func initialize() {
        addSubview(buttonsStack)
        setupConstraints()
        createButtons()
        subscribe()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsStack.topAnchor.constraint(equalTo: topAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createButtons() {
        radioButtons = T.allCases
            .map { model in
                let button = RadioButton()
                button.set(title: model.title)
                button.tap
                    .map { model }
                    .emit(to: selectionPublisher)
                    .disposed(by: bag)
                return button
            }
    }
    
    private func subscribe() {
        selectionSignal
            .debug("SelectionSignal", trimOutput: true)
            .emit(onNext: weakify(self, in: type(of: self).updateButtonsStates))
            .disposed(by: bag)
    }
    
    private func updateButtonsStates(selection: T) {
        for (button, model) in zip(radioButtons, T.allCases) {
            button.set(selected: selection == model)
        }
    }
    
    // MARK: - Private Properties
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = spacing
        return stack
    }()
    private var radioButtons: [RadioButton] = []
    private let selectionPublisher = PublishRelay<T>()
    
    
    private let bag = DisposeBag()
}

private let spacing: CGFloat = 12
