//
//  UserService.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation
import Moya
import RxSwift

protocol UserFetchable {
    func getUsers(byId id: String) -> Single<[User]>
}

class UserService {
    let provider = UserApiMethod.provider
}

extension UserService: UserFetchable {
    func getUsers(byId id: String) -> Single<[User]> {
        provider.rx.request(.getUsers(id: id))
            .catch { error in
                print(error.localizedDescription)
                return .error(error)
            }
            .map([User].self)
    }
}
