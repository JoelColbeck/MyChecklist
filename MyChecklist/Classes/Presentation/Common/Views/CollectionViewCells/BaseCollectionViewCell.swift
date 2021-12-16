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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func applyBindings() { }
}
