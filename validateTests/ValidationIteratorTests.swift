//
//  ValidationIteratorTests.swift
//  validate
//
//  Created by Danilo Topalovic on 25.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

class ValidationIteratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidationIteratorValidatesAllValues() {

        /// code coverage
        let _ = ValidationIterator()
        
        var validationResult: Bool = false
        
        // form values given by some user
        let formResults: [String: Any?] = [
            "name": "John Appleseed",
            "street": "1456 Sesame Street",
            "zipcode": "01526",
            "city": "Somewhere",
            "country": nil
        ]
        
        let validationIterator = ValidationIterator() {
            $0.resultForUnknownKeys = false
        }
        
        // name, street, city
        validationIterator.register(
            chain: ValidatorChain() {
                    $0.stopOnException = true
                    $0.stopOnFirstError = true
                }
                <~~ ValidatorRequired()
                <~~ ValidatorEmpty()
                <~~ ValidatorStrLen() {
                    $0.minLength = 3
                    $0.maxLength = 50
                },
            forKeys: ["name", "street"]
        )
        
        // zipcode
        validationIterator.register(
            chain: ValidatorChain() {
                $0.stopOnException = true
                $0.stopOnFirstError = true
            }
            <~~ ValidatorRequired()
            <~~ ValidatorStrLen() {
                $0.minLength = 5
                $0.maxLength = 5
            }
            <~~ ValidatorNumeric() {
                $0.allowString = true
                $0.allowFloatingPoint = false
            },
            forKey: "zipcode"
        )
        
        // country (not required but if present between 3 and 50 chars
        validationIterator.register(
            chain: ValidatorChain() {
                $0.stopOnException = true
                $0.stopOnFirstError = true
            }
            <~~ ValidatorStrLen() {
                $0.minLength = 3
                $0.maxLength = 50
            },
            forKey: "country"
        )
        
        
        // must fail (unknown fields)
        validationResult = validationIterator.validate(formResults)
        XCTAssertFalse(validationResult)
        
        let fieldInError = validationIterator.isInError(key: "city")
        XCTAssertTrue(fieldInError)
        
        XCTAssertFalse(validationIterator.isInError(key: "nonexisting-key"))
        
        validationIterator.resultForUnknownKeys = true
     
        // must not fail (unknown fields are ok)
        validationResult = validationIterator.validate(formResults)
        XCTAssertTrue(validationResult)
    }
    
    func testValidationIteratorDispatchesErrors() {
        
        // form values given by some user
        let formResults: [String: Any?] = [
            "name": "John Appleseed",
            "street": "1456 Sesame Street",
            "custom": "1"
        ]
        
        let validationIterator = ValidationIterator() {
            $0.resultForUnknownKeys = false
        }
        
        // name, street, city
        validationIterator.register(
            chain: ValidatorChain() {
                $0.stopOnException = true
                $0.stopOnFirstError = true
            }
            <~~ ValidatorRequired()
            <~~ ValidatorEmpty()
            <~~ ValidatorStrLen() {
                $0.minLength = 3
                $0.maxLength = 50
            },
            forKeys: ["name", "street", "custom"]
        )
        
        let result = validationIterator.validate(formResults)
        XCTAssertFalse(result)
        
        let errors = validationIterator.getAllErrors()

        guard let customErrors = errors["custom"] else {
            XCTAssert(false, "no errors")
            return
        }
        
        XCTAssertTrue(customErrors.contains("please enter at least 3 characters"))
        
        guard let otherErrors = validationIterator.getErrorsFor(key: "custom") else {
            XCTAssert(false, "no errors")
            return
        }
        
        XCTAssertTrue(otherErrors.contains("please enter at least 3 characters"))
        
        if let _ = validationIterator.getErrorsFor(key: "wrong") {
            XCTAssert(false, "may not get anything")
        }
        
        let secondResult = validationIterator.validate(formResults)
        XCTAssertFalse(secondResult)
        
        // bug in rc6
        let secondErrors = validationIterator.getAllErrors()
        XCTAssertEqual(errors.count, secondErrors.count)
    }
}
