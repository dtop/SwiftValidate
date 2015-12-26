//
//  ValidatorInArrayTests.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

class ValidatorInArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorCanValidateDouble() {
        
        let validator = ValidatorInArray<Double>() {
            $0.allowNil = false
            $0.array = [2.4, 3.1, 9.8, 4.9, 2.0]
        }
        
        var result: Bool = false
        
        do {
            
            result = try validator.validate(3.1, context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate(3.0, context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanValidateString() {
        
        let validator = ValidatorInArray<String>() {
            $0.allowNil = false
            $0.array = ["Andrew", "Bob", "Cole", "Dan", "Edwin"]
        }
        
        var result: Bool = false
        
        do {
            
            result = try validator.validate("Cole", context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate("Fred", context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanCrossValidateDoubleString() {
        
        let validator = ValidatorInArray<Double>() {
            $0.allowNil = false
            $0.array = [2.4, 3.1, 9.8, 4.9, 2.0]
        }
        
        var result: Bool = false
        
        do {
            
            result = try validator.validate("3.1", context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate("3.0", context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
}
