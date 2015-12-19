//
//  validateTests.swift
//  validateTests
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import validate

class ValidatorChainTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChainCanBeSetuped() {

        let chain = ValidatorChain() {
            $0.stopOnException = true
            $0.stopOnFirstError = false
        }
        
        XCTAssertTrue(chain.stopOnException)
        XCTAssertFalse(chain.stopOnFirstError)
    }
    
}
