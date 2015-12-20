//
//  ValidatorGreaterThanTests.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import validate

class ValidatorGreaterThanTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorCanHandleInt() {
        
        let validator = ValidatorGreaterThan<Int>() {
            $0.min = 10
        }
        
        var result = false
        
        do {
           
            result = try validator.validate(9, context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate(11, context: nil)
            XCTAssertTrue(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleFloat() {
        
        let validator = ValidatorGreaterThan<Float>() {
            $0.min = 10.0
        }
        
        var result = false
        
        do {
            
            result = try validator.validate(Float(9.1), context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate(Float(11.4), context: nil)
            XCTAssertTrue(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleDouble() {
        
        let validator = ValidatorGreaterThan<Double>() {
            $0.min = 10.0
        }
        
        var result = false
        
        do {
            
            result = try validator.validate(9.9, context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate(11.1, context: nil)
            XCTAssertTrue(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorRespectsInclusive() {
        
        let validator = ValidatorGreaterThan<Int>() {
            $0.min = 10
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
        
        let validator = ValidatorGreaterThan<Int>() {
            $0.min = 10
        }
        
        var result = false
        
        do {
            
            result = try validator.validate("9", context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate("11", context: nil)
            XCTAssertTrue(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleDoubleAsString() {
        
        let validator = ValidatorGreaterThan<Double>() {
            $0.min = 10.0
        }
        
        var result = false
        
        do {
            
            result = try validator.validate("9.9", context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate("11.1", context: nil)
            XCTAssertTrue(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
}
