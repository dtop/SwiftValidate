//
//  ValidatorSmallerThanTests.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

class ValidatorSmallerThanTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorCanHandleInt() {
        
        let _ = ValidatorSmallerThan<Int>()
        
        let validator = ValidatorSmallerThan<Int>() {
            $0.max = 10
        }
        
        var result = false
        
        do {
            
            result = try validator.validate(9, context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate(11, context: nil)
            XCTAssertFalse(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleFloat() {
        
        let validator = ValidatorSmallerThan<Float>() {
            $0.max = 10.0
        }
        
        var result = false
        
        do {
            
            result = try validator.validate(Float(11.4), context: nil)
            XCTAssertFalse(result)
            
            XCTAssertTrue(validator.errors.contains(String(format: validator.errorMessageNotSmallerThan, String(validator.max))))
            
            result = try validator.validate(Float(9.1), context: nil)
            XCTAssertTrue(result)
            
            XCTAssertFalse(validator.errors.contains(String(format: validator.errorMessageNotSmallerThan, String(validator.max))))
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleDouble() {
        
        let validator = ValidatorSmallerThan<Double>() {
            $0.max = 10.0
        }
        
        var result = false
        
        do {
            
            result = try validator.validate(9.9, context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate(11.1, context: nil)
            XCTAssertFalse(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorRespectsInclusive() {
        
        let validator = ValidatorSmallerThan<Int>() {
            $0.max = 10
            $0.inclusive = true
        }
        
        var result = false
        
        do {
            
            result = try validator.validate(10, context: nil)
            XCTAssertTrue(result)
            
            validator.inclusive = false
            
            result = try validator.validate(10, context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleIntAsString() {
        
        let validator = ValidatorSmallerThan<Int>() {
            $0.max = 10
        }
        
        var result = false
        
        do {
            
            result = try validator.validate("9", context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate("11", context: nil)
            XCTAssertFalse(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleDoubleAsString() {
        
        let validator = ValidatorSmallerThan<Double>() {
            $0.max = 10.0
        }
        
        var result = false
        
        do {
            
            result = try validator.validate("9.9", context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate("11.1", context: nil)
            XCTAssertFalse(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleNil() {
        
        let validator = ValidatorSmallerThan<Double>() {
            $0.max = 10.0
        }
        
        var result = false
        
        do {
            
            let value: Double? = nil
            result = try validator.validate(value, context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorThrowsOnIllegalValue() {
        
        let validator = ValidatorSmallerThan<Double>() {
            $0.max = 10.0
        }
        
        do {
            
            try validator.validate(true, context: nil)
            XCTAssert(false, "may never be reached")
            
        } catch let error as NSError {
            
            XCTAssertEqual("invalid type - not compatible to string or SignedNumberType", error.localizedDescription)
        }
    }
    
    func testValidatorThrowsOnIllegalValueAsString() {
        
        let validator = ValidatorSmallerThan<Double>() {
            $0.max = 10.0
        }
        
        do {
            
            try validator.validate("A456", context: nil)
            XCTAssert(false, "may never be reached")
            
        } catch let error as NSError {
            
            XCTAssertEqual("invalid type - not compatible to string or SignedNumberType", error.localizedDescription)
        }
    }
}
