//
//  TestService.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation
import RxSwift

final class TestService {
    // MARK: - Public Properties
    static let shared = TestService()
    
    private(set) lazy var testAnchors = decodeTestAnchors()
    private let bag = DisposeBag()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func getData() {
        fetchTestAnchors()
    }
    
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
    
    private func fetchTestAnchors() {
        let service = UserService()
        
        service.getAnchors()
            .debug("GettingAchors")
            .subscribe(onSuccess: { [unowned self] anchors in
                var result: [String: TestAnchor] = [:]
                
                for anchor in anchors {
                    result[anchor.testAnchor] = anchor
                }
                
                self.testAnchors = result
            })
            .disposed(by: bag)
    }
}
