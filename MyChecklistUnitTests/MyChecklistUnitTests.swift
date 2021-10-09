//
//  MyChecklistUnitTests.swift
//  MyChecklistUnitTests
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import XCTest
@testable import MyChecklist

class MyChecklistUnitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTestServiceHasAnchors() throws {
        let service = TestService.shared
        let exampleAnchor = "hiv"
        
        let resultElem = service.testAnchors[exampleAnchor]
        
        XCTAssert(!service.testAnchors.isEmpty)
        XCTAssertEqual(resultElem?.testName, "Тест на вирус имуннодифицита человека")
    }
}
