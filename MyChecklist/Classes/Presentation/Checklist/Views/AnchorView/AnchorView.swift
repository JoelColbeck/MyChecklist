//
//  AnchorView.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation
import UIKit

class AnchorView: XibView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var importanceLabel: UILabel!
    @IBOutlet private weak var importanceImageView: UIImageView!
    
    func configure(anchor: ChecklistAnchorModel) {
        titleLabel.text = anchor.title
        categoryLabel.text = anchor.category
        importanceLabel.text = anchor.importance.description
        importanceImageView.image = UIImage(named: anchor.importance.imageName)
    }
}
