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
        
        applyBindings()
        
        return .create { [unowned self] obs in
            viewModel.closed
                .bind {
                    navigationController.popViewController(animated: true)
                    obs(.success(()))
                }
        }
    }
    
    private func applyBindings() {
        viewModel.userChecklistPublisher
            .debug("User Fetched", trimOutput: true)
            .subscribe(onNext: { [unowned self] user in
                openChecklistScene(user: user)
            })
            .disposed(by: bag)
    }
    
    private func openChecklistScene(user: User) {
        let coordinator = ChecklistCoordinator()
        coordinator.navigationController = navigationController
        start(coordinator: coordinator, parameter: user)
    }
}
