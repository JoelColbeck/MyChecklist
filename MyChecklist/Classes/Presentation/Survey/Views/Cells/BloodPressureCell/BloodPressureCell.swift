//
//  BloodPressureCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 04.12.2021.
//

import UIKit

final class BloodPressureCell: ReactiveCollectionViewCell<BloodPressureViewModel> {
    @IBOutlet private weak var pickerView: UIPickerView! {
        didSet {
            pickerView.dataSource = self
            pickerView.delegate = self
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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.bloodPressureTitle(forRow: row)
    }
}
