//
//  BaseCollectionViewCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 04.12.2021.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    private(set) var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func applyBindings() { }
    
    func initialize() {
        guard !isInitialized else {
            assertionFailure("Should not call this method twice")
            return
        }
        
        isInitialized = true
    }
    
    private var isInitialized: Bool = false
}
