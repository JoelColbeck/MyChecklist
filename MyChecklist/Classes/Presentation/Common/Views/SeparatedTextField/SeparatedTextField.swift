//
//  SeparatedTextField.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SeparatedTextField: XibView {
    
    // MARK: - Outlets
    @IBOutlet weak var textFieldsStack: UIStackView! {
        didSet {
            for subview in textFieldsStack.arrangedSubviews where subview is UITextField {
                if let textField = subview as? UITextField {
                    textField.keyboardType = .numberPad
                    textFields.append(textField)
                }
                
            }
        }
    }
    var textFields: [UITextField] = []
    
    // MARK: - Public Properties
    private(set) var bag = DisposeBag()
    var textObservable: Observable<String> {
        result.asObservable()
    }
    
    // MARK: - Private Properties
    private let updateValuePublisher = PublishRelay<Void>()
    private let updateFirstResponderPublisher = PublishRelay<Void>()
    private let textBehavior = BehaviorRelay<String>(value: "")
    private let result = PublishRelay<String>()
    
    // MARK: - LC
    override func awakeFromNib() {
        super.awakeFromNib()
        applyBinding()
    }
    
    private func applyBinding() {
        updateFirstResponderPublisher
            .debug("Update First Responder")
            .subscribe(onNext: { [unowned self] in
                let tf = textFields[getFirstFreeTextFieldIndex()]
                if !tf.isFirstResponder {
                    tf.becomeFirstResponder()
                }
            })
            .disposed(by: bag)
        
        updateValuePublisher
            .subscribe(onNext: { [unowned self] in
                textBehavior.accept(textFields.reduce("", { $0 + $1.textOrEmpty }))
            })
            .disposed(by: bag)
        
        textFields.enumerated()
            .forEach { [unowned self] (index, textField) in
                textField.delegate = self

                textField.rx
                    .controlProperty(
                        editingEvents: .editingChanged,
                        getter: { $0.textOrEmpty },
                        setter: { $0.text = $1 })
                    .skip(1)
                    .debug("Value changed", trimOutput: true)
                    .subscribe(onNext: { text in
                        updateValuePublisher.accept(())
                        if text.isEmpty {
                            let prevTextField: UITextField

                            switch getFirstFreeTextFieldIndex() - 1 {
                            case let x where x < 0:
                                prevTextField = textFields.first!
                            case let x where x >= 0:
                                prevTextField = textFields[x]
                            default:
                                prevTextField = textFields.first!
                            }

                            prevTextField.becomeFirstResponder()
                        } else {
                            let nextTextField = textFields[getFirstFreeTextFieldIndex()]

                            nextTextField.becomeFirstResponder()
                        }
                    })
                    .disposed(by: bag)
            }
        
        textBehavior
            .filter { [unowned self] in $0.count >= textFields.count }
            .do(onNext: { [unowned self] code in
                textFields.forEach { tf in
                    tf.isEnabled = false
                }
            })
            .bind(to: result)
            .disposed(by: bag)
    }
    
    // MARK: - Public Methods
    func clear() {
        textFields.forEach { textField in
            textField.text = ""
            textField.isEnabled = true
        }
        
        textFields.first!.becomeFirstResponder()
    }
    
    
    // MARK: - Private Methods
    private func getFirstFreeTextFieldIndex() -> Int {
        for (index, textField) in textFields.enumerated() {
            if textField.textOrEmpty.isEmpty {
                return index
            }
        }
        return textFields.count - 1
    }
}

extension SeparatedTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
              }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 1
    }
}
