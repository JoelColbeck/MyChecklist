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
    @IBOutlet weak var smokeLabel: UILabel! {
        didSet {
            smokeLabel.font = smokeLabel.font.withSize(UIConstants.headerFontSize)
        }
    }
    @IBOutlet private weak var smokePicker: UIPickerView! {
        didSet {
            smokePicker.dataSource = self
            smokePicker.delegate = self
        }
    }
    
    
    @IBOutlet weak var alcoholLabel: UILabel! {
        didSet {
            alcoholLabel.font = alcoholLabel.font.withSize(UIConstants.headerFontSize)
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
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let resultLabel: UILabel
        
        if let view = view as? UILabel {
            resultLabel = view
        } else {
            resultLabel = UILabel()
        }
        
        resultLabel.font = .gilroySemibold(ofSize: UIConstants.pickerRowSize)
        resultLabel.textAlignment = .center
        
        switch pickerView {
        case let picker where picker === smokePicker:
            resultLabel.text = viewModel.smokeTitle(forRow: row)
        case let picker where picker === alcoholPicker:
            resultLabel.text = viewModel.alcoholTitle(forRow: row)
        default: fatalError("Unexpected UIPickerView in file \(#file)\nline: \(#line)")
        }
        
        return resultLabel
    }
}
