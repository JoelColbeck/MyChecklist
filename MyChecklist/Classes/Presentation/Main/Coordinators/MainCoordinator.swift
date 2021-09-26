//
//  MainCoordinator.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import Foundation
import RxSwift

class MainCoordinator: BaseCoordinator {
    
    override func start() -> Single<Void> {
        
        return .create()
    }
}
