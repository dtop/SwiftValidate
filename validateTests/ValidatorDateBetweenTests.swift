//
//  ValidatorDateBetweenTests.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import validate

class ValidatorDateBetweenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorCanHandleNSDateValue() {
        
        let validator = ValidatorDateBetween() {
            $0.allowNil = false
            $0.min = NSDate(timeIntervalSince1970: 0)
            $0.max = NSDate(timeIntervalSince1970: 86400)
            $0.maxInclusive = true
            $0.minInclusive = true
        }
        
        var result: Bool = false
        
        do {
            
            result = try validator.validate(NSDate(timeIntervalSince1970: 13420), context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate(NSDate(timeIntervalSince1970: 87459), context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleStringValue() {
        
        // tests if you were born in the eighties ;-)
        
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let validator = ValidatorDateBetween() {
            $0.allowNil = false
            $0.min = df.dateFromString("1980-01-01")
            $0.max = df.dateFromString("1990-01-01")
            $0.maxInclusive = false
            $0.minInclusive = true
            $0.dateFormatter = df
        }
        
        var result: Bool = false
        
        do {
            
            result = try validator.validate("1982-03-30", context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate("1994-10-22", context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate("1990-01-01", context: nil)
            XCTAssertFalse(result)
            
        } catch let error as NSError {
            
            print(error)
            XCTAssert(false)
        }
        
    }
    
}
