//
//  RadioButton.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 29.06.2022.
//

import UIKit
import RxCocoa

final class RadioButton: UIView {
    
    var tap: Signal<Void> {
        button.rx.tap
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
    
    // MARK: - Public Methods
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(selected: Bool) {
        button.setImage(
            selected
                ? Image.radioFilled.image
                : Image.radioEmpty.image,
            for: .normal)
    }

    // MARK: - Private Methods

    private func initialize() {
        let primary = UIStackView()
        primary.translatesAutoresizingMaskIntoConstraints = false
        primary.axis = .horizontal
        primary.spacing = spacing
        primary.alignment = .center
        primary.addArrangedSubview(button)
        primary.addArrangedSubview(titleLabel)
        addSubview(primary)
        
        NSLayoutConstraint.activate([
            primary.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
            primary.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingMargin),
            primary.topAnchor.constraint(equalTo: topAnchor),
            primary.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: buttonSide),
            button.heightAnchor.constraint(equalToConstant: buttonSide),
        ])
    }

    // MARK: - Private Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(Image.radioEmpty.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

private let buttonSide: CGFloat = 37
private let spacing: CGFloat = 20
private let leadingMargin: CGFloat = 20
private let trailingMargin: CGFloat = -20
