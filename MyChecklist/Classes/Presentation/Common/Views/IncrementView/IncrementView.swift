//
//  IncrementView.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 14.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class IncrementView: XibView {
    // MARK: - Outlets
    @IBOutlet private weak var calculatorView: UIView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = titleLabel.font.withSize(UIConstants.primaryTextSize)
        }
    }
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var textField: UITextField! {
        didSet {
            textField.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var calcView: UIView! {
        didSet {
            calcView.borderColor = .gray.withAlphaComponent(0.1)
            calcView.borderWidth = 2
        }
    }
    
    // MARK: - Public Properties
    var value: Observable<String> {
        textField.rx.text
            .orEmpty
            .asObservable()
    }
    
    var viewModel: IncrementViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    
    // MARK: - Private Properties
    private let bag = DisposeBag()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.titlePublisher
            .bind(to: titleLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.valuePublisher
            .map { "\($0)" }
            .bind(to: textField.rx.text)
            .disposed(by: bag)
        
        textField.rx.text
            .orEmpty
            .bind(to: viewModel.textValuePublisher)
            .disposed(by: bag)
        
        minusButton.rx.tap
            .bind(to: viewModel.minusPublisher)
            .disposed(by: bag)
        
        plusButton.rx.tap
            .bind(to: viewModel.plusPublisher)
            .disposed(by: bag)
    }
}
