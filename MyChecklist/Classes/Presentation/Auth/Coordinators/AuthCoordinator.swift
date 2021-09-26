//
//  AuthCoordinator.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import Foundation
import RxSwift

class AuthCoordinator: BaseCoordinator {
    
    let viewModel = AuthViewModel()
    
    override func start() -> Single<Void> {
        
        return .create()
    }
}
