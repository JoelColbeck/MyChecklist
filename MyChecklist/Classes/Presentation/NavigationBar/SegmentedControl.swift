//
//  SegmentedControl.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.03.2023.
//

import UIKit

protocol SegmentedControlDelegate: AnyObject {
    func didSelect(index: Int)
}

final class SegmentedControl: UIView {
    struct Item {
        let title: String
    }
    
    struct Config {
        var backgroundColor: UIColor
        var selectedBackgroundColor: UIColor
        var titleColor: UIColor
    }
    
    weak var delegate: SegmentedControlDelegate?
    
    private(set) var config: Config
    
    private(set) var selectedIndex: Int? = 0
    
    init(config: Config, items: [Item]) {
        buttonsStack = UIStackView()
        self.items = items
        self.config = config
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false

        clipsToBounds = true
        selectedBackground.clipsToBounds = true
        selectedBackground.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectedBackground)

        buttonsStack.axis = .horizontal
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonsStack)

        setup(items: items)
        setupConstraints()
        updateConfig(config)
    }

    func clearSelection() {
        selectedIndex = nil
        UIView.animate(withDuration: 0.5) {
            self.selectedBackground.alpha = 0
        }
    }
    
    func updateConfig(_ config: Config) {
        self.config = config
        backgroundColor = config.backgroundColor
        selectedBackground.backgroundColor = config.selectedBackgroundColor
        buttonsStack.arrangedSubviews
            .forEach { view in
                (view as? UIButton)?.tintColor = config.titleColor
            }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        selectedBackground.layer.cornerRadius = selectedBackground.frame.height / 2
    }

    // MARK: - Private
    
    @ConstraintActivator private func setupConstraints() {
        buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        buttonsStack.topAnchor.constraint(equalTo: topAnchor)
        buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        
        selectedBackgroundLeadingConstraint
        selectedBackground.centerYAnchor.constraint(equalTo: centerYAnchor)
        selectedBackground.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.49)
        selectedBackground.heightAnchor.constraint(equalTo: heightAnchor, constant: -10)
    }
    
    private func setup(items: [Item]) {
        items.enumerated()
            .map { index, item in
                var config = UIButton.Configuration.plain()
                let attributeContainer = AttributeContainer(
                    [
                        .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
                    ]
                )
                config.attributedTitle = AttributedString(item.title, attributes: attributeContainer)
                let action = UIAction(handler: partialApply(itemSelected, index) ∘ pass)
                let button = UIButton(configuration: config, primaryAction: action)
                return button
            }
            .forEach(buttonsStack.addArrangedSubview)
        layoutIfNeeded()
    }
    
    private func itemSelected(index: Int) {
        selectedIndex = index
        self.updateSelectionViewConstraint()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.selectedBackground.alpha = 1
            self.layoutIfNeeded()
        }
        delegate?.didSelect(index: index)
    }
    
    private func updateSelectionViewConstraint() {
        guard let selectedIndex else { return }
        let buttonWidth = buttonsStack.frame.width / CGFloat(items.count)
        
        let constant: CGFloat
        if selectedIndex == 0 {
            constant = leadingEdgeInset
        } else if selectedIndex > 0 {
            constant = leadingEdgeInset + CGFloat(selectedIndex) * buttonWidth
        } else {
            constant = 0
            assertionFailure()
        }
        selectedBackgroundLeadingConstraint.constant = constant
    }

    private lazy var selectedBackgroundLeadingConstraint: NSLayoutConstraint = selectedBackground
        .leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
    private let selectedBackground = UIView()
    private let buttonsStack: UIStackView
    private let items: [Item]
}

private let leadingEdgeInset: CGFloat = 5
