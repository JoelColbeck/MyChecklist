//
//  PickerCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 05.06.2022.
//

import UIKit

final class PickerCell<T: CaseIterable & TitleConvertible>:
    ReactiveCollectionViewCell<PickerCellViewModel<T>>,
    UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Public Methods
    override func applyBindings() {
        pickerView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.rowInput)
            .disposed(by: bag)
        
    }
    
    override func initialize() {
        super.initialize()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        contentView.addSubview(primaryStackView)
        primaryStackView.addArrangedSubview(title)
        primaryStackView.addArrangedSubview(pickerView)
        
        NSLayoutConstraint.activate([
            primaryStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            primaryStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Private Properties
    private static var titles: [String] {
        T.allCases.map(\.title)
    }
    
    private let primaryStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let title: UILabel = {
        let view = UILabel()
        view.font = .gilroySemibold(ofSize: UIConstants.headerFontSize)
        return view
    }()
    
    private let pickerView: UIPickerView = {
        let view = UIPickerView()
        return view
    }()
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        T.allCases.count + 1
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        let resultLabel: UILabel
        
        if let view = view as? UILabel {
            resultLabel = view
        } else {
            resultLabel = UILabel()
            resultLabel.textAlignment = .center
            resultLabel.font = .gilroySemibold(ofSize: UIConstants.pickerRowSize)
            resultLabel.numberOfLines = 2
        }

        resultLabel.text = Self.titles[safe: row - 1] ?? "Затрудняюсь ответить"
        
        return resultLabel
    }
}
