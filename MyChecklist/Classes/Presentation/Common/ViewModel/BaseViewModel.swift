//
//  BaseViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 10.01.2022.
//

import Foundation
import RxSwift

class BaseViewModel {
    // MARK: - Public properties
    let isLoading = BehaviorSubject(value: false)
    let bag = DisposeBag()
    
    // MARK: - Public methods
    func initialize() {
        applyBinding()
    }
    
    func viewCreated() { }
    
    func viewDidAppear() { }
    
    func viewWillAppear() { }
    
    func viewDidDisappear() { }
    
    func viewWillDisappear() { }

    func applyBinding() {}
    
    deinit {
        #if DEBUG
        print("deinit of " + String(describing: self))
        #endif
    }
}
