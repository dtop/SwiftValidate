//
//  ValidatorDateTimeTests.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

class ValidatorDateTimeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorCanHandleNSDate() {
        
        let validator = ValidatorDateTime()
        
        do {
            
            let result = try validator.validate(NSDate(), context: nil)
            XCTAssertTrue(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleDateString() {
        
        let validator = ValidatorDateTime() {
            $0.dateFormat = "yyyy-MM-dd"
        }
        
        let myDate = "2020-01-22"
        
        do {
            
            let result = try validator.validate(myDate, context: nil)
            XCTAssertTrue(result)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleIllegalValues() {
        
        let validator = ValidatorDateTime()
        
        let myInvalidDate = "42432342abc3423423424"
        
        do {
            
            let result = try validator.validate(myInvalidDate, context: nil)
            XCTAssertFalse(result)
        } catch _ {
            XCTAssert(false)
        }
    }
}
