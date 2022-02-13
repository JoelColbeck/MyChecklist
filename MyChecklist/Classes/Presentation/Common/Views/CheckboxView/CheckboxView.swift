//
//  CheckboxView.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 29.01.2022.
//

import UIKit
import RxRelay
import RxSwift

final class CheckboxView: XibView {
    
    private enum Constants {
        static let checkboxEmptyImage = "iconCheckboxEmpty"
        static let checkboxSelectedImage = "iconCheckboxSelected"
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: Constants.checkboxEmptyImage)
        }
    }
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var helpLabel: UILabel!
    private var tapGesture: UITapGestureRecognizer!
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Public Properties
    var isSelectedObservable: Observable<Bool> {
        isSelectedPublisher.asObservable()
    }
    
    var mainText: String? {
        get {
            label.attributedText?.string
        }
        
        set {
            guard let str = newValue else { return }
            
            let range = NSRange(location: 0, length: str.length)
            
            let attributedString = NSMutableAttributedString(string: str)
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            attributedString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: range
            )
            
            label.attributedText = attributedString
        }
    }
    
    @IBInspectable
    var mainTextFontSize: CGFloat {
        get {
            label.font.pointSize
        }
        
        set {
            label.font = label.font.withSize(newValue)
        }
    }
    
    var helpText: String? {
        get {
            helpLabel.text
        }
        
        set {
            helpLabel.isHidden = (newValue == nil)
            helpLabel.text = newValue
        }
    }
    
    @IBInspectable
    var helpTextFontSize: CGFloat {
        get {
            helpLabel.font.pointSize
        }
        
        set {
            helpLabel.font = helpLabel.font.withSize(newValue)
        }
    }
    
    var checkboxSize: CGFloat {
        get {
            imageHeightConstraint.constant
        }
        
        set {
            imageHeightConstraint.constant = newValue
        }
    }
    
    // MARK: - Private Properties
    private let isSelectedPublisher = BehaviorRelay(value: false)
    private let bag = DisposeBag()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        configureTapGesture()
        applyBindings()
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        imageView.addGestureRecognizer(tapGesture)
        self.tapGesture = tapGesture
    }
    
    private func applyBindings() {
        isSelectedPublisher
            .skip(1)
            .subscribe(onNext: { [unowned self] isSelected in
                imageView.image = UIImage(
                    named: isSelected ?
                        Constants.checkboxSelectedImage :
                        Constants.checkboxEmptyImage
                )
            })
            .disposed(by: bag)
        
        tapGesture.rx.event
            .filter { $0.state == .ended }
            .withLatestFrom(isSelectedPublisher) { $1 }
            .map { !$0 }
            .bind(to: isSelectedPublisher)
            .disposed(by: bag)
    }
}
