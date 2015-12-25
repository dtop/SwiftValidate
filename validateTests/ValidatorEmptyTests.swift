//
//  ValidatorEmptyTests.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import validate

class ValidatorEmptyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorHandlesNil() {
        
        // prequisites
        
        let testValue: String? = nil
        var result: Bool       = false
        
        let validator = ValidatorEmpty() {
            $0.allowNil = false
        }
        
        do {
            
            // test nil value
            result = try validator.validate(testValue, context: nil)
            XCTAssertFalse(result)
            
            validator.allowNil = true
            
            result = try validator.validate(testValue, context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorWorksProperly() {

        // prequisites
        
        var testValue: String? = nil
        var result: Bool       = false
        
        let validator = ValidatorEmpty() {
            $0.allowNil = false
        }
        
        do {
            
            // test non nil but empty
            testValue = ""
            result = try validator.validate(testValue, context: nil)
            XCTAssertFalse(result)
            
            // test non nil but empty
            testValue = "foo"
            result = try validator.validate(testValue, context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
}
