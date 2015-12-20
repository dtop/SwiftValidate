//
//  ValidatorNumericTests.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import validate

class ValidatorNumericTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorHandlesNumbers() {

        let validator = ValidatorNumeric() {
            $0.canBeString = false
            $0.allowFloatingPoint = true
        }
        
        var result: Bool = true
        
        do {
            
            // test int
            result = try validator.validate(12345, context: nil)
            XCTAssertTrue(result)
            
            // test double
            result = try validator.validate(1234.432, context: nil)
            XCTAssertTrue(result)
            
            validator.allowFloatingPoint = false
            
            // test double again
            result = try validator.validate(1234.432, context: nil)
            XCTAssertFalse(result)
            
            // test numerical string
            result = try validator.validate("2342424", context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorHandlesStrings() {
        
        let validator = ValidatorNumeric() {
            $0.canBeString = true
            $0.allowFloatingPoint = true
        }
        
        var result: Bool = true
        let testValue: String? = nil
        
        do {
            
            // test nil
            result = try validator.validate(testValue, context: nil)
            XCTAssertFalse(result)
            
            // test empty string
            result = try validator.validate("", context: nil)
            XCTAssertFalse(result)
            
            // test double again
            result = try validator.validate("1234.432", context: nil)
            XCTAssertTrue(result)
            
            // test numerical string
            result = try validator.validate("2342424", context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
}
