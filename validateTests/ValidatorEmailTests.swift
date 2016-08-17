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
        
        let local = String(repeating: "a".characters.first!, count: 65)
        let host  = String(repeating: "b".characters.first!, count: 256)
        
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
    
    func testValidatorCanHandleInsufficientInput() {
        
        let validator = ValidatorEmail() {
            $0.strict = true
            $0.validateHostnamePart = true
            $0.validateLocalPart = true
        }

        do {
            
            let result = try validator.validate("a@", context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testCanHandleMissingTld() {
        
        let validator = ValidatorEmail() {
            $0.strict = true
            $0.validateHostnamePart = true
            $0.validateLocalPart = true
            $0.validateToplevelDomain = true
        }
        
        var result: Bool = false
        let vMail = "foo@example.org"
        let iMail = "foo@example"
        
        do {
            
            result = try validator.validate(vMail, context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate(iMail, context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testCanHandleMissconfig() {
        
        let validator = ValidatorEmail() {
            $0.strict = true
            $0.validateHostnamePart = false
            $0.validateLocalPart = true
            $0.validateToplevelDomain = true
        }
        
        let iMail = "foo@example"
        
        do {
            
            _ = try validator.validate(iMail, context: nil)
            XCTAssert(false)
            
        } catch _ {
            XCTAssert(true)
        }
    }
}
