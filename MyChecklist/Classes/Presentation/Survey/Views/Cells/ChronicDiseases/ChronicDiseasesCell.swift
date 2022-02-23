//
//  ChronicDiseasesCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 23.02.2022.
//

import UIKit
import RxSwift

final class ChronicDiseasesCell: BaseCollectionViewCell {
    // MARK: - Outputs
    var lungsSelected: Observable<Bool> {
        lungsCheckbox.isSelectedObservable
    }
    
    var cardioSelected: Observable<Bool> {
        cardioCheckbox.isSelectedObservable
    }
    
    var liverSelected: Observable<Bool> {
        liverCheckbox.isSelectedObservable
    }
    
    var stomachSelected: Observable<Bool> {
        stomachCheckbox.isSelectedObservable
    }
    
    var kidneysSelected: Observable<Bool> {
        kidneysCheckbox.isSelectedObservable
    }
    
    var hivSelected: Observable<Bool> {
        hivCheckbox.isSelectedObservable
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Should not use init(coder:)")
    }
    
    // MARK: - Private Methods
    private func setup() {
        contentView.addSubview(primaryStackView)
        configurePrimaryStackConstraints()
        addSubviewsToStack()
    }
    
    private func configurePrimaryStackConstraints() {
        NSLayoutConstraint.activate([
            primaryStackView.centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            primaryStackView.centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor),
            primaryStackView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
    
    private func addSubviewsToStack() {
        [
            headerLabel,
            secondaryLabel
        ].forEach {
            secondaryStackView.addArrangedSubview($0)
        }
        
        [
            secondaryStackView,
            lungsCheckbox,
            cardioCheckbox,
            liverCheckbox,
            stomachCheckbox,
            kidneysCheckbox,
            hivCheckbox
        ].forEach {
            primaryStackView.addArrangedSubview($0)
        }
    }
    
    // MARK: - Views
    private let primaryStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let secondaryStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let headerLabel: UILabel = {
        let view = UILabel()
        view.font = .gilroyBold(ofSize: UIConstants.headerFontSize)
        view.text = "Хронические заболевания"
        return view
    }()
    
    private let secondaryLabel: UILabel = {
        let view = UILabel()
        view.font = .gilroySemibold(ofSize: UIConstants.primaryTextSize)
        view.text = "Отметьте свои хронические заболевания"
        view.numberOfLines = 0
        view.alpha = 0.6
        return view
    }()
    
    private let lungsCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Хроническая болезнь лёгких"
        view.mainTextFontSize = UIConstants.primaryTextSize
        return view
    }()
    
    private let cardioCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Хроническая болезнь сердечно-сосудистой системы"
        view.mainTextFontSize = UIConstants.primaryTextSize
        return view
    }()
    
    private let liverCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Хроническая болезнь печени"
        view.mainTextFontSize = UIConstants.primaryTextSize
        return view
    }()
    
    private let stomachCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Хроническая болезнь печени"
        view.mainTextFontSize = UIConstants.primaryTextSize
        return view
    }()
    
    private let kidneysCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Хроническая болезнь почек"
        view.mainTextFontSize = UIConstants.primaryTextSize
        return view
    }()
    
    private let hivCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "У меня ВИЧ"
        view.mainTextFontSize = UIConstants.primaryTextSize
        return view
    }()
}
