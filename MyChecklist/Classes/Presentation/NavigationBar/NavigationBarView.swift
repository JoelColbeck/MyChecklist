//
//  NavigationBarView.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 28.02.2023.
//

import UIKit

protocol NavigationBarViewDelegate: AnyObject {
    func didSelect(page: Page)
}

final class NavigationBarView: UIView {
    
    weak var delegate: NavigationBarViewDelegate?
    
    // MARK: - Public Methods
    override init(frame: CGRect) {
        yearPicker = SegmentedControl(
            config: SegmentedControl.Config(
                backgroundColor: .white,
                selectedBackgroundColor: Palette.currentYearNavbar,
                titleColor: .black
            ),
            items: [
                .init(title: Page.currentYear.buttonTitle),
                .init(title: Page.futureYear.buttonTitle)
            ]
        )
        
        super.init(frame: frame)
        backgroundColor = yearPicker.config.selectedBackgroundColor
        
        yearPicker.delegate = self
        [yearPicker, titleLabel, checklistsButton].forEach(addSubview(_:))
        configureChecklistsButton()
        configureTitleLable()
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
    // MARK: - LC
    
    required init?(coder: NSCoder) {
        fatalError("Should not user init(coder:)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 30
    }
    
    // MARK: - Private
    
    private func configureTitleLable() {
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureChecklistsButton() {
        let viewState = FilledButton.ViewState(
            image: .checklistIcon,
            isSelected: false,
            backgroundColor: .white,
            fillColor: .black,
            commonForegroundColor: .black,
            filledForegroundColor: .white
        )
        let action = FilledButton.ViewActions { [weak self] in
            guard let checklistsIndex = Page.allCases.firstIndex(of: .checklists) else {
                assertionFailure()
                return
            }
            
            self?.didSelect(index: checklistsIndex)
        }
        checklistsButton.fill(viewState: viewState, viewActions: action, animated: false)
    }
    
    @ConstraintActivator
    private func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: topInset)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: titleHorizontalInset)
        
        yearPicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalInset)
        yearPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topInset)
        yearPicker.heightAnchor.constraint(equalToConstant: itemHeight)
        
        checklistsButton.leadingAnchor.constraint(
            equalTo: yearPicker.trailingAnchor,
            constant: itemSpacing
        )
        checklistsButton.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -horizontalInset
        )
        checklistsButton.topAnchor.constraint(equalTo: yearPicker.topAnchor)
        checklistsButton.heightAnchor.constraint(equalTo: yearPicker.heightAnchor)
        
        bottomAnchor.constraint(equalTo: yearPicker.bottomAnchor, constant: bottomSpacing)
    }
    
    private let titleLabel = UILabel()
    private let yearPicker: SegmentedControl
    private let checklistsButton = FilledButton()
}

extension NavigationBarView: SegmentedControlDelegate {
    func didSelect(index: Int) {
        guard (0..<Page.allCases.count).contains(index) else {
            assertionFailure("Index out of range")
            return
        }
        let page = Page.allCases[index]
        var config = yearPicker.config
        switch page {
        case .futureYear:
            config.selectedBackgroundColor = Palette.futureYearNavbar
            updateChecklistButton(isSelected: false)
        case .currentYear:
            config.selectedBackgroundColor = Palette.currentYearNavbar
            updateChecklistButton(isSelected: false)
        case .checklists:
            yearPicker.clearSelection()
            config.selectedBackgroundColor = Palette.checklistsNavbar
            updateChecklistButton(isSelected: true)
        }
        UIView.animate(withDuration: 0.3) {
            self.yearPicker.updateConfig(config)
        }
        updateNavbar(page: page)
        delegate?.didSelect(page: page)
    }
    
    private func updateChecklistButton(isSelected: Bool) {
        guard var viewState = checklistsButton.viewState else { return }
        viewState.isSelected = isSelected
        checklistsButton.fill(viewState: viewState, viewActions: nil, animated: true)
    }
    
    private func updateNavbar(page: Page) {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = page.navbarColor
        }
    }
}

extension Page {
    fileprivate var buttonTitle: String {
        switch self {
        case .currentYear:
            return Localization.currentYear
        case .futureYear:
            return Localization.futureYears
        case .checklists:
            return ""
        }
    }
    
    fileprivate var navbarColor: UIColor {
        switch self {
        case .currentYear:
            return Palette.currentYearNavbar
        case .futureYear:
            return Palette.futureYearNavbar
        case .checklists:
            return Palette.checklistsNavbar
        }
    }
}

private let titleHorizontalInset: CGFloat = 25
private let horizontalInset: CGFloat = 18
private let topInset: CGFloat = 15
private let itemSpacing: CGFloat = 10
private let itemHeight: CGFloat = 70
private let bottomSpacing: CGFloat = 20
