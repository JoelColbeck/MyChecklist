//
//  MainCoordinator.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import Foundation
import RxSwift
import UIKit

class MainCoordinator: BaseCoordinator {
    private let viewModel = MainViewModel()
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    @discardableResult
    override func start() -> Single<Void> {
        let viewController = MainViewController()
        viewController.dataContext = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
        
        window.setRoot(viewController: navigationController, withAnimation: true)
        
        return .never()
    }
}
