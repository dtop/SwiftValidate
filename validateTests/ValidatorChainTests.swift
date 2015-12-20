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
    
    /**
     Tests if the validation chain can be used
     */
    func testChainCanBeSetuped() {

        let chain = ValidatorChain() {
            $0.stopOnException = true
            $0.stopOnFirstError = false
        } <<< MockValidator() {
            $0.someSetting = true
        }
        
        XCTAssertTrue(chain.stopOnException)
        XCTAssertFalse(chain.stopOnFirstError)
        XCTAssertTrue(chain.validate(true, context: nil))
        XCTAssertFalse(chain.validate(false, context: nil))
    }
}
