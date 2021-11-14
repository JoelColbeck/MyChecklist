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
    private let presenter: UIViewController
    
    // MARK: - Initializers
    init(presenter: UIViewController) {
        self.presenter = presenter
        super.init()
    }
    
    // MARK: - Public Methods
    override func start() -> Single<Void> {
        let viewController = SurveyViewController()
        viewController.dataContext = viewModel
        
        presenter.show(viewController, sender: presenter)
        return .create()
    }
}
