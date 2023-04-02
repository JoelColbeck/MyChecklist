//
//  TestAnchorJSON.swift
//  MyPlan
//
//  Created by Башир Арсланалиев on 25.05.2021.
//

import Foundation

struct TestAnchor: Decodable {
    let testAnchor: String
    let conditions: [Condition]
    let frequencies: [Frequency]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        testAnchor = try container.decode(type(of: testAnchor), forKey: .testAnchor)
        conditions = try container.decode(type(of: conditions), forKey: .conditions)

        if let repeatFrequencies = try? container
            .decode([RepeatFrequency].self, forKey: .frequencies) {
            frequencies = repeatFrequencies
        } else if let oneTimeFrequencies = try? container
            .decode([OneTimeFrequency].self, forKey: .frequencies) {
            frequencies = oneTimeFrequencies
        } else {
            throw TestAnchorError.frequencyParseError
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case testAnchor
        case conditions
        case frequencies
    }
}

enum TestAnchorError: Error {
    case frequencyParseError
}

struct Condition: Decodable {
    let questionId: String
    let type: ConditionType
    let answer: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.questionId = try container.decode(String.self, forKey: .questionId)
        self.type = (try? container.decode(Condition.ConditionType.self, forKey: .type)) ?? .equal
        self.answer = try container.decode(String.self, forKey: .answer)
    }
    
    enum ConditionType: String, Decodable {
        case equal
        case lessThan
        case lessThanOrEqual
        case moreThan
        case moreThanOrEqual
    }
    
    private enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case type
        case answer
    }
}

protocol Frequency: Decodable {}

struct RepeatFrequency: Frequency {
    let repeatEvery: UInt
    let startAge: UInt?
    let endAge: UInt?
}

struct OneTimeFrequency: Frequency {
    let oneTime: UInt
}

enum Importance: String, Codable {
    case high = "importanceHigh"
    case medium = "importanceMed"
    case low = "importanceLow"
    
    var description: String {
        switch self {
        case .high:
            return "Важно"
        case .medium:
            return "Желательно"
        case .low:
            return "На усмотрение"
        }
    }
    
    var imageName: String {
        switch self {
        case .high:
            return "importanceHigh"
        case .medium:
            return "importanceMed"
        case .low:
            return "importanceLow"
        }
    }
}
