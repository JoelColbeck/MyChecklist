//
//  AuthViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import Foundation
import RxRelay

class AuthViewModel: BaseViewModel {
    let closed = PublishRelay<Void>()
    let sendCodePublisher = PublishRelay<String>()
    
    override func applyBinding() {
        sendCodePublisher
            .subscribe(onNext: { code in
                print(code)
            })
            .disposed(by: bag)
    }
}
