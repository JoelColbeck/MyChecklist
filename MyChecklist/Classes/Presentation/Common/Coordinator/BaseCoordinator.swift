//
//  BaseCoordinator.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import Foundation
import UIKit
import RxSwift

// MARK: - Protocols
protocol AnyCoordinatable {
    var identifier: UUID { get }
    var navigationController: UINavigationController { get }
    func start(coordinator: AnyCoordinatable) -> Single<Void>
    func start<Coordinator: ResultCoordinatable>(coordinator: Coordinator) -> Single<Coordinator.Result>
    func start<Coordinator: ParameterCoordinatable>(coordinator: Coordinator, parameter: Coordinator.Parameter) -> Single<Void>
    func start<Coordinator: ParameterResultCoordinatable>(
        coordinator: Coordinator,
        parameter: Coordinator.Parameter) -> Single<Coordinator.Result>
    func start() -> Single<Void>
}


protocol ResultCoordinatable: AnyCoordinatable {
    associatedtype Result
    func start() -> Single<Result>
}


protocol ParameterCoordinatable: AnyCoordinatable {
    associatedtype Parameter
    func start(parameter: Parameter) -> Single<Void>
}


protocol ParameterResultCoordinatable: AnyCoordinatable {
    associatedtype Result
    associatedtype Parameter
    func start(parameter: Parameter) -> Single<Result>
}


// MARK: - Base Implementations
class BaseCoordinator: AnyCoordinatable {
    var navigationController: UINavigationController = CommonNavigationController()
    let identifier = UUID()
    var bag = DisposeBag()
    
    private var childCoordinators = [AnyCoordinatable]()
    
    @discardableResult
    func start() -> Single<Void> {
        fatalError("Start method should be implemented.")
    }
    
    @discardableResult
    func start(coordinator: AnyCoordinatable) -> Single<Void> {
        store(coordinator: coordinator)
        let result = coordinator.start()
        result.subscribe(onSuccess: { [weak self] _ in
            self?.release(coordinator: coordinator)
        }, onError: { [weak self] _ in
            self?.release(coordinator: coordinator)
        }).disposed(by: bag)
        return result
    }
    
    @discardableResult
    func start<Coordinator>(coordinator: Coordinator) -> Single<Coordinator.Result>
        where Coordinator: ResultCoordinatable {
        store(coordinator: coordinator)
        let result = coordinator.start()
        result.subscribe(onSuccess: { [weak self] _ in
            self?.release(coordinator: coordinator)
        }, onError: { [weak self] _ in
            self?.release(coordinator: coordinator)
        }).disposed(by: bag)
        return result
    }
    
    @discardableResult
    func start<Coordinator>(coordinator: Coordinator, parameter: Coordinator.Parameter) -> Single<Void>
        where Coordinator: ParameterCoordinatable {
        store(coordinator: coordinator)
        let result = coordinator.start(parameter: parameter)
        result.subscribe(onSuccess: { [weak self] _ in
            self?.release(coordinator: coordinator)
        }, onError: { [weak self] _ in
            self?.release(coordinator: coordinator)
        }).disposed(by: bag)
        return result
    }
    
    @discardableResult
    func start<Coordinator>(coordinator: Coordinator, parameter: Coordinator.Parameter) -> Single<Coordinator.Result>
        where Coordinator: ParameterResultCoordinatable {
        store(coordinator: coordinator)
        return coordinator.start(parameter: parameter)
            .do(onSuccess: { [weak self] _ in
                self?.release(coordinator: coordinator)
            }, onError: { [weak self] _ in
                self?.release(coordinator: coordinator)
            })
    }
    
    func store(coordinator: AnyCoordinatable) {
        childCoordinators.append(coordinator)
    }
    
    func release(coordinator: AnyCoordinatable? = nil) {
        if let coordinator = coordinator {
            childCoordinators.removeAll(where: { coordinator.identifier == $0.identifier })
        } else {
            childCoordinators.removeAll()
        }
    }
    
    deinit {
        #if DEBUG
        print("deinit of " + String(describing: self))
        #endif
    }
}


class BaseResultCoordinator<ResultType>: BaseCoordinator, ResultCoordinatable {
    typealias Result = ResultType
    
    @discardableResult
    override func start() -> Single<Void> {
        fatalError("You should use start()->Single<Result> method")
    }
    
    @discardableResult
    func start() -> Single<Result> {
        fatalError("Start method should be implemented.")
    }
}


class BaseParameterCoordinator<ParameterType>: BaseCoordinator, ParameterCoordinatable {
    typealias Parameter = ParameterType
    
    @discardableResult
    override func start() -> Single<Void> {
        fatalError("You should use start(parameter:) method")
    }
    
    @discardableResult
    func start(parameter: Parameter) -> Single<Void> {
        fatalError("Start method should be implemented.")
    }
}


class BaseParameterResultCoordinator<ParameterType, ResultType>: BaseCoordinator, ParameterResultCoordinatable {
    typealias Parameter = ParameterType
    typealias Result = ResultType
    
    @discardableResult
    override func start() -> Single<Void> {
        fatalError("You should use start(parameter:)->Single<Result> method")
    }
    
    @discardableResult
    func start(parameter: Parameter) -> Single<Result> {
        fatalError("Start method should be implemented.")
    }
}

