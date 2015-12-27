//
//  ValidatorAlnumTests.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

class ValidatorCharsetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorCanHandleCharset() {

        // code coverage
        let _ = ValidatorAlnum()
        let _ = ValidatorCharset()
        
        let validator = ValidatorAlnum() {
            $0.allowEmpty = true
        }
        
        var result: Bool = true
        
        do {
            
            result = try validator.validate("", context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate("abc♣adadad", context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate("dfgjkljgkldfg", context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleNil() {
        
        let validator = ValidatorCharset() {
            $0.allowEmpty = true
            $0.charset = NSCharacterSet.alphanumericCharacterSet()
        }
        
        var result: Bool = true
        
        do {
            
            let value: String? = nil
            result = try validator.validate(value, context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            
            XCTAssert(false)
        }
    }
    
    func testValidatorThrowsIfNoCharsetIsGiven() {
        
        let validator = ValidatorCharset() {
            $0.allowEmpty = true
        }
        
        do {
            
            try validator.validate(true, context: nil)
            XCTAssert(false, "may never be reached")
            
        } catch let error as NSError {
            
            XCTAssertEqual("no chaset given", error.localizedDescription)
        }
    }
    
    func testValidatorThrowsOnIllegalInput() {
        
        let validator = ValidatorCharset() {
            $0.allowEmpty = true
            $0.charset = NSCharacterSet.alphanumericCharacterSet()
        }
        
        do {
            
            try validator.validate(true, context: nil)
            XCTAssert(false, "may never be reached")
            
        } catch let error as NSError {
            
            XCTAssertEqual("Unable to validate chars in string incompatible value", error.localizedDescription)
        }
    }
    
}
