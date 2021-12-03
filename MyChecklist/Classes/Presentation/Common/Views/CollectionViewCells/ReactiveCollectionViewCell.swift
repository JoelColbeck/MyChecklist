//
//  ReactiveCollectionViewCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 03.12.2021.
//

import UIKit
import RxSwift

class ReactiveCollectionViewCell<ViewModel>: BaseCollectionViewCell where ViewModel: BaseViewModel {
    // MARK: - Public Properties
    var viewModel: ViewModel!
    
    // MARK: - Public Methods
    func setup() {
        viewModel.initialize()
        applyBindings()
    }
    
    func applyBindings() { }
}
