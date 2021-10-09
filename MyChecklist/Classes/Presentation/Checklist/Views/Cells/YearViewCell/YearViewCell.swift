//
//  YearViewCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class YearViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var anchorStackView: UIStackView!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var calendarButton: UIButton!
    
    // MARK: - Public Properties
    var calendarButtonTapped: Observable<Void> {
        calendarButton.rx.tap
            .map {}
    }

    // MARK: - Public Methods
    func configure(model: ChecklistYearModel) {
        ageLabel.text = model.age
        yearLabel.text = model.year
    }
}
