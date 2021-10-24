//
//  PinCodeView.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 09.10.2021.
//

import UIKit
import RxCocoa
import RxSwift

final class PinCodeView: XibView {
    // MARK: - Outlets
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    // MARK: - Public Properties
    private(set) var bag = DisposeBag()
    var copyButtonTapped: ControlEvent<Void> {
        copyButton.rx.tap
    }
    
    // MARK: - Public Methods
    func configure(code: String) {
        bag = DisposeBag()
        codeLabel.text = code
        applyBinding()
    }
    
    // MARK: - Private Methods
    private func applyBinding() {
        copyButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                UIPasteboard.general.string = codeLabel.text
            })
            .disposed(by: bag)
    }
}
