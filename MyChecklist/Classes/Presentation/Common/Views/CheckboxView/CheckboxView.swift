//
//  CheckboxView.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 04.12.2021.
//

import UIKit

final class CheckboxView: XibView {
    // MARK: - Views
    private weak var button: UIButton!
    
    // MARK: - Public Properties
    var title: String? {
        get { button.title(for: .normal) }
        set { button.setTitle(newValue, for: .normal) }
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.titleLabel?.font = .gilroySemibold(ofSize: 16)
        
    }
}
