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
    
    @IBOutlet weak var cholesterolCheckbox: CheckboxView! {
        didSet {
            cholesterolCheckbox.text = "У меня повышен холестерин"
        }
    }
    
    @IBOutlet weak var diabetesCheckbox: CheckboxView! {
        didSet {
            diabetesCheckbox.text = "У меня диабет"
        }
    }
    
    @IBOutlet weak var brokenBonesCheckbox: CheckboxView! {
        didSet {
            brokenBonesCheckbox.text = "У меня был перелом при легком инциденте"
        }
    }
}
