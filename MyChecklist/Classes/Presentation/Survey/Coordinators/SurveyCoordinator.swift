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
        // TODO: Disable interactive dismissal of VC
        // Uncomment this line
//        viewController.isModalInPresentation = true
        
        navigationController.present(viewController, animated: true)
        return .create { [unowned self] obs in
            viewModel.closed.bind {
                obs(.success(()))
            }
        }
    }
}
