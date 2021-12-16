//
//  SmokeAlcoholCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 28.11.2021.
//

import UIKit
import RxCocoa

final class SmokeAlcoholCell: ReactiveCollectionViewCell<SmokeAlcoholViewModel> {
    // MARK: - Outlets
    @IBOutlet private weak var smokePicker: UIPickerView! {
        didSet {
            smokePicker.dataSource = self
            smokePicker.delegate = self
        }
    }
    
    @IBOutlet private weak var alcoholPicker: UIPickerView! {
        didSet {
            alcoholPicker.dataSource = self
            alcoholPicker.delegate = self
        }
    }
    
    // MARK: - LC
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
        switch pickerView {
        case let picker where picker === smokePicker:
            return viewModel.smokeNumberOfRows
        case let picker where picker === alcoholPicker:
            return viewModel.alcoholNumberOfRows
        default:
            return 0
        }
    }
}

extension SmokeAlcoholCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case let picker where picker === smokePicker:
            return viewModel.smokeTitle(forRow: row)
        case let picker where picker === alcoholPicker:
            return viewModel.alcoholTitle(forRow: row)
        default:
            return nil
        }
    }
}
