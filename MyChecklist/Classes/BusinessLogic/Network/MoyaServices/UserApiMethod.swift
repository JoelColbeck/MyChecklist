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
    case getAnchors
}

extension UserApiMethod: TargetType {
    var baseURL: URL {
        switch self {
        case .getUsers(let id):
            return URL(string: appBaseUrl)!
            
        case .getAnchors:
            return URL(string: "https://dl.dropboxusercontent.com/")!
        }
        
        
    }
    
    var path: String {
        switch self {
        case .getUsers(let id):
            return "users/\(id)"
        case .getAnchors:
            return "s/x1md9hxaugtkbz3/testAnchors.json"
        }
    }
    
    var task: Task {
        switch self {
        case .getUsers:
            return .requestPlain
        case .getAnchors:
            return .requestPlain
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUsers:
            return .get
        case .getAnchors:
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
