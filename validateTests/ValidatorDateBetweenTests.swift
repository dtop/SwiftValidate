//
//  ValidatorDateBetweenTests.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

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
        
        // code coverage
        let _ = ValidatorDateBetween()
        
        let validator = ValidatorDateBetween() {
            $0.allowNil = false
            $0.min = Date(timeIntervalSince1970: 0)
            $0.max = Date(timeIntervalSince1970: 86400)
            $0.maxInclusive = true
            $0.minInclusive = true
        }
        
        var result: Bool = false
        
        do {
            
            result = try validator.validate(NSDate(timeIntervalSince1970: 13420), context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate(NSDate(timeIntervalSince1970: 87459), context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate(NSDate(timeIntervalSince1970: 0), context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate(NSDate(timeIntervalSince1970: 86400), context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleStringValue() {
        
        // tests if you were born in the eighties ;-)
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let validator = ValidatorDateBetween() {
            $0.allowNil = false
            $0.min = df.date(from: "1980-01-01")
            $0.max = df.date(from: "1990-01-01")
            $0.maxInclusive = false
            $0.minInclusive = false
            $0.dateFormatter = df
        }
        
        var result: Bool = false
        
        do {
            
            result = try validator.validate("1994-10-22", context: nil)
            XCTAssertFalse(result)
            
            XCTAssertTrue(validator.errors.contains(validator.errorMessageNotBetween))
            
            result = try validator.validate("1982-03-30", context: nil)
            XCTAssertTrue(result)
            
            XCTAssertFalse(validator.errors.contains(validator.errorMessageNotBetween))
            
            result = try validator.validate("1990-01-01", context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate("1980-01-01", context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            
            XCTAssert(false)
        }
        
    }
    
    func testValidatorCanHandleNil() {
        
        let validator = ValidatorDateBetween() {
            $0.min = Date(timeIntervalSince1970: 0)
            $0.max = Date(timeIntervalSince1970: 86400)
            $0.maxInclusive = true
            $0.minInclusive = true
        }
        
        do {
            
            let value: String? = nil
            let result = try validator.validate(value, context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false, "thrown but may not throw")
        }
    }
    
    func testValidatorThrowsOnMissingPresets() {
        
        
        let validator = ValidatorDateBetween() {
            $0.maxInclusive = true
            $0.minInclusive = true
        }
        
        do {
            
            _ = try validator.validate("foo", context: nil)
            
        } catch let error as NSError {
            
            XCTAssertEqual("min and/or max dates are nil", error.localizedDescription)
        }
        
        validator.min = Date(timeIntervalSince1970: 0)
        
        do {
            
            _ = try validator.validate("foo", context: nil)
            
        } catch let error as NSError {
            
            XCTAssertEqual("min and/or max dates are nil", error.localizedDescription)
        }
    }
    
    func testValidatorThrowsOnIllegalValueType() {
        
        let validator = ValidatorDateBetween() {
            $0.min = Date(timeIntervalSince1970: 0)
            $0.max = Date(timeIntervalSince1970: 86400)
            $0.maxInclusive = true
            $0.minInclusive = true
        }
        
        do {
            
            let _ = try validator.validate(true, context: nil)
            XCTAssert(false, "may never be reached")
            
        } catch let error as NSError {
            
            XCTAssertEqual("Unreadable date format or datatype", error.localizedDescription)
        }
    }
    
    func testValidatorThrowsWhenNoFormatterGiven() {
        
        // tests if you were born in the eighties ;-)
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let validator = ValidatorDateBetween() {
            $0.allowNil = false
            $0.min = df.date(from: "1980-01-01")
            $0.max = df.date(from: "1990-01-01")
            $0.maxInclusive = false
            $0.minInclusive = false
        }
        
        do {
            
            let _ = try validator.validate("1994-10-22", context: nil)
            XCTAssert(false, "may never be reached")
            
        } catch let error as NSError {
            
            XCTAssertEqual("No date formatter given", error.localizedDescription)
        }
        
    }
}
