//
//  TestAnchorService.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation
import RxSwift

final class TestAnchorService {
    init() throws {
        guard let testAnchorsUrl = Bundle.main
            .url(forResource: "testAnchors", withExtension: "json") else {
            throw TestAnchorServiceError.resourceIsNotFound
        }
        
        let data = try Data(contentsOf: testAnchorsUrl)
        
        testAnchors = try JSONDecoder().decode(type(of: testAnchors), from: data)
    }
    
    private let testAnchors: [TestAnchor]
}

enum TestAnchorServiceError: Error {
    case resourceIsNotFound
}
