//
//  BloodPressureCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 04.12.2021.
//

import UIKit
import RxCocoa

final class BloodPressureCell: ReactiveCollectionViewCell<BloodPressureViewModel> {
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
    
    override func applyBindings() {
        pickerView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.bloodPressureInput)
            .disposed(by: bag)
    }
}

extension BloodPressureCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfRows
    }
}

extension BloodPressureCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let resultLabel: UILabel
        
        if let view = view as? UILabel {
            resultLabel = view
        } else {
            resultLabel = UILabel()
            resultLabel.textAlignment = .center
            resultLabel.font = .gilroySemibold(ofSize: UIConstants.pickerRowSize)
        }
        
        resultLabel.text = viewModel.bloodPressureTitle(forRow: row)
        
        return resultLabel
    }
}
