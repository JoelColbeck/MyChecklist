//
//  SurveyCoordinator.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 14.11.2021.
//

import Foundation
import RxSwift

final class SurveyCoordinator: BaseCoordinator {
    
    // MARK: - Private Properties
    private let viewModel = SurveyViewModel()
    
    // MARK: - Public Methods
    override func start() -> Single<Void> {
        let viewController = SurveyViewController()
        viewController.dataContext = viewModel
        
        viewController.modalPresentationStyle = .pageSheet
        
        navigationController.present(viewController, animated: true)
        return .create { [unowned self] obs in
            viewModel.closed.bind {
                obs(.success(()))
            }
        }
    }
}
