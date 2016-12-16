//
//  ValidatorRegexTests.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

class ValidatorRegexTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorCanHandleValidValue() {
        
        // code coverage
        let _ = ValidatorRegex()
        
        let validator = ValidatorRegex() {
            $0.pattern = "^\\d{3}[-]\\d{2}[-]\\d{4}$"
        }
        
        do {
            
            let result = try validator.validate("555-44-9548", context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleInvalidValue() {
        
        let validator = ValidatorRegex() {
            $0.pattern = "^\\d{3}[-]\\d{2}[-]\\d{4}$"
        }
        
        do {
            
            let result = try validator.validate("555-4A-9548", context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorThrowsIfNoPatternIsGiven() {
        
        let validator = ValidatorRegex() {
            $0.allowNil = true
        }
        
        do {
            
            let _ = try validator.validate("test", context: nil)
            XCTAssert(false, "may never be reached")
            
        } catch let error as NSError {
            XCTAssertEqual("No pattern given for matching", error.localizedDescription)
        }
    }
    
    func testValidatorCanHandleNil() {
        
        let validator = ValidatorRegex() {
            $0.pattern = "^\\d{3}[-]\\d{2}[-]\\d{4}$"
        }
        
        do {
            
            let value: String? = nil
            let result = try validator.validate(value, context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorThrowsOnIllegalValueType() {
        
        let validator = ValidatorRegex() {
            $0.pattern = "^\\d{3}[-]\\d{2}[-]\\d{4}$"
        }
        
        do {
            
            let _ = try validator.validate(453534.56, context: nil)
            XCTAssert(false, "may never be reached")
            
        } catch let error as NSError {
            XCTAssertEqual("Unknown or nil value type to match against", error.localizedDescription)
        }
    }
}
