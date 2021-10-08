//
//  AuthViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import Foundation
import RxRelay

class AuthViewModel: BaseViewModel {
    
    // MARK: - Public Methods
    let closed = PublishRelay<Void>()
    let sendCodePublisher = PublishRelay<String>()
    let errorPublisher = PublishRelay<String>()
    let userChecklistPublisher = PublishRelay<User>()
    
    // MARK: - Private Properties
    private let userService: UserFetchable
    
    // MARK: - LC
    init(
        userService: UserFetchable = UserService()
    ) {
        self.userService = userService
    }
    
    override func applyBinding() {
        sendCodePublisher
            .subscribe(onNext: { [unowned self] code in
                getUser(byId: code)
            })
            .disposed(by: bag)
    }
    
    // MARK: - Private Methods
    private func getUser(byId id: String) {
        userService.getUsers(byId: id)
            .subscribe(onSuccess: { [unowned self] users in
                if users.isEmpty {
                    errorPublisher.accept("Не смогли найти чеклист с таким пином")
                } else {
                    userChecklistPublisher.accept(users.first!)
                }
            }, onFailure: { [unowned self] _ in
                errorPublisher.accept("Что-то пошло не так")
            })
            .disposed(by: bag)
    }
}
