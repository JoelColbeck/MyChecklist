//
//  FamilyDiseasesCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 13.02.2022.
//

import UIKit

final class FamilyDiseasesCell: BaseCollectionViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var headerLabel: UILabel! {
        didSet {
            headerLabel.text = "Семейные заболевания"
            headerLabel.font = .gilroyBold(ofSize: UIConstants.headerFontSize)
        }
    }
    
    @IBOutlet private weak var secondaryHeaderLabel: UILabel! {
        didSet {
            secondaryHeaderLabel.text = "Отметьте болезни, которые случались с вашими близкими родственниками"
            secondaryHeaderLabel.font = .gilroySemibold(ofSize: UIConstants.primaryTextSize)
            secondaryHeaderLabel.alpha = 0.6
        }
    }
    
    @IBOutlet private weak var heartAttackCheckbox: CheckboxView! {
        didSet {
            heartAttackCheckbox.mainText = "Инфаркт"
            heartAttackCheckbox.mainTextFontSize = UIConstants.primaryTextSize
        }
    }
    
    @IBOutlet private weak var strokeCheckbox: CheckboxView! {
        didSet {
            strokeCheckbox.mainText = "Инсульт"
            strokeCheckbox.mainTextFontSize = UIConstants.primaryTextSize
        }
    }
    
    @IBOutlet private weak var hipFractureCheckbox: CheckboxView! {
        didSet {
            hipFractureCheckbox.mainText = "Перелом шейки бедра"
            hipFractureCheckbox.mainTextFontSize = UIConstants.primaryTextSize
        }
    }
    
    @IBOutlet private weak var diabetesCheckbox: CheckboxView! {
        didSet {
            diabetesCheckbox.mainText = "Диабет"
            diabetesCheckbox.mainTextFontSize = UIConstants.primaryTextSize
        }
    }
    
    

}
