//
//  ValidatorCallbackTests.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

class ValidatorCallbackTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorIsCallingCallbackCallback() {

        // code coverage
        let _ = ValidatorCallback()
        
        let error: String = "error bla bla bla"
        
        let validator = ValidatorCallback() {
            $0.callback = {(validator: ValidatorCallback, value: Any?, context: [String : Any?]?) in
                
                if let boolVal = value as? Bool {
                    
                    if boolVal {
                        
                        return (true, nil)
                    } else {
                        
                        if nil != context {
                            
                            return (false, nil)
                        }
                        
                        return (false, error)
                    }
                }
                
                throw NSError(domain: "my domain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Not bool!!"])
            }
        }
        
        var result: Bool = true
        
        do {
            
            result = try validator.validate(true, context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate(false, context: nil)
            XCTAssertFalse(result)
            
            XCTAssertTrue(validator.errors.contains(error))
            
            result = try validator.validate(false, context: ["foo":"bar"])
            XCTAssertFalse(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValidatorThrowsIfNoCallbackIsGiven() {
        
        let validator = ValidatorCallback()
        
        do {
            
            let _ = try validator.validate("", context: nil)
            XCTAssert(false, "may never be reached")
            
        } catch let error as NSError {
            XCTAssertEqual("No callback given!", error.localizedDescription)
        }
    }
    
    func testValidatorCanHandleNil() {
        
        let validator = ValidatorCallback() {
            $0.callback = {
                (validator: ValidatorCallback, value: Any?, context: [String : Any?]?) in
                
                return (false, "error")
            }
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
}
