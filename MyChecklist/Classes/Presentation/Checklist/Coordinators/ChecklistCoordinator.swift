//
//  ChecklistCoordinator.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation
import RxSwift

class ChecklistCoordinator: BaseParameterCoordinator<User> {
    
    private var viewModel: ChecklistViewModel!
    
    override func start(parameter: Parameter) -> Single<Void> {
        viewModel = .init(user: parameter)
        
        let viewController = ChecklistViewController()
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
