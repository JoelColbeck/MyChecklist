//
//  RelativeOncologyCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.02.2022.
//

import UIKit
import RxRelay
import RxSwift

final class RelativeOncologyCell: BaseCollectionViewCell {
    // MARK: - Outputs
    var prostateSelected: Observable<Bool> {
        prostateCheckbox.isSelectedObservable
    }
    
    var cervicalSelected: Observable<Bool> {
        cervicalCheckbox.isSelectedObservable
    }
    
    var colonSelected: Observable<Bool> {
        colonCheckbox.isSelectedObservable
    }
    
    var stomachSelected: Observable<Bool> {
        stomachCheckbox.isSelectedObservable
    }
    
    var lungsSelected: Observable<Bool> {
        lungsCheckbox.isSelectedObservable
    }
    
    var melanomaSelected: Observable<Bool> {
        melanomaCheckbox.isSelectedObservable
    }
    
    // MARK: - Private Properties
    private var gender: Gender!
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Should not user init(coder:)")
    }
    
    // MARK: - Public Methods
    func setup(with gender: Gender?) {
        primaryStackView.removeFromSuperview()
        primaryStackView.clear()
        contentView.addSubview(primaryStackView)
        if self.gender != gender {
            prostateCheckbox.update(isSelected: false)
            cervicalCheckbox.update(isSelected: false)
        }
        self.gender = gender
        configureStackView()
    }
    
    // MARK: - Private Methods
    private func configureStackView() {
        NSLayoutConstraint.activate([
            primaryStackView.centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            primaryStackView.centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor),
            primaryStackView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        let genderRelativeCheckbox: UIView
        switch gender {
        case .man:
            genderRelativeCheckbox = prostateCheckbox
        case .woman:
            genderRelativeCheckbox = cervicalCheckbox
        case .none:
            fatalError("Unexpectedly found nil.")
        }
        
        [
            headerLabel,
            genderRelativeCheckbox,
            colonCheckbox,
            stomachCheckbox,
            lungsCheckbox,
            melanomaCheckbox
        ].forEach { primaryStackView.addArrangedSubview($0) }
    }
    
    // MARK: - Views
    private let primaryStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let view = UILabel()
        view.font = .gilroyBold(ofSize: UIConstants.headerFontSize)
        view.text = "Онкология у близких родственников"
        view.numberOfLines = 0
        return view
    }()
    
    private let prostateCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Простаты"
        return view
    }()
    
    private let cervicalCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Шейки матки"
        return view
    }()
    
    private let colonCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Прямой кишки"
        return view
    }()
    
    private let stomachCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Желудка"
        return view
    }()
    
    private let lungsCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Лёгких"
        return view
    }()
    
    private let melanomaCheckbox: CheckboxView = {
        let view = CheckboxView()
        view.mainText = "Меланома"
        return view
    }()
}
