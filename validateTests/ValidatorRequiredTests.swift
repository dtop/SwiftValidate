//
//  ValidatorRequiredTests.swift
//  validate
//
//  Created by Danilo Topalovic on 25.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import SwiftValidate

class ValidatorRequiredTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValueIsRequired() {
     
        let validator = ValidatorRequired {
            $0.requirementCondition = nil
        }
        
        var result = false
        var testValue: String? = nil
        
        do {
            
            result = try validator.validate(testValue, context: nil)
            XCTAssertFalse(result)
            
            testValue = "not empty"
            
            result = try validator.validate(testValue, context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testValueRequirementConditionWorksProperly() {
        
        let validator = ValidatorRequired {
            $0.requirementCondition = {
                (value: Any?, context: [String: Any?]?) -> Bool in
                
                if let strValue = value as? String {
                    return strValue.isEmpty
                }
                
                return false
            }
        }
        
        var result = false
        var testValue: String? = nil
        
        do {
            
            result = try validator.validate(testValue, context: nil)
            XCTAssertFalse(result)
            
            testValue = "not empty"
            
            result = try validator.validate(testValue, context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testChainConsidersValueAsRequired() {
     
        let chain = ValidatorChain {
            $0.stopOnFirstError = true
            $0.stopOnException = true
        } <~~ ValidatorRequired {
            $0.requirementCondition = nil
        }
        
        var testValue: String? = nil
        
        XCTAssertFalse(chain.validate(testValue, context: nil))
        
        testValue = "not empty"
        
        XCTAssertTrue(chain.validate(testValue, context: nil))
    }
}
