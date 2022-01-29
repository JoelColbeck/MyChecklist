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
    
    enum Constants {
        static let checkboxSelectedImage = "checkmark.square.fill"
        
        static let checkboxUnselectedImage = "square"
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var helpButton: UIButton!
    private var tapGesture: UITapGestureRecognizer!
    
    // MARK: - Public Properties
    var isSelectedObservable: Observable<Bool> {
        isSelectedPublisher.asObservable()
    }
    
    var helpButtonTapped: Observable<String> {
        helpButton.rx.tap
            .withLatestFrom(helpTextPublisher) { $1 }
    }
    
    var text: String? {
        get {
            label.text
        }
        
        set {
            label.text = newValue
        }
    }
    
    var needHelp = false {
        didSet {
            helpButton.isHidden = !needHelp
        }
    }
    
    var helpText: String {
        get {
            helpTextPublisher.value
        }
        
        set {
            helpTextPublisher.accept(newValue)
        }
    }
    
    // MARK: - Private Properties
    private let isSelectedPublisher = BehaviorRelay(value: false)
    private let helpTextPublisher = BehaviorRelay(value: "")
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
        
        self.tapGesture = tapGesture
        imageView.addGestureRecognizer(tapGesture)
    }
    
    private func applyBindings() {
        isSelectedPublisher
            .skip(1)
            .subscribe(onNext: { [unowned self] isSelected in
                let tintColor: UIColor = isSelected ? .red : .black
                let imageName = isSelected ?
                Constants.checkboxSelectedImage :
                Constants.checkboxUnselectedImage
                
                imageView.tintColor = tintColor
                imageView.image = UIImage(systemName: imageName)
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
