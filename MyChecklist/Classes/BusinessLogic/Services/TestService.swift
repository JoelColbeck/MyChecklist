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
    private func decodeTestAnchors() -> [TestAnchor] {
        let decoder = JSONDecoder()
        guard let data = testAnchorJSON.data(using: .utf8) else { return [] }
        
        do {
            let result = try decoder.decode([TestAnchor].self, from: data)
            
            return result
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}
