//
//  RelativeOncologyCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.02.2022.
//

import UIKit
import RxRelay

final class RelativeOncologyCell: BaseCollectionViewCell {
    // MARK: - Outputs
    
    
    // MARK: - Private Properties
    private var gender: Gender!
    private var isSetted: Bool = false
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Should not user init(coder:)")
    }
    
    // MARK: - Public Methods
    func setup(with gender: Gender?) {
        guard !isSetted else { return }
        self.gender = gender
        contentView.addSubview(primatyStackView)
        configureStackView()
        
        isSetted = true
    }
    
    func update(with gender: Gender?) {
        
    }
    
    // MARK: - Private Methods
    private func configureStackView() {
        NSLayoutConstraint.activate([
            primatyStackView.centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            primatyStackView.centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor),
            primatyStackView.leadingAnchor
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
        ].forEach { primatyStackView.addArrangedSubview($0) }
    }
    
    // MARK: - Views
    private let primatyStackView: UIStackView = {
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
