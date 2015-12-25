//
//  ValidationIteratorTests.swift
//  validate
//
//  Created by Danilo Topalovic on 25.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import validate

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
        validationIterator.registerChain(
            ValidatorChain() {
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
        validationIterator.registerChain(
            ValidatorChain() {
                $0.stopOnException = true
                $0.stopOnFirstError = true
            }
            <~~ ValidatorRequired()
            <~~ ValidatorStrLen() {
                $0.minLength = 5
                $0.maxLength = 5
            }
            <~~ ValidatorNumeric() {
                $0.canBeString = true
                $0.allowFloatingPoint = false
            },
            forKey: "zipcode"
        )
        
        // country (not required but if present between 3 and 50 chars
        validationIterator.registerChain(
            ValidatorChain() {
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
        
        validationIterator.resultForUnknownKeys = true
     
        // must not fail (unknown fields are ok)
        validationResult = validationIterator.validate(formResults)
        XCTAssertTrue(validationResult)
    }
}
