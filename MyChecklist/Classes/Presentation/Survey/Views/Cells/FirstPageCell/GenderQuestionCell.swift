//
//  GenderQuestionCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 14.11.2021.
//

import UIKit
import RxCocoa
import RxSwift

final class GenderQuestionCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var pickerView: UIPickerView! {
        didSet {
            pickerView.dataSource = self
            pickerView.delegate = self
        }
    }
    
    // MARK: - Public Properties
    var selectedItem: Observable<Gender?> {
        pickerView.rx.itemSelected
            .map { Gender.allCases[safe: $0.row - 1] }
    }
    
    private(set) var bag = DisposeBag()
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        bag = DisposeBag()
    }
}

extension GenderQuestionCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        3
    }
}

extension GenderQuestionCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row > 0 {
            guard let gender = Gender.allCases[safe: row - 1] else { return nil }
            
            return gender.rawValue
        }
        
        return nil
    }
}
