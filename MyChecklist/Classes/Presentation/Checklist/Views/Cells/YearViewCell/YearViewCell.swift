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
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.alpha = 0.2
        }
    }
    
    // MARK: - Public Properties
    var calendarButtonTapped: Observable<Void> {
        calendarButton.rx.tap
            .map {}
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        anchorStackView.clear()
    }

    // MARK: - Public Methods
    func configure(model: ChecklistYearModel) {
        ageLabel.text = model.age
        yearLabel.text = model.year
        for anchor in model.anchors {
            let anchorView = AnchorView()
            anchorView.configure(anchor: anchor)
            anchorStackView.addArrangedSubview(anchorView)
        }
    }
}
