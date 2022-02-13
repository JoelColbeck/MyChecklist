//
//  AdditionalQuestionsCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 04.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class AdditionalQuestionsCell: ReactiveCollectionViewCell<AdditionalQuestionsViewModel> {
    
    private enum Constants {
        static let checkboxSize: CGFloat = 30
    }
    
    // MARK: - Outlets
    @IBOutlet weak var cholesterolCheckbox: CheckboxView! {
        didSet {
            cholesterolCheckbox.mainText = "У меня повышен холестерин"
            cholesterolCheckbox.mainTextFontSize = UIConstants.primaryTextSize
            cholesterolCheckbox.helpText = "Отметьте, если вы знаете, что ваш холестерин повышен"
            cholesterolCheckbox.helpTextFontSize = UIConstants.secondaryTextSize
        }
    }
    
    @IBOutlet weak var diabetesCheckbox: CheckboxView! {
        didSet {
            diabetesCheckbox.mainText = "У меня диабет"
            diabetesCheckbox.mainTextFontSize = UIConstants.primaryTextSize
        }
    }
    
    @IBOutlet weak var brokenBonesCheckbox: CheckboxView! {
        didSet {
            brokenBonesCheckbox.mainText = "У меня был перелом при легком инциденте"
            brokenBonesCheckbox.mainTextFontSize = UIConstants.primaryTextSize
            brokenBonesCheckbox.helpText = "Например, если вы случайно ломали руку или иную часть тела в легком, на первый взгляд, несущественном прошествии."
            brokenBonesCheckbox.helpTextFontSize = UIConstants.secondaryTextSize
        }
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        for view in subviews where view is CheckboxView {
            guard let checkbox = view as? CheckboxView else { continue }
            checkbox.mainTextFontSize = UIConstants.primaryTextSize
            checkbox.helpTextFontSize = UIConstants.secondaryTextSize
            checkbox.checkboxSize = Constants.checkboxSize
        }
    }
}
