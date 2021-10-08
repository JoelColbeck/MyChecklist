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
