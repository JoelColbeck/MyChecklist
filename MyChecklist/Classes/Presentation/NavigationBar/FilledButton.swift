//
//  FilledButton.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.03.2023.
//

import UIKit

final class FilledButton: UIView {
    struct ViewState: Equatable {
        var image: ImageDescriptor
        var isSelected: Bool
        
        var backgroundColor: UIColor
        var fillColor: UIColor
        var commonForegroundColor: UIColor
        var filledForegroundColor: UIColor
    }
    
    struct ViewActions {
        let buttonTapped: () -> Void
    }
    
    private(set) var viewState: ViewState?
    
    // MARK: - Public Methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }

    func fill(viewState: ViewState, viewActions: ViewActions?, animated: Bool) {
        update(viewActions: viewActions)
        guard animated else {
            update(viewState: viewState)
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.update(viewState: viewState)
        }
    }
    
    // MARK: - LC
    
    required init?(coder: NSCoder) {
        fatalError("Should not use init(coder:)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
        button.layer.cornerRadius = button.frame.width / 2
    }

    // MARK: - Private
    
    @ConstraintActivator
    private func setupConstraints() {
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: innerInset)
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -innerInset)
        button.topAnchor.constraint(equalTo: topAnchor, constant: innerInset)
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -innerInset)
    }
    
    private func update(viewState: ViewState) {
        guard self.viewState != viewState else { return }
        self.viewState = viewState
        var config = UIButton.Configuration.plain()
        config.image = UIImage(descriptor: viewState.image)

        button.configuration = config
        backgroundColor = viewState.backgroundColor
        button.backgroundColor = viewState.isSelected ? viewState.fillColor : .clear
        button.tintColor = viewState.isSelected
            ? viewState.filledForegroundColor
            : viewState.commonForegroundColor
    }
    
    private func update(viewActions: ViewActions?) {
        guard let viewActions else { return }
        button.removeTarget(nil, action: nil, for: .touchUpInside)
        let action = UIAction(handler: viewActions.buttonTapped ∘ pass)
        button.addAction(action, for: .touchUpInside)
    }

    private let button = UIButton()
}

private let innerInset: CGFloat = 4
