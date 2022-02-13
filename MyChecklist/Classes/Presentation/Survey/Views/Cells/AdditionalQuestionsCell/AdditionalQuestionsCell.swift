//
//  AdditionalQuestionsCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 04.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class AdditionalQuestionsCell: BaseCollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var cholesterolCheckbox: CheckboxView! {
        didSet {
            cholesterolCheckbox.mainText = "У меня повышен холестерин"
            cholesterolCheckbox.mainTextFontSize = UIConstants.primaryTextSize
            cholesterolCheckbox.helpText = "Отметьте, если вы знаете, что ваш холестерин повышен"
            cholesterolCheckbox.helpTextFontSize = UIConstants.secondaryTextSize
            cholesterolCheckbox.checkboxSize = UIConstants.surveyCheckboxSize
        }
    }
    
    @IBOutlet private weak var diabetesCheckbox: CheckboxView! {
        didSet {
            diabetesCheckbox.mainText = "У меня диабет"
            diabetesCheckbox.mainTextFontSize = UIConstants.primaryTextSize
            diabetesCheckbox.checkboxSize = UIConstants.surveyCheckboxSize
        }
    }
    
    @IBOutlet private weak var brokenBonesCheckbox: CheckboxView! {
        didSet {
            brokenBonesCheckbox.mainText = "У меня был перелом при легком инциденте"
            brokenBonesCheckbox.mainTextFontSize = UIConstants.primaryTextSize
            brokenBonesCheckbox.helpText = "Например, если вы случайно ломали руку или иную часть тела в легком, на первый взгляд, несущественном прошествии."
            brokenBonesCheckbox.helpTextFontSize = UIConstants.secondaryTextSize
            brokenBonesCheckbox.checkboxSize = UIConstants.surveyCheckboxSize
        }
    }
    @IBOutlet private weak var headerLabel: UILabel! {
        didSet {
            headerLabel.text = "Дополнительные вопросы"
            headerLabel.font = .gilroyBold(ofSize: UIConstants.headerFontSize)
        }
    }
    
    // MARK: - Outputs
    var cholesterolSelectedObservable: Observable<Bool> {
        cholesterolCheckbox.isSelectedObservable
    }
    
    var diabetesSelectedObservable: Observable<Bool> {
        diabetesCheckbox.isSelectedObservable
    }
    
    var brokenBonesSelectedObservable: Observable<Bool> {
        brokenBonesCheckbox.isSelectedObservable
    }
}
