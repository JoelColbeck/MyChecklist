//
//  UserApiMethod.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 07.10.2021.
//

import Foundation
import Moya

enum UserApiMethod {
    static let provider = MoyaProvider<Self>(plugins: [NetworkLoggingPlugin()])
    
    case getUsers(id: String)
}

extension UserApiMethod: TargetType {
    var baseURL: URL { URL(string: appBaseUrl)! }
    
    var path: String {
        switch self {
        case .getUsers(let id):
            return "users/\(id)"
        }
    }
    
    var task: Task {
        switch self {
        case .getUsers:
            return .requestPlain
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUsers:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        nil
    }
    
}
