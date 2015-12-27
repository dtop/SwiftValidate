//
//  ValidatorEmailTests.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

class ValidatorEmailTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorCanHandleValidEmail() {
        
        // code coverage
        let _ = ValidatorEmail()
        
        let validator = ValidatorEmail() {
            $0.strict = true
            $0.validateHostnamePart = true
            $0.validateLocalPart = true
        }
        
        let mail = "werner~zwei@example.org"
        
        do {
            
            let result = try validator.validate(mail, context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleInvalidMailAddr() {
        
        let validator = ValidatorEmail() {
            $0.strict = true
            $0.validateHostnamePart = true
            $0.validateLocalPart = true
        }
        
        var result: Bool = false
        
        let mail1 = "§§§werner~zwei@example..org"
        let mail2 = "foobert@example@com"
        let mail3 = "foobert.example.com"
        
        do {
            
            result = try validator.validate(mail1, context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate(mail2, context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate(mail3, context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleInvalidLocalPart() {
        
        let validator = ValidatorEmail() {
            $0.strict = true
            $0.validateHostnamePart = true
            $0.validateLocalPart = true
        }
        
        let mail = "§§§werner~zwei@example.org"
        
        do {
            
            let result = try validator.validate(mail, context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleInvalidHostnamePart() {
        
        let validator = ValidatorEmail() {
            $0.strict = true
            $0.validateHostnamePart = true
            $0.validateLocalPart = true
        }
        
        let mail = "werner~zwei@exaghtasn%&/(&(&/(%$&§%$§$$mple.org"
        
        do {
            
            let result = try validator.validate(mail, context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleInvalidLength() {
       
        let validator = ValidatorEmail() {
            $0.strict = true
            $0.validateHostnamePart = true
            $0.validateLocalPart = true
        }
        
        var result: Bool = false
        
        let local = String(count: 65, repeatedValue: Character("a"))
        let host  = String(count: 256, repeatedValue: Character("b"))
        
        let mail1  = String(format: "%@@%@", local, "foo.com")
        let mail2  = String(format: "%@@%@", "foobert", host)
        
        do {
            
            result = try validator.validate(mail1, context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate(mail2, context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorCanHandleNil() {
        
        let validator = ValidatorEmail() {
            $0.strict = true
            $0.validateHostnamePart = true
            $0.validateLocalPart = true
        }
        
        let mail: String? = nil
        
        do {
            
            let result = try validator.validate(mail, context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorThrowsOnInvalidValueType() {
        
        let validator = ValidatorEmail() {
            $0.strict = true
            $0.validateHostnamePart = true
            $0.validateLocalPart = true
        }
        
        do {
            
            try validator.validate(true, context: nil)
            XCTAssert(false, "may never be reached")
            
        } catch let error as NSError {
            XCTAssertEqual("no valid string value given", error.localizedDescription)
        }
    }
}
