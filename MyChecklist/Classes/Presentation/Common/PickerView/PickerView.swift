//
//  PickerView.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 22.04.2023.
//

import UIKit

final class PickerView<T: Hashable & CaseIterable & TitleConvertible>: UIView where T.AllCases.Index == Int {

    private(set) var selectedCases: Set<T> = .init(minimumCapacity: T.allCases.count)
    var isRadio: Bool = false 

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupButtons()
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Should not use init(coder:)")
    }
    
    private func setupViews() {
        buttons.forEach(stack.addArrangedSubview)
        scrollView.addSubview(stack)
        addSubview(scrollView)
        scrollView.delegate = delegate
        buttons.forEach { button in
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 90).isActive = true
            button.layer.cornerRadius = 20
        }
    }
    
    private func setupButtons() {
        buttons = T.allCases.map({ model in
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = .black
            config.title = model.title
            config.image = nil

            let button = UIButton(configuration: config)
            let action = UIAction { [weak self] _ in
                defer {
                    self?.updateButtons()
                }
                guard let self, !self.selectedCases.contains(model) else {
                    self?.selectedCases.remove(model)
                    return
                }
                if self.isRadio {
                    self.selectedCases.removeAll(keepingCapacity: true)
                    self.selectedCases.insert(model)
                } else {
                    self.selectedCases.insert(model)
                }
                self.updateButtons()
            }
            button.addAction(action, for: .touchUpInside)
            button.layer.borderColor = Palette.surveyAnswerBorder.cgColor
            button.backgroundColor = Palette.surveyAnswerBackground
            return button
        })
        updateButtons()
    }
    
    @ConstraintActivator
    private func setupConstraints() {
        stack.leadingAnchor.constraint(equalTo: leadingAnchor)
        stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
        stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        scrollView.topAnchor.constraint(equalTo: topAnchor)
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
    }
    
    private func updateButtons() {
        UIView.animate(withDuration: 0.1, delay: 0) { [self] in
            buttons.enumerated().forEach { index, button in
                if selectedCases.contains(T.allCases[index]) {
                    button.layer.borderWidth = 5
                } else {
                    button.layer.borderWidth = 0
                }
            }
        }
        
    }

    private var buttons: [UIButton] = []
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fill
        
        return stack
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false
        return scrollView
    }()
    private let delegate = Delegate()
}

extension PickerView {
    private final class Delegate: NSObject, UIScrollViewDelegate {
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print(scrollView.adjustedContentInset)
            print(scrollView.contentInsetAdjustmentBehavior)
        }
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            print(scrollView.adjustedContentInset)
            print(scrollView.contentInsetAdjustmentBehavior)
        }
        func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            print(scrollView.adjustedContentInset)
            print(scrollView.contentInsetAdjustmentBehavior)
        }
    }
    
}
