//
//  User.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation

struct User: Codable {
    let id: String
    let username: String
    let survey: String
    let tests: [Test]
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username, survey, tests, createdAt, updatedAt
    }
    
    static let preview = User(id: "1234",
                              username: "sdfff",
                              survey: "{\"gender\":\"woman\",\"age\":\"45\",\"weight\":110,\"height\":180,\"smoking-question\":\"smokingNow\",\"question3\":\"heavyDrinker\",\"bloodPressureTop\":150,\"bloodPressureLow\":90,\"high cholesterol\":[\"yes\"],\"diabetes\":[\"yes\"],\"colonCancerWoman\":[\"true\"],\"lungsCancerWoman\":[\"true\"],\"melanomaWoman\":[\"true\"],\"cervicalCancerWoman\":[\"true\"],\"colonCancerDetails\":\"lessthan60\",\"bmi\":33.95061728395061}",
                              tests: [
                                .init(years: [2023, 2024], id: "0", testAnchor: "cholesterolTest"),
                                .init(years: [2023, 2025], id: "1", testAnchor: "hiv")
                              ],
                              createdAt: "2021", updatedAt: "2021")
}

// MARK: - Test
struct Test: Codable {
    let years: [Int]
    let id, testAnchor: String

    enum CodingKeys: String, CodingKey {
        case years
        case id = "_id"
        case testAnchor
    }
}

struct UserModel {
    let id: String
    let username: String
    let tests: [Test]
    let createdAt: String
    let info: [String: Any]
    
    init(
        id: String,
        username: String,
        tests: [Test],
        createdAt: String,
        info: [String : Any]
    ) {
        self.id = id
        self.username = username
        self.tests = tests
        self.createdAt = createdAt
        self.info = info
    }
    
    init(fromUser user: User) {
        self.id = user.id
        self.username = user.username
        self.createdAt = user.createdAt
        self.tests = user.tests
        self.info = Self.surveyToInfo(user.survey)
    }
    
    private static func surveyToInfo(_ survey: String) -> [String: Any] {
        var info: [String: Any] = [:]
        
        do {
            let result = try JSONSerialization
                .jsonObject(with: survey.data(using: .utf8)!,
                            options: .mutableContainers) as! NSDictionary
            
            info = result as? [String : Any] ?? [:]
            
        } catch {
            print(error.localizedDescription)
        }
        
        return info
    }
}
