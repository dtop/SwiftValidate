//
//  ValidatorBetweenTests.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

class ValidatorBetweenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorChecksBetweeningOfValuesWithDouble() {

        // code coverage
        let _ = ValidatorBetween<Int>()
        
        let validator = ValidatorBetween<Double>() {
            $0.minValue = 5.0
            $0.maxValue = 10.0
            
            $0.maxInclusive = true
            $0.minInclusive = false
        }
        
        var result: Bool = true
        
        do {
            
            // ok
            result = try validator.validate(9.9, context: nil)
            XCTAssertTrue(result)
            
            // min not inclusive - must fail!
            result = try validator.validate(5.0, context: nil)
            XCTAssertFalse(result)
            
            XCTAssertTrue(validator.errors.contains(validator.errorMessageNotBetween))
            
            // max inclusive - must pass
            result = try validator.validate(Double(10), context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorChecksBetweeningOfValuesWithInt() {
        
        let validator = ValidatorBetween<Int>() {
            $0.minValue = 1
            $0.maxValue = 3
            
            $0.maxInclusive = false
            $0.minInclusive = true
        }
        
        var result: Bool = true
        
        do {
            
            // ok
            result = try validator.validate(2, context: nil)
            XCTAssertTrue(result)
            
            // min inclusive - must pass!
            result = try validator.validate(1, context: nil)
            XCTAssertTrue(result)
            
            // max not inclusive - must fail!
            result = try validator.validate(3, context: nil)
            XCTAssertFalse(result)
            
            XCTAssertTrue(validator.errors.contains(validator.errorMessageNotBetween))
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorChecksBetweeningOfValuesWithStringDouble() {
        
        let validator = ValidatorBetween<Double>() {
            $0.minValue = 5.0
            $0.maxValue = 10.0
            
            $0.maxInclusive = true
            $0.minInclusive = false
        }
        
        var result: Bool = true
        
        do {
            
            // ok
            result = try validator.validate("9.9", context: nil)
            XCTAssertTrue(result)
            
            // min not inclusive - must fail!
            result = try validator.validate("5.0", context: nil)
            XCTAssertFalse(result)
            
            XCTAssertTrue(validator.errors.contains(validator.errorMessageNotBetween))
            
            // max inclusive - must pass
            result = try validator.validate("10", context: nil)
            XCTAssertTrue(result)
            
            XCTAssertFalse(validator.errors.contains(validator.errorMessageNotBetween))
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorChecksBetweeningOfValuesWithStringInt() {
        
        let validator = ValidatorBetween<Int>() {
            $0.minValue = 1
            $0.maxValue = 3
            
            $0.maxInclusive = false
            $0.minInclusive = true
            
            $0.allowString = false
        }
        
        var result: Bool = true
        
        do {
            
            // strings not allowed - must fail!
            result = try validator.validate("2", context: nil)
            XCTAssertFalse(result)
            
            XCTAssertTrue(validator.errors.contains(validator.errorMessageInvalidType))
            
            validator.allowString = true
            
            // ok
            result = try validator.validate("2", context: nil)
            XCTAssertTrue(result)
            
            // min inclusive - must pass!
            result = try validator.validate("1", context: nil)
            XCTAssertTrue(result)
            
            // max not inclusive - must fail!
            result = try validator.validate("3", context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorShouldHandleNil() {
        
        let validator = ValidatorBetween<Double>() {
            $0.minValue = 5.0
            $0.maxValue = 10.0
            
            $0.maxInclusive = true
            $0.minInclusive = false
        }
        
        do {
            let str: String? = nil
            try validator.validate(str, context: nil)
            
        } catch _ {
            
            XCTAssert(false)
        }
    }
    
    func testValidatorShouldThrowOnInvalidType() {
        
        let validator = ValidatorBetween<Double>() {
            $0.minValue = 5.0
            $0.maxValue = 10.0
            
            $0.maxInclusive = true
            $0.minInclusive = false
        }
        
        do {
            
            try validator.validate(true, context: nil)
            
        } catch let error as NSError {
            
            XCTAssertEqual("invalid type - not compatible to string or SignedNumberType", error.localizedDescription)
        }
    }
    
    func testValidatorShouldThrowOnInvalidTypeAsString() {
        
        let validator = ValidatorBetween<Double>() {
            $0.minValue = 5.0
            $0.maxValue = 10.0
            
            $0.maxInclusive = true
            $0.minInclusive = false
        }
        
        do {
            
            try validator.validate("true", context: nil)
            
        } catch let error as NSError {
            
            XCTAssertEqual("invalid type - not compatible to string or SignedNumberType", error.localizedDescription)
        }
    }
}
