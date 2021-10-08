//
//  ChecklistCoordinator.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation
import RxSwift

class ChecklistCoordinator: BaseParameterCoordinator<User> {
    
    private let viewModel = ChecklistViewModel()
    
    override func start(parameter: Parameter) -> Single<Void> {
        let viewController = ChecklistViewController()
        viewController.dataContext = viewModel
        
        return .create { [unowned self] obs in
            viewModel.closed
                .bind {
                    navigationController.popViewController(animated: true)
                    obs(.success(()))
                }
        }
    }
}
