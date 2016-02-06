//
//  validateTests.swift
//  validateTests
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

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

        // code coverage
        let _ = ValidatorChain()
        
        let chain = ValidatorChain() {
            $0.stopOnException = true
            $0.stopOnFirstError = false
        } <~~ MockValidator() {
            $0.throwException = false
            $0.returnValue = true
        }
        
        XCTAssertTrue(chain.validate(true, context: nil))
        
        guard let validator: MockValidator = chain.getValidator(0) else {
            XCTAssert(false, "could not retreive validator")
            return
        }
        
        validator.returnValue = false
        XCTAssertFalse(chain.validate(false, context: nil))
    }
    
    func testValidatorsCanBeRegained() {
        
        let chain = ValidatorChain() {
            $0.stopOnException = true
            $0.stopOnFirstError = false
            } <~~ MockValidator() {
                $0.throwException = false
                $0.returnValue = true
        }
        
        guard let _: MockValidator = chain.getValidator(0) else {
            XCTAssert(false, "could not retreive validator")
            return
        }
        
        if let _: String = chain.getValidator(0) {
            XCTAssert(false, "may never be reached")
        }
        
        if let _: MockValidator = chain.getValidator(26) {
            XCTAssert(false, "may never be reached")
        }
    }
    
    func testChainHandlesExceptions() {
        
        let chain = ValidatorChain() {
            $0.stopOnException = true
            $0.stopOnFirstError = true
        } <~~ MockValidator() {
            $0.throwException = true
        }
        
        chain.validate(false, context: nil)
        XCTAssertTrue(chain.errors.contains("Exception Thrown"))
    }
    
    func testChainHandlesExceptionsIfNotFirst() {
        
        let chain = ValidatorChain() {
            $0.stopOnException = false
            $0.stopOnFirstError = false
        }
        <~~ MockValidator() {
            $0.throwException = true
            $0.returnValue = false
        }
        <~~ MockValidator() {
            $0.throwException = false
            $0.returnValue = true
        }
    
        chain.validate(false, context: nil)
        XCTAssertTrue(chain.errors.contains("Exception Thrown"))
    }
    
}
