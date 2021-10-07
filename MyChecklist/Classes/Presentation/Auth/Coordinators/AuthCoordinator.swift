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
        let viewController = AuthViewController()
        viewController.dataContext = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
        
        return .create { [unowned self] obs in
            viewModel.closed
                .bind {
                    navigationController.popViewController(animated: true)
                    obs(.success(()))
                }
        }
    }
}
