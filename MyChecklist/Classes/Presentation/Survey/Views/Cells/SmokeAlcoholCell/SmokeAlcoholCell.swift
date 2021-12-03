//
//  SmokeAlcoholCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 28.11.2021.
//

import UIKit

final class SmokeAlcoholCell: ReactiveCollectionViewCell<SmokeAlcoholViewModel> {
    @IBOutlet weak var smokePicker: UIPickerView! {
        didSet {
            smokePicker.dataSource = self
            smokePicker.delegate = self
        }
    }
    
    @IBOutlet weak var alcoholPicker: UIPickerView! {
        didSet {
            alcoholPicker.dataSource = self
            alcoholPicker.delegate = self
        }
    }
    
    override func applyBindings() {
        smokePicker.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectedSmokeRow)
            .disposed(by: bag)
        
        alcoholPicker.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectedAlcoholRow)
            .disposed(by: bag)
    }
}

extension SmokeAlcoholCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        4
    }
}

extension SmokeAlcoholCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row > 0 else { return nil }
        switch pickerView {
        case let picker where picker === smokePicker:
            return viewModel.titleForSmoke(row)
        case let picker where picker === alcoholPicker:
            return viewModel.titleForAlcohol(row)
        default:
            return nil
        }
    }
}
