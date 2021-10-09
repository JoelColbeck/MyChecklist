//
//  TestService.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation

final class TestService {
    // MARK: - Public Properties
    static let shared = TestService()
    
    private(set) lazy var testAnchors = decodeTestAnchors()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Private Methods
    private func decodeTestAnchors() -> [String : TestAnchor] {
        let decoder = JSONDecoder()
        guard let data = testAnchorJSON.data(using: .utf8) else { return [:] }
        
        do {
            let anchors = try decoder.decode([TestAnchor].self, from: data)
            
            var result: [String: TestAnchor] = [:]
            
            for anchor in anchors {
                result[anchor.testAnchor] = anchor
            }
            
            return result
        } catch {
            print(error.localizedDescription)
        }
        
        return [:]
    }
}
