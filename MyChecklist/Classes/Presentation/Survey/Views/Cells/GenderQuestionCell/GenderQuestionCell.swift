//
//  GenderQuestionCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 14.11.2021.
//

import UIKit
import RxCocoa
import RxSwift

// TODO: Redesign with viewModel
final class GenderQuestionCell: ReactiveCollectionViewCell<GenderQuestionViewModel> {
    // MARK: - Outlets
    @IBOutlet private weak var pickerView: UIPickerView! {
        didSet {
            pickerView.dataSource = self
            pickerView.delegate = self
            
        }
    }
    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.font = headerLabel.font.withSize(UIConstants.headerFontSize)
        }
    }
    
    // MARK: - Public Methods
    override func applyBindings() {
        pickerView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectedGenderInput)
            .disposed(by: bag)
    }
}

extension GenderQuestionCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfRows
    }
}

extension GenderQuestionCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let resultLabel: UILabel
        
        if let view = view as? UILabel {
            resultLabel = view
        } else {
            resultLabel = UILabel()
            resultLabel.font = .gilroySemibold(ofSize: UIConstants.pickerRowSize)
            resultLabel.textAlignment = .center
        }
        
        resultLabel.text = viewModel.genderTitle(forRow: row)
            
        return resultLabel
    }
}
